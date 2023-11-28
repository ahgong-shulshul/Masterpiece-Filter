from django.urls import path
from .views import SocialLoginAPIView, SocialLoginAPITest


urlpatterns = [
    path('social-login/', SocialLoginAPIView.as_view()),
    path('social-login2/', SocialLoginAPITest.as_view())
]