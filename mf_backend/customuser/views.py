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
            # user은 사용자 객체
            user, created = CustomUser.objects.get_or_create(username=user_data['email'])
            # 해당 사용자가 존재하지 않으면 created에 True가 할당됨
            print(user_data)    # debug: 제이슨 형태로 받아오기 성공
            print(user.username)         # debug: 이메일 값 받기 성공
            print(user)

            print(CustomUser.objects.all())
            print(created)      # debug: False 값이네
            test_pw = ""
            if created:
                print("created 내부로 들어옴")
                # print(user.email)
                print(CustomUser.username)
                user.set_password("test")
                # test_pw = user.set_unusable_password()
                # print("비밀번호: ", test_pw)

                # test_pw = user.set_password()

                user.email = user_data['email']
                user.save()     # 새로운 사용자 생성
            print(CustomUser.objects.get(username="test@example.com"))

            # authenticate는 사용자의 활성화 여부도 확인함
            print("활성화 여부: ", user.is_active)       # 활성화 상태는 맞음
            # user = authenticate(username=user_data['email'], password=None)     # ???
            user = authenticate(username=user_data['email'], password="test")  # 실험
            print("이게 다르다고?:", user_data['email'])
            print(user)
            if user is not None:
                login(request, user)
                token, created = Token.objects.get_or_create(user=user)
                return Response({'token': token.key})
            else:
                return Response({'error': 'Authentication failed.'}, status=status.HTTP_401_UNAUTHORIZED)

        except json.JSONDecodeError:
            return Response({'error': 'Invalid JSON format'}, status=status.HTTP_400_BAD_REQUEST)
