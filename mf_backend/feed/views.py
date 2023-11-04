from django.shortcuts import render
from django.http import HttpResponse, JsonResponse

from rest_framework.response import Response
from rest_framework.parsers import JSONParser
from rest_framework.views import APIView
from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework import viewsets

from .serializer import FeedSerializer
from .models import Feed


@api_view()
def test(request):
    if request.method == 'GET':
        return Response({'please': 'sadfasdfasd'})

# JsonResponse 와 그냥 Response?

class FeedList(APIView):
    def get(self, request):
        feed = Feed.objects.all()
        serializer = FeedSerializer(feed, many=True)
        return JsonResponse(serializer.data, status=status.HTTP_200_OK, safe=False)

    def post(self, request):
        # data = JSONParser().parse(request)
        serializer = FeedSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class FeedDetail(APIView):
    def get(self, request, id):
        try:
            obj = Feed.objects.get(post_id=id)
        except Feed.DoesNotExist:
            msg = {"msg": "not found"}
            return Response(msg, status=status.HTTP_404_NOT_FOUND)

        serializer = FeedSerializer(obj)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def put(self, request, id):
        try:
            obj = Feed.objects.get(post_id=id)
        except Feed.DoesNotExist:
            msg = {"msg": "not found error"}
            return Response(msg, status=status.HTTP_404_NOT_FOUND)

        serializer = FeedSerializer(obj, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_205_RESET_CONTENT)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, id):
        try:
            obj = Feed.objects.get(post_id=id)
        except Feed.DoesNotExist:
            msg = {"msg": "not found error"}
            return Response(msg, status=status.HTTP_404_NOT_FOUND)
        obj.delete()
        return Response({"msg": "deleted!"})


#####################################################################
# user_id 적용하여 데이터 조회


class FeedList2(APIView):
    def get(self, request, user_id):
        feed = Feed.objects.filter(user_id=user_id)
        serializer = FeedSerializer(feed, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class FeedDetail2(APIView):
    def get(self, request, user_id, id):
        try:
            obj = Feed.objects.get(user_id=user_id, post_id=id)
        except Feed.DoesNotExist:
            msg = {"msg": "not found"}
            return Response(msg, status=status.HTTP_404_NOT_FOUND)

        serializer = FeedSerializer(obj)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def put(self, request, user_id, id):
        try:
            obj = Feed.objects.get(user_id=user_id, post_id=id)
        except Feed.DoesNotExist:
            msg = {"msg": "not found error"}
            return Response(msg, status=status.HTTP_404_NOT_FOUND)

        serializer = FeedSerializer(obj, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_205_RESET_CONTENT)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, user_id, id):
        try:
            obj = Feed.objects.get(user_id=user_id, post_id=id)
        except Feed.DoesNotExist:
            msg = {"msg": "not found error"}
            return Response(msg, status=status.HTTP_404_NOT_FOUND)
        obj.delete()
        return Response({"msg": "deleted!"})


"""
@api_view(['GET'])
def feed_list(request):
    feed = Feed.objects.all()
    # print(feed)
    serializer = FeedSerializer(feed, many=True)
    print(serializer.data)
    return JsonResponse(serializer.data, safe=False)


@api_view(['POST'])
def feed_create(request):
    data = JSONParser().parse(request)
    serializer = FeedSerializer(feed, data=data)
    serializer.save()
    return JsonResponse(serializer.data)
"""

"""
# Feed 의 목록
def feed_list(request):
    if request.method == 'GET':
        feed = Feed.objects.all()
        # print(feed)
        serializer = FeedSerializer(feed, many=True)
        print(serializer.data)
        return JsonResponse(serializer.data, safe=False)

    elif request.method == 'POST':
        data = JSONParser().parse(request)
        # 추가 작성
"""

    
"""
{
    "post_id": 3,
    "post_title": "testing!!!",
    "post_des": "using postman to test API!!!!",
    "post_image": "https://min02choi.github.io/assets/mypic.jpg",
    "post_date": "2023-11-01T00:00:00Z"
}
"""
