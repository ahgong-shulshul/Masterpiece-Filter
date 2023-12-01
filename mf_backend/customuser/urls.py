from django.urls import path
from .views import SocialLoginAPIView, UsersList


urlpatterns = [
    path('social-login/', SocialLoginAPIView.as_view()),
    path('list/', UsersList.as_view()),
]