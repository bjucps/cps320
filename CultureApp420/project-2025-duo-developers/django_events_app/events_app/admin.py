from django.contrib import admin
from .models import Event, EventDate, Registration, CheckIn
# Register your models here.
@admin.register(Event)
class EventAdmin(admin.ModelAdmin):
    list_display = ("title", "description")
    search_fields = ("title", "description")
    inlines = []
# date_hierarchy = "created_at"
@admin.register(EventDate)
class EventDateAdmin(admin.ModelAdmin):
    list_display = ("event", "date")
    list_filter = ("date",)
#  date_hierarchy = "date"
@admin.register(Registration)
class RegistrationAdmin(admin.ModelAdmin):
    list_display = ("user", "event", "waitlist", "confirmed", "registered_at")
    list_filter = ("waitlist", "confirmed")
    search_fields = ("user__username", "event__title")
#   date_hierarchy = "registered_at"
@admin.register(CheckIn)
class CheckInAdmin(admin.ModelAdmin):
    list_display = ("registration", "checked_in_at")
    list_filter = ("checked_in_at",)
