from django.shortcuts import render

from django.http import HttpResponse, JsonResponse
from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.parsers import JSONParser
from rest_framework import viewsets
from .serializer import FeedSerializer
from .models import Feed

@api_view()
def test(request):
    if request.method == 'GET':
        return Response({'please': 'sadfasdfasd'})

# @api_view()


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


    

# class FeedDetail():