from django.db import models
from django.contrib.auth.models import AbstractUser, Group, Permission
from django.contrib.auth.models import User


class CustomUser(AbstractUser):
    groups = models.ManyToManyField(Group, related_name='customuser_set')
    user_permissions = models.ManyToManyField(
        Permission, related_name='customuser_set'
    )
    # email = models.EmailField(unique=True)
    profile_pic = models.URLField(default="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXuXsaviLIPb3S629icV94cNbS7FM9XAC5N7k_w1FYlJmxqqErBLMQ1gFiXxH0Y9APPEQ&usqp=CAU")
    background_pic = models.URLField(default="https://pbs.twimg.com/media/Dky-Pc1VsAAkAjx.jpg")
    total_posts = models.PositiveIntegerField(default=0)

    def update_total_posts(self):
        from feed.models import Feed
        print(self.id)      # 확인
        self.total_posts = Feed.objects.filter(user_id=self.id).count()
        self.save()

    # def get_username(self):
    #     print("Customuser 안: ", self.username)
    #     return self.username



"""
플러터에서 로그인 시 받아야 할 json 데이터
- 처음 로그인 시 받은 email 값으로 username 지정. 추후 username을 수정함.
{
    "email": "test36@example.com"
}
"""