from rest_framework.response import Response
from rest_framework.parsers import JSONParser
from rest_framework.views import APIView
from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework import viewsets

from django.contrib.auth.decorators import login_required

from .serializer import FeedSerializer
from .models import Feed

from customuser.decorators import user_is_owner
from customuser.decorators import user_is_author


@api_view()
def test(request):
    if request.method == 'GET':
        return Response({'please': 'sadfasdfasd'})

# JsonResponse 와 그냥 Response?
# DRF에서 제공하는 Response 사용할 것


class FeedList(APIView):
    def get(self, request):
        feed = Feed.objects.all()
        serializer = FeedSerializer(feed, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    ## 미이이이친 이거 사용자 인증 설정 해서 post 되게금 하기

    @login_required
    @user_is_owner
    def post(self, request):
        # data = JSONParser().parse(request)
        serializer = FeedSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class FeedDetail(APIView):
    @user_is_owner
    def get(self, request, post_id):
        try:
            obj = Feed.objects.get(post_id=post_id)
        except Feed.DoesNotExist:
            msg = {"msg": "not found"}
            return Response(msg, status=status.HTTP_404_NOT_FOUND)

        serializer = FeedSerializer(obj)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @login_required
    @user_is_author
    def put(self, request, post_id):
        try:
            obj = Feed.objects.get(post_id=post_id)
        except Feed.DoesNotExist:
            msg = {"msg": "not found error"}
            return Response(msg, status=status.HTTP_404_NOT_FOUND)

        serializer = FeedSerializer(obj, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_205_RESET_CONTENT)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @login_required
    @user_is_author
    def delete(self, request, post_id):
        if Feed.user_id == request.user:
            try:
                obj = Feed.objects.get(post_id=post_id)
            except Feed.DoesNotExist:
                msg = {"msg": "not found error"}
                return Response(msg, status=status.HTTP_404_NOT_FOUND)
            obj.delete()
            return Response({"msg": "deleted!"})

        return Response({"msg": "no permission to delete"})


#####################################################################
# user_id 적용하여 데이터 조회


class UsersFeedList(APIView):
    def get(self, request, user_id):
        feed = Feed.objects.filter(user_id=user_id)
        serializer = FeedSerializer(feed, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


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
{
    "post_id": 3,
    "post_title": "testing!!!",
    "post_des": "using postman to test API!!!!",
    "post_image": "https://min02choi.github.io/assets/mypic.jpg",
    "post_date": "2023-11-01T00:00:00Z"
}
"""
