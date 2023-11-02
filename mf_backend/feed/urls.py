from django.urls import path
from .views import FeedList, FeedDetail

urlpatterns = [
    # path('testing/', views.feed_list),
    path('testing/', FeedList.as_view()),
    path('testing/<int:id>/', FeedDetail.as_view()),
]