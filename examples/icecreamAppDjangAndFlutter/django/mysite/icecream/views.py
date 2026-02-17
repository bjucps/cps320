#from django.http import HttpResponse
from icecream.models import Flavor as FlavorModel, Order as OrderModel
from .serializer import FlavorSerializer, OrderSerializer
from rest_framework import viewsets
from django.contrib.auth.decorators import login_required
from django.views.decorators.csrf import csrf_protect
from django.shortcuts import render

@login_required
@csrf_protect
def index(request):
    if "submit" in request.POST :
        context = create_and_confirm_order(request)
    else :
        context = get_default_context(request)
    return render (request, 'icecream/create_order.html', context)

def create_and_confirm_order (request) :
    flavors = FlavorModel.objects.all()
    new_order = create_order(request, flavors)
    
    message = "Added " + str(new_order)
    return {'flavors': flavors, 'message': message, 
               'title': 'Ice Cream Index', 'subtitle': 'Order Form Confirmation', 
               'site_header': 'Ice Cream Time'}
    

def create_order(request, flavors):
    customer_name = request.POST['customer_name']
    new_order = OrderModel.objects.create(customer_name=customer_name)
    for flavor in flavors :
        if str(flavor.id) in request.POST :
            new_order.scoops.add(flavor)
    new_order.save()
    return new_order



def get_default_context (request) :
    flavors = FlavorModel.objects.all()
    name = request.user.first_name + " " + request.user.last_name
    message = "Hello, " + name + ". Please create an order:"
    return {'flavors': flavors, 'message': message, 
               'title': 'Ice Cream Index', 'subtitle': 'Order Form', 
               'site_header': 'Ice Cream Time'}


class Flavor(viewsets.ModelViewSet):
    queryset = FlavorModel.objects.all()
    serializer_class = FlavorSerializer


class Order(viewsets.ModelViewSet):
    queryset = OrderModel.objects.all()
    serializer_class = OrderSerializer
