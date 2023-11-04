from django.urls import path
# from .views import FeedList, FeedDetail, FeedDetail2

from .views import FeedList, FeedDetail, FeedList2, FeedDetail2

urlpatterns = [
    # path('testing/', views.feed_list),
    path('post/', FeedList.as_view()),
    path('post/<int:id>/', FeedDetail.as_view()),

    path('<int:user_id>/post/', FeedList2.as_view()),
    path('<int:user_id>/post/<int:id>/', FeedDetail2.as_view()),
]