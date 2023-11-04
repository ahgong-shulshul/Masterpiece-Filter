from django.urls import path
from .views import UserList
# from . import views


urlpatterns = [
    path('', UserList.as_view()),
    # path('logintest/', views.index),
]