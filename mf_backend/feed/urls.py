from django.urls import path
from .views import FeedList, FeedDetail

urlpatterns = [
    # path('testing/', views.feed_list),
    path('post/', FeedList.as_view()),
    path('post/<int:id>/', FeedDetail.as_view()),
]