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


class UserDetail(APIView):
    @method_decorator(login_required, name='dispatch')
    def get(self, request):
        cur_user = request.user
        print(request.user)         # username
        print(request.user.email)   # email
        cususer = CustomUser.objects.filter(username=cur_user)
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
        try:
            obj = CustomUser.objects.get(username=cur_user)
        except CustomUser.DoesNotExist:
            msg = {"msg": "User not found error"}
            return Response(msg, status=status.HTTP_404_NOT_FOUND)
        serializer = CustomUserSerializer(obj, data=request.data)
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


"""
{
    "username": "Choi Min Young"
}
"""