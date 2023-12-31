from django.urls import path
from .views import FeedList, FeedDetail, UsersFeedList, UsersFeedDetail


urlpatterns = [
    path('', FeedList.as_view()),
    path('<int:post_id>/', FeedDetail.as_view()),

    path('<int:user_id>/post/', UsersFeedList.as_view()),
    path('<int:user_id>/post/<int:post_id>/', UsersFeedDetail.as_view()),
]