from django.db import models


class Logintest(models.Model):
    user_id = models.IntegerField(primary_key=True)
    user_email = models.EmailField()
    user_pw = models.TextField()
    user_nkn = models.CharField(max_length=30)
    user_register = models.DateTimeField()
