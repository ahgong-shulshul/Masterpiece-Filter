import json
from django.contrib.auth.decorators import login_required
from django.contrib.auth.mixins import LoginRequiredMixin
from django.utils.decorators import method_decorator

from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status

from customuser.models import CustomUser
from .serializer import FeedSerializer
from .models import Feed

from customuser.decorators import user_is_author
from datetime import datetime


# URL: feed
class FeedList(APIView):
    @method_decorator(login_required, name='dispatch')
    def get(self, request):
        print(" >> 로그인 사용자: ", request.user)
        cur_user = request.user
        feed = Feed.objects.filter(user_id=cur_user)
        if feed.exists():
            serializer = FeedSerializer(feed, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        else:
            msg = {"msg": "No Feed"}
            return Response(msg, status=status.HTTP_404_NOT_FOUND)


    # 두 개의 json 함치기 위해선 두개의 데이터를 dict 형태로 바꾸고 dict를 합친 뒤, 합친 dict를 json으로 바꾸어주어야 함
    @method_decorator(login_required, name='dispatch')
    def post(self, request):
        print(" >> 로그인 사용자: ", request.user)
        cur_user_id = str(request.user.id)      # str 안하면 객체임
        make_userid = '{"user_id": "' + cur_user_id + '"}'
        dict_userid = json.loads(make_userid)       # dict 로 변경

        dict_request = request.data
        combined_dict = {**dict_request, **dict_userid}
        # combined_json = json.dumps(combined_dict)
        # print(combined_json)

        serializer = FeedSerializer(data=combined_dict)     # dict 전달
        if serializer.is_valid():
            serializer.save()
            #### 상관 없으려나?
            user_instance = CustomUser.objects.get(username=request.user)
            user_instance.update_total_posts()

            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# URL: feed/{post_id}
class FeedDetail(LoginRequiredMixin, APIView):
    # 로그인이 안 되어있을 시 /accounts/login/ 으로 리다이렉트 해줌
    def dispatch(self, request, *args, **kwargs):
        # 부모 클래스의 dispatch 메소드 호출
        response = super().dispatch(request, *args, **kwargs)
        # 만약 로그인되지 않은 경우, LoginRequiredMixin이 리디렉션을 처리
        return response

    @method_decorator(login_required, name='dispatch')
    def get(self, request, post_id):
        print(" >> 로그인 사용자: ", request.user)    # username 반환
        print(" >> 로그인 사용자: ", request.auth)    # 토큰값 반환
        try:
            obj = Feed.objects.get(post_id=post_id)
        except Feed.DoesNotExist:
            msg = {"msg": "not found"}
            return Response(msg, status=status.HTTP_404_NOT_FOUND)

        serializer = FeedSerializer(obj)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @method_decorator(user_is_author, name='dispatch')
    def put(self, request, post_id):
        cur_user_id = str(request.user.id)
        print("this modified: ", cur_user_id)

        make_userid = '{"user_id": "' + cur_user_id + '"}'
        dict_userid = json.loads(make_userid)

        dict_request = request.data
        combined_dict = {**dict_request, **dict_userid}

        try:
            obj = Feed.objects.get(post_id=post_id)
        except Feed.DoesNotExist:
            msg = {"msg": "not found error"}
            return Response(msg, status=status.HTTP_404_NOT_FOUND)

        serializer = FeedSerializer(instance=obj, data=combined_dict)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_205_RESET_CONTENT)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @method_decorator(user_is_author, name='dispatch')
    def delete(self, request, post_id):
        try:
            obj = Feed.objects.get(post_id=post_id)
        except Feed.DoesNotExist:
            msg = {"msg": "not found error"}
            return Response(msg, status=status.HTTP_404_NOT_FOUND)
        feed_author = obj.user_id

        if feed_author == request.user:
            obj.delete()
            return Response({"msg": "deleted!"})
        return Response({"msg": "no permission to delete"})


# URL: feed/{user_id}/post
class UsersFeedList(APIView):
    def get(self, request, user_id):
        feed = Feed.objects.filter(user_id=user_id)
        serializer = FeedSerializer(feed, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


# URL: feed/{user_id}/post/{post_id}
class UsersFeedDetail(APIView):
    def get(self, request, user_id, post_id):
        try:
            obj = Feed.objects.get(user_id=user_id, post_id=post_id)
        except Feed.DoesNotExist:
            msg = {"msg": "not found"}
            return Response(msg, status=status.HTTP_404_NOT_FOUND)

        serializer = FeedSerializer(obj)
        return Response(serializer.data, status=status.HTTP_200_OK)

    
"""
# post 내부의 데이터
{
    "post_id": 3,
    "post_title": "testing!!!",
    "post_des": "using postman to test API!!!!",
    "post_image": "https://min02choi.github.io/assets/mypic.jpg",
    "post_date": "2023-11-01T00:00:00Z",
    "user_id": 36
}

# 플러터에서 장고로 게시물 수정할 때의 정보
# Feed 모델 조금 수정함(아래 데이터 + header에 토큰 값을 장고에 request)
- id: auto 증가
- date: 현재날짜로 설정
- user_id: 현재 로그인한 user로 저장(token으로 전달)
{
    "post_title": "testing!!!",
    "post_des": "using postman to test API!!!!",
    "post_image": "https://min02choi.github.io/assets/mypic.jpg"
}


# 플러터에서 장고에 로그인/회원가입을 요청할 때의 json
{
    "email": "test36@example.com"
}
"""

"""
# 내 피드 방문했을 때 각 게시물 클릭
- GET: feed/<int:post_id>

# 친구 피드 방문했을 때 각 게시물 클릭
- GET: <int:user_id>/post/<int:post_id>

# 반환 json은 동일
{
    "post_id": 25,
    "post_title": "Coloso Picture",
    "post_des": "Wow they used google storage... 알려줘",
    "post_image": "https://storage.googleapis.com/static.fastcampus.co.kr/prod/uploads/202211/090727-914/illust-ekina-coursecard.png",
    "post_date": "2023-12-18T17:14:00.420472+09:00",
    "user_id": 47
}
"""
