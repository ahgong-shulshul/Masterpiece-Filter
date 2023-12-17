import json
from django.contrib import auth
from django.contrib.auth import authenticate
from django.utils.decorators import method_decorator
from django.contrib.auth.decorators import login_required

from rest_framework.views import APIView
from rest_framework.authtoken.models import Token
from rest_framework.response import Response
from rest_framework import status

from .models import CustomUser
from .serializers import CustomUserSerializer


# URL: customuser/social-login
class SocialLoginAPIView(APIView):
    def post(self, request):
        try:
            user_data = json.loads(request.body.decode('utf-8'))
            # 사용자를 생성/가져오기(기존에 있는 사용자의 경우 created에 False 할당)
            # user은 사용자 객체
            user, created = CustomUser.objects.get_or_create(username=user_data['email'])
            test_pw = ""
            if created:
                print(CustomUser.username)
                user.set_password("test")
                # test_pw = user.set_unusable_password()
                user.email = user_data['email']
                user.save()     # 새로운 사용자 생성

            # user = authenticate(username=user_data['email'], password=None)     # ???
            user = authenticate(username=user_data['email'], password="test")  # 실험
            print(user)
            if user is not None:
                auth.login(request, user)
                print(user.is_authenticated)
                token, created = Token.objects.get_or_create(user_id=user.id)     # 이게 안되는데
                print(token.key)        # 확인
                print(token)            # 확인
                return Response({'token': token.key})
            else:
                return Response({'error': 'Authentication failed.'}, status=status.HTTP_401_UNAUTHORIZED)

        except json.JSONDecodeError:
            return Response({'error': 'Invalid JSON format'}, status=status.HTTP_400_BAD_REQUEST)


# URL: customuser/list
# 본인은 제외한 목록이 나옴
class UsersList(APIView):
    @method_decorator(login_required)
    def get(self, request):
        users = CustomUser.objects.exclude(username=request.user)
        serializer = CustomUserSerializer(users, many=True)
        return Response(serializer.data)


# URl: customuser/mypage
class UserDetail(APIView):
    @method_decorator(login_required, name='dispatch')
    def get(self, request):
        cur_user = request.user
        print("cur_user")
        print(request.user)         # username
        print(request.user.email)   # email
        cususer = CustomUser.objects.filter(username=cur_user)

        user_instance = CustomUser.objects.get(username=request.user)
        user_instance.update_total_posts()

        print("user_instance: ", user_instance)

        if cususer.exists():
            serializer = CustomUserSerializer(cususer, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        else:
            msg = {"msg": "User not found error"}
            return Response(msg, status=status.HTTP_404_NOT_FOUND)

    # 플러터에서 이메일 변경 안되게 막을것. username을 바꿀것
    # username이 unique라서 괜찮을수도
    @method_decorator(login_required, name='dispatch')
    def put(self, request):
        cur_user = request.user

        user_instance = CustomUser.objects.get(username=request.user)
        total_post = user_instance.update_total_posts()

        print("total_post: ", total_post)
        print("이건 되니?: ", user_instance.total_posts)
        print("request.data: ", request.data)

        # total_post를 request.data 에 합치는 과정
        tot_posts_dic = '{"total_posts": "' + str(user_instance.total_posts) + '"}'
        total_post = json.loads(tot_posts_dic)

        dict_request = request.data
        combined_dict = {**dict_request, **total_post}

        try:
            obj = CustomUser.objects.get(username=cur_user)
        except CustomUser.DoesNotExist:
            msg = {"msg": "User not found error"}
            return Response(msg, status=status.HTTP_404_NOT_FOUND)
        # serializer = CustomUserSerializer(obj, data=request.data)
        serializer = CustomUserSerializer(obj, data=combined_dict)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_205_RESET_CONTENT)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @method_decorator(login_required, name='dispatch')
    def delete(self, request):
        cur_user = request.user
        try:
            obj = CustomUser.objects.get(username=cur_user)
        except CustomUser.DoesNotExist:
            msg = {"msg": "User not found error"}
            return Response(msg, status=status.HTTP_404_NOT_FOUND)
        obj.delete()
        return Response({"msg": "deleted!"})

class TotalPost(APIView):
    def get(self, request):
        user_instance = CustomUser.objects.get(username=request.user)
        user_instance.update_total_posts()
        # obj = CustomUser.objects.get(username=request.user)
        # serializer = CustomUserSerializer(obj, data=request.data)
        serializer = CustomUserSerializer(request.user)
        return Response(serializer.data)



"""
# 로그인 요청: 구글에서 인증받은 이메일을 전달
{
    "email": "min02choi@naver.com"
}

# 닉네임 변경할 때
{
    "username": "Choi Min Young",
    "profile_pic": "https://cdn.newspenguin.com/news/photo/202104/4406_13982_1239.jpg",
    "background_pic": "https://pbs.twimg.com/media/Dky_NvgU8AAS3WO.jpg"
}
"""