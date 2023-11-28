from rest_framework.authentication import TokenAuthentication
from .serializers import CustomTokenSerializer


class CustomTokenAuthentication(TokenAuthentication):
    serializer_class = CustomTokenSerializer
