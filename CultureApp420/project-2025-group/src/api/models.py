from django.db import models
from rest_framework import serializers
# Create your models here.

class Event(models.Model):
    name = models.CharField(max_length=30)
    date = models.DateField()
    location = models.CharField(max_length=30)
    desc = models.CharField(max_length=50, default="Event description")
    performer = models.CharField(max_length=30, default="BJU Chorale")


    @classmethod 
    def create(cls, name, date, location, desc, performer):
        event = cls(name=name, date=date, location=location, desc=desc, performer=performer)
        return event

class EventSerializer(serializers.ModelSerializer):
    class Meta:
        model = Event
        fields = ["name", "date", "location", "desc", "performer"]