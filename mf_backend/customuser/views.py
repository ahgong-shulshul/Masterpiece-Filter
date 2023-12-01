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
                return Response({'token': token.key})
            else:
                return Response({'error': 'Authentication failed.'}, status=status.HTTP_401_UNAUTHORIZED)

        except json.JSONDecodeError:
            return Response({'error': 'Invalid JSON format'}, status=status.HTTP_400_BAD_REQUEST)


class UsersList(APIView):
    @method_decorator(login_required)
    def get(self, request):
        users = CustomUser.objects.exclude(username=request.user)
        serializer = CustomUserSerializer(users, many=True)
        return Response(serializer.data)
