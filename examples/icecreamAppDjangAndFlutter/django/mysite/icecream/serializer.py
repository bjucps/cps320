#icecream\serializer.py
from rest_framework import serializers
from .models import Flavor, Order

class FlavorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Flavor
        fields = [
        'id',
        'name'
        ]

class OrderSerializer(serializers.ModelSerializer) :
    scoops = FlavorSerializer(read_only=True, many=True)
    class Meta :
        model = Order
        fields = [
            'id',
            'is_completed',
            'customer_name',
            'scoops',
        ]
