from django.contrib import admin
from django.urls import path, include

# import social_login

urlpatterns = [
    path('admin/', admin.site.urls),

    path('social_login/', include('social_login.urls')),
]
