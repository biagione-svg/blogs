from django.shortcuts import render,get_objects_or_404
from .models import Post
def post_list(request):
    posts=Post.published.all()
    return render(request, 'blog/post/list.html',
                  {'posts':posts})

# Create your views here.
