from django.shortcuts import render
from django.urls import path
from django.contrib.auth import views as auth_views


def index(request):
    return render(request, 'accountapp/login.html')
