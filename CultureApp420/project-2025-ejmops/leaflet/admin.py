from django.contrib import admin
from .models import Event, Division, Element, EventSection


# Register your models here.

@admin.register(Division)
class DivisionAdmin(admin.ModelAdmin):
    list_display = ("id","division")

@admin.register(Event)
class EventAdmin(admin.ModelAdmin):
    list_display = ('id', 'title', 'date', )

@admin.register(EventSection)
class EventSectionAdmin(admin.ModelAdmin):
    list_display = ('id', 'section_title', 'event')

@admin.register(Element)
class ElementsAdmin(admin.ModelAdmin):
    list_display = ('id', 'event_section')