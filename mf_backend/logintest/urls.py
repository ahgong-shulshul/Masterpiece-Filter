from django.urls import path
from . import views


urlpatterns = [
    path('logintest/', views.index),
]