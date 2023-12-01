from django.db import models
from django.contrib.auth.models import User
# from logintest.models import Logintest

from logintest.models import Logintest
from customuser.models import CustomUser
from django.utils import timezone

# from users.models import User


class Feed(models.Model):
    post_id = models.BigAutoField(primary_key=True)
    post_title = models.CharField(max_length=256)
    post_des = models.TextField()
    post_image = models.URLField()
    post_date = models.DateTimeField(auto_now_add=True)
    user_id = models.ForeignKey(CustomUser, on_delete=models.CASCADE)


"""
플러터에서 받아야 할 json data 형태
{
    "post_title": "testing",
    "post_des": "using postman to test API",
    "post_image": "https://min02choi.github.io/assets/mypic.jpg"
}
"""