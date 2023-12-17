from django.db import models
from django.contrib.auth.models import AbstractUser, Group, Permission
from django.contrib.auth.models import User


class CustomUser(AbstractUser):

    groups = models.ManyToManyField(Group, related_name='customuser_set')
    user_permissions = models.ManyToManyField(
        Permission, related_name='customuser_set'
    )
    profile_pic = models.URLField(null=True)
    background_pic = models.URLField(null=True)
    total_posts = models.PositiveIntegerField()

    def update_total_posts(self):
        from feed.models import Feed
        print("피드")
        print(self.id)      # 확인
        print(Feed.user_id) # 확인
        self.total_posts = Feed.objects.filter(user_id=self.id).count()
        self.save()


    # def __init__(self, *args, **kwargs):
    #     super().__init__(*args, **kwargs)
    #     from feed.models import Feed
    #     print("피드")
    #     print(self.id)      # 확인
    #     print(Feed.user_id) # 확인
    #     self.total_posts = Feed.objects.filter(user_id=self.id).count()
    #     self.save()


# def get_username():


"""
플러터에서 받아야 할 json 데이터
{
    "email": "test36@example.com"
}
"""