from django.urls import path
from .views import SocialLoginAPIView, SocialLoginAPITest, LoginTest


urlpatterns = [
    path('social-login/', SocialLoginAPIView.as_view()),
    path('social-login2/', SocialLoginAPITest.as_view()),
    path('login-test/', LoginTest.as_view()),
]