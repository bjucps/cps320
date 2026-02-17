from django.test import TestCase
from icecream.models import *
from icecream.admin import *

from django.test.client import RequestFactory
from icecream.views import index
from django.test.client import Client
from django.contrib.auth.models import User


class Tester (TestCase) :
    def setUp(self):
        User.objects.create(username="admin", password="asdfadfa")
        self.num_flavors = 0
        pb = Flavor.objects.create(name="Peanut Butter Chip")
        self.num_flavors += 1
        bc = Flavor.objects.create(name="Birthday Cake")
        self.num_flavors += 1
        bbc = Flavor.objects.create(name="Blackberry Chip")
        self.num_flavors += 1
        
        order = Order.objects.create(customer_name="Jordan Jueckstock", is_completed=False)
        order.scoops.add(pb, bbc)
        
        order = Order.objects.create(customer_name="James Knisely", is_completed=False)
        order.scoops.add(bbc)

        order = Order.objects.create(customer_name="Alan Hughes", is_completed=False)
        order.scoops.add(bbc, bc, pb)

    def test_flavors_exists(self):
        flavors = Flavor.objects.all()
        self.assertEqual(len(flavors), self.num_flavors)

    def test_get_customers_by_flavor_3 (self) :
        queryset = Order.objects.filter(scoops__name__startswith="Black")
        self.assertEqual(len(queryset), 3)

    def test_get_customers_by_flavor_2 (self) :
        queryset = Order.objects.filter(scoops__name__startswith="Peanut")
        self.assertTrue(len(queryset) == 2)

    def test_get_customer_by_flavor (self) :
        flavor = Flavor.objects.filter(name__startswith="Birth")
        queryset = Order.objects.filter(scoops__in=flavor)
        self.assertEqual(len(queryset), 1)

    def test_flavor_str (self) :
        queryset = Flavor.objects.filter(name__contains="Cake")
        self.assertEqual(str(queryset[0]), "Birthday Cake")
        
    def test_order_str (self) :
        queryset = Order.objects.filter(customer_name__endswith='Hughes')
        expected = "order for Alan Hughes: Peanut Butter Chip, Birthday Cake, Blackberry Chip"
        self.assertEqual(str(queryset[0]), expected)        

    def test_order_str_completed (self) :
        queryset = Order.objects.filter(customer_name__endswith='Hughes')
        order = queryset[0]
        old = order.is_completed
        order.is_completed = True
        expected = "order for Alan Hughes: Peanut Butter Chip, Birthday Cake, Blackberry Chip [Completed]"
        self.assertEqual(str(order), expected)   
        order.is_completed = old

    def test_Order_Admin(self) :
        order_admin = OrderAdmin(Order, admin.site)
        queryset = Order.objects.filter(customer_name__startswith='A')
        scoops = order_admin.get_scoops(queryset[0])
        self.assertEqual(len(scoops), 3)
        
    def test_index (self) :
        self.client = Client()
        self.factory = RequestFactory()
        queryset = User.objects.filter(username='admin')
        self.user = queryset[0]
        self.client.login(username="admin", password="asdfadfa")
        request = self.factory.get('/')
        self.assertEqual(request.get_full_path(), '/')
        
