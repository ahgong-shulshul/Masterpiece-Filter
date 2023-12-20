from .models import Logintest
from rest_framework import serializers


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = Logintest
        fields = '__all__'
