from rest_framework import serializers
from .models import CustomUser


class CustomUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ('id', 'username', 'email', 'date_joined', 'profile_pic', 'background_pic', 'total_posts')

class CustomUserSerializerSearch(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ('id', 'username', 'profile_pic')
