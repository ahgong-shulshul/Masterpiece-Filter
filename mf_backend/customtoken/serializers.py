from dj_rest_auth.serializers import TokenSerializer
from rest_framework.authtoken.serializers import AuthTokenSerializer
from rest_framework.authtoken.models import Token


class CustomTokenSerializer(TokenSerializer):
    class Meta:
        model = Token
        fields = ('key', 'user',)
