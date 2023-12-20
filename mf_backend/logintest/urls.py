from django.urls import path
from .views import UserList
# from . import views

# 회원 조회
# 회원 정보 수정
# 마이페이지 정보


urlpatterns = [
    # path('', UserList.as_view()),
    # path('logintest/', views.index),
    path('users/', UserList.as_view()),   # 전체 조회
    # path('users/<int:user_id>', ),         # 특정 유저 조회/이메일 혹은 번호..
]