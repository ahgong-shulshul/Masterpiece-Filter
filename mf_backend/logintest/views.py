from django.shortcuts import render
from rest_framework.response import Response

from django.shortcuts import render
from django.http import HttpResponse, JsonResponse

from rest_framework.response import Response
from rest_framework.parsers import JSONParser
from rest_framework.views import APIView
from rest_framework.decorators import api_view
from rest_framework import status
from rest_framework import viewsets
from django.contrib.auth import authenticate, login, logout

from .serializer import UserSerializer
from .models import Logintest


def index():
    return Response({'please': 'sadfasdfasd'})



class UserLogin(APIView):
    def post(self, request):
        # user = request.POST['user_id']
        return ("")


# 회원 전체 조회
class UserList(APIView):
    def get(self, request):
        user = Logintest.objects.all()
        serializer = UserSerializer(user, many=True)
        return JsonResponse(serializer.data, status=status.HTTP_200_OK, safe=False)


# class UserDetail(APIView):
#     def get(self, request, user_id):
