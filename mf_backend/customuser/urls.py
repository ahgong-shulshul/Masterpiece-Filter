from django.urls import path
from .views import SocialLoginAPIView


urlpatterns = [
    path('social-login/', SocialLoginAPIView.as_view())
]