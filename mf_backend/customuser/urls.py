from django.urls import path
from .views import SocialLoginAPIView, UsersList, UserDetail, TotalPost, FriendDetail


urlpatterns = [
    path('social-login/', SocialLoginAPIView.as_view()),
    path('list/', UsersList.as_view()),
    path('mypage/', UserDetail.as_view()),

    path('total-post', TotalPost.as_view()),
    path('<int:user_id>/detail', FriendDetail.as_view()),
]