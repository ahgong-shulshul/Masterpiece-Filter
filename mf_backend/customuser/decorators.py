from functools import wraps
from django.http import HttpResponseForbidden
from feed.models import Feed


def user_is_owner(view_func):
    @wraps(view_func)
    def wrapper(request, *args, **kwargs):
        # 현재 로그인한 사용자와 요청된 사용자를 가져오기
        current_user = request.user
        requested_user_id = int(request.GET.get('user_id'))

        # 사용자가 다르면 권한이 없음을 반환
        if current_user.id != requested_user_id:
            return HttpResponseForbidden("Permission Denied: You are not the owner of this resource.")

        # 사용자가 같으면 원래의 뷰 함수를 실행
        return view_func(request, *args, **kwargs)

    return wrapper


def user_is_author(view_func):
    @wraps(view_func)
    def wrapper(request, post_id, *args, **kwargs):
        # 게시글 가져오기 (Post 모델에 맞게 수정해주세요)
        feed = Feed.objects.get(id=post_id)

        # 현재 요청한 사용자와 게시글 작성자의 아이디 비교
        if request.user.id == feed.user_id:     # 주의
            return view_func(request, post_id, *args, **kwargs)
        else:
            return HttpResponseForbidden("Permission Denied: You are not the author of this post.")

    return wrapper


#