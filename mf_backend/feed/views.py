from django.shortcuts import render

from django.http import HttpResponse
from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response


@api_view()
def test(request):
    return Response({'please': 'sadfasdfasd'})
