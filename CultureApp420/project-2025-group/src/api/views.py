from django.shortcuts import render
from rest_framework.decorators import api_view, permission_classes
from rest_framework_api_key.permissions import HasAPIKey
from rest_framework.response import Response
from api.models import Event, EventSerializer
from frontend.models import ProgramLeaflet, ProgramLeafletSerializer
from django.http import JsonResponse, HttpResponse
from rest_framework.parsers import JSONParser
from rest_framework import status
# Create your views here.

@api_view(http_method_names=['GET', 'POST'])
@permission_classes([HasAPIKey])
def event_list(request):
    if request.method == 'GET':
        events = ProgramLeaflet.objects.all()
        serializer = ProgramLeafletSerializer(events, many=True)
        return Response(serializer.data)

@api_view()
@permission_classes([HasAPIKey])
def event_detail(request, pk):
    try: 
        event = ProgramLeaflet.objects.get(pk=pk)
    except:
        return HttpResponse(status=404)
    if request.method == 'GET':
        serializer = ProgramLeafletSerializer(event)
        return Response(serializer.data)

def event_page(request, pk):
    try:
        event = ProgramLeaflet.objects.get(pk=pk)
    except:
        return HttpResponse(status=404)
    return render(request, 'api/event.html', {'event': event})
    
        






@api_view()
def sitemaps(request):
    return Response({"The event is located": "somewhere"})

@api_view()
def parent_info(request):
    return Response({"Parent": "Info"})