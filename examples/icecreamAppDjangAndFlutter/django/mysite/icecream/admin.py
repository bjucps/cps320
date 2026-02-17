from django.contrib import admin
from icecream.models import Flavor as FlavorModel, Order as OrderModel, Topping as ToppingModel


class OrderAdmin(admin.ModelAdmin) :
    list_display = ('customer_name', 'get_scoops', 'is_completed')
    list_filter = ['scoops', 'is_completed']

    def get_scoops (self, obj) :
        return [flavor.name for flavor in obj.scoops.all()]
    
class ToppingAdmin(admin.ModelAdmin) :
    list_display = ('name', 'desc')
        
admin.site.register(FlavorModel)
admin.site.register(OrderModel, OrderAdmin)
admin.site.register(ToppingModel, ToppingAdmin)