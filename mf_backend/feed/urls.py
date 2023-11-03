from django.urls import path
# from .views import FeedList, FeedDetail, FeedDetail2

from .views import FeedList, FeedDetail, FeedList2

urlpatterns = [
    # path('testing/', views.feed_list),
    path('feed/', FeedList.as_view()),
    path('feed/<int:id>/', FeedDetail.as_view()),

    path('<int:user_id>/feed/', FeedList2.as_view()),
    # path('<int:user_id>/feed/<int:id>/', FeedDetail2.as_view()),
]