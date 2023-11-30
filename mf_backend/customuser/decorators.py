from functools import wraps
from django.http import HttpResponseForbidden
from django.contrib.auth.mixins import LoginRequiredMixin
from django.views import View


from feed.models import Feed

# from feed.views import FeedDetail


# user_is_owner: 현재 사용자(user)가 해당 게시글의 작성자인지 확인

def user_is_owner(view_func):
    @wraps(view_func)
    def wrapper(request, *args, **kwargs):
        # 현재 로그인한 사용자와 요청된 사용자를 가져오기
        print(request.user)
        current_user = request.user
        print(current_user)
        requested_user_id = int(request.GET.get('user_id'))
        print(requested_user_id)

        # 사용자가 다르면 권한이 없음을 반환
        if current_user.id != requested_user_id:
            return HttpResponseForbidden("Permission Denied: You are not the owner of this resource.")

        # 사용자가 같으면 원래의 뷰 함수를 실행
        return view_func(request, *args, **kwargs)

    return wrapper


def user_is_author(view_func):
    @wraps(view_func)
    def wrapper(request, *args, **kwargs):
        post_id = kwargs.get("post_id")
        feed = Feed.objects.get(post_id=post_id)
        print("???: ", feed.user_id)        # 사용자의 이메일이 반환됨
        print("asdfasdf")
        print(request)                      # FeedDetail 뷰 객체가 넘어옴
        # 현재 요청한 사용자와 게시글 작성자의 아이디 비교
        if request.user.id == feed.user_id:     # 주의
            return view_func(request, post_id, *args, **kwargs)
        else:
            return HttpResponseForbidden("Permission Denied: You are not the author of this post.")

    return wrapper


#