from django.db import models

# 유저 아이디 임포트(accountapp? 하여튼 그 클래스)
# from users.models import User


class Feed(models.Model):
    post_id = models.BigIntegerField(primary_key=True)
    post_title = models.CharField(max_length=256)
    post_des = models.TextField()
    post_image = models.URLField()
    post_date = models.DateTimeField()
    # user_id = models.ForeignKey(User, on_delete=models.CASCADE)


"""
{
    "post_id": 3,
    "post_title": "testing",
    "post_des": "using postman to test API",
    "post_image": "testing.png",
    "post_date": "2023-11-01"
}
"""