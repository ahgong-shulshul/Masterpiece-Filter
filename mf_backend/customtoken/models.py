# models.py
from django.contrib.auth import get_user_model
from rest_framework.authtoken.models import Token
from django.db import models


class CustomUserToken(Token):
    custom_user = models.ForeignKey(get_user_model(), related_name='customuser_tokens', on_delete=models.CASCADE, null=True)

