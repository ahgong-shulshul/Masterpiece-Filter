from django.contrib import admin
from django.urls import path, include
from django.contrib.auth import views as auth_views
from . import views
# from . import views

urlpatterns = [
    # path('', mf_backend.accountapp.views.index),
    path('', views.index),
    path('accounts/', include('allauth.urls')),
    # path('accounts/login/', )
    # path('accounts/login/', auth_views.LoginView.as_view(template_name='accountapp/login.html'), name='login'),
]