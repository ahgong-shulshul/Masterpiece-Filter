import json

from django.contrib.auth import authenticate, login
from django.shortcuts import render
from rest_framework import status
from rest_framework.authtoken.models import Token

from rest_framework.views import APIView
from rest_framework.response import Response
from .models import CustomUser


class SocialLoginAPIView(APIView):
    def post(self, request):
        try:
            user_data = json.loads(request.body.decode('utf-8'))
            # 사용자를 생성/가져오기(기존에 있는 사용자의 경우 created에 False 할당)
            user, created = CustomUser.objects.get_or_create(username=user_data['email'])
            # 해당 사용자가 존제하지 않으면 created에 True가 할당됨
            if created:
                user.set_unusable_password()
                user.email = user_data['email']
                user.save()     # 새로운 사용자 생성

            user = authenticate(username=user_data['email'], password=None)
            if user is not None:
                login(request, user)
                token, created = Token.objects.get_or_create(user=user)
                return Response({'token': token.key})
            else:
                return Response({'error': 'Authentication failed.'}, status=status.HTTP_401_UNAUTHORIZED)

        except json.JSONDecodeError:
            return Response({'error': 'Invalid JSON format'}, status=status.HTTP_400_BAD_REQUEST)
