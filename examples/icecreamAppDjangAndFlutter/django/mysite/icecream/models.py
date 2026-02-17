# models.py
from django.db import models

class Flavor(models.Model) :
    id = models.BigAutoField(auto_created=True, primary_key=True)
    name = models.CharField(max_length=255)

    def __str__ (self) :
        return self.name
    
class Topping(models.Model) :
    id = models.BigAutoField(auto_created=True, primary_key=True)
    name = models.CharField(max_length=255)
    desc = models.CharField(max_length=1023, verbose_name="Description")
    def __str__ (self) :
        return self.name

class Order(models.Model) :
    id = models.BigAutoField(auto_created=True, primary_key=True)
    is_completed = models.BooleanField(verbose_name="Was delivered", help_text="Has this order been delivered to the customer?", default=False)
    customer_name = models.CharField(max_length=255)
    scoops = models.ManyToManyField(Flavor)

    def __str__ (self) :
        output = "order for " + self.customer_name + ": "
        names = []
        for flavor in self.scoops.all() :
            names.append(str(flavor))
        
        output += ", ".join(names)
        if self.is_completed : 
            output += " [Completed]"

        return output
