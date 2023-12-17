from django.urls import path
from .views import SocialLoginAPIView, UsersList, UserDetail, TotalPost


urlpatterns = [
    path('social-login/', SocialLoginAPIView.as_view()),
    path('list/', UsersList.as_view()),
    path('mypage/', UserDetail.as_view()),

    path('total-post', TotalPost.as_view())
]