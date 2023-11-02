from .models import Feed
from rest_framework import serializers


class FeedSerializer(serializers.ModelSerializer):
    class Meta:
        model = Feed
        fields = [
            "post_id",
            "post_title",
            "post_des",
            "post_image",
            "post_date",
        ]
        # 전체 칼럼에 대해서
        # fields = '__all__'