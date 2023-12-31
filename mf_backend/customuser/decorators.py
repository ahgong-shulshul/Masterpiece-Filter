from functools import wraps
from django.http import HttpResponseForbidden, HttpResponse

from feed.models import Feed

# user_is_owner: 현재 사용자(user)가 해당 게시글의 작성자인지 확인

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


# user_is_author: 현재 사용자(user)가 해당 게시글의 작성자(author)인지 확인
def user_is_author(view_func):
    @wraps(view_func)
    def wrapper(request, *args, **kwargs):
        post_id = kwargs.get("post_id")
        try:
            feed = Feed.objects.get(post_id=post_id)        # 해당 포스트 번호의 아이디를 받아
        except Feed.DoesNotExist:
            # return HttpResponse({"msg": "Feed does not exist."})
            return HttpResponse("Error: Feed does not exist.")
        print(request)
        print(request.user)
        print(request.user.id)
        # 현재 요청한 사용자와 게시글 작성자의 아이디 비교
        if request.user == feed.user_id:     # 주의
            return view_func(request, *args, **kwargs)
        else:
            return HttpResponseForbidden("Permission Denied: You are not the author of this post.")
    return wrapper
