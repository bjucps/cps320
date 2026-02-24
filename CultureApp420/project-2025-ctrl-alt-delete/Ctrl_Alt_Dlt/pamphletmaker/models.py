from django.db import models
from webstrings import *
from django.utils import timezone

staticFileUrl = 'mystaticfiles/'
from django.db import models

class Event(models.Model):
    id = models.BigAutoField(auto_created=True, primary_key=True)
    eventId = models.CharField(max_length=255)
    name = models.CharField(max_length=255, help_text="Event Title/Summary")
    status = models.CharField(max_length=50, help_text="Calendar event Status", default="pending")
    htmlLink = models.URLField(blank=True, null=True, help_text="Public Calendar link")
    created = models.DateTimeField(help_text="Event Creation Date", default=timezone.now)
    updated = models.DateTimeField(help_text="Event Updated Date", default=timezone.now)
    summary = models.CharField(max_length=255, help_text="Event Description")
    location = models.CharField(max_length=255, blank=True, null=True, help_text="Event Location")
    creator_email = models.EmailField(blank=True, null=True)

    organizerEmail = models.EmailField(blank=True, null=True)
    organizerName = models.CharField(max_length=255, blank=True, null=True)
    StartTime = models.TimeField(verbose_name=strt, help_text="Event Start Time")
    startDate = models.DateField(help_text="Event start date")
    endDate = models.DateField(help_text="Event end date")

    roll = models.BooleanField(default=False, help_text="??????")
    url_text = models.CharField(max_length=255, blank=True, null=True)
    short_title = models.CharField(max_length=255, blank=True, null=True)
    room = models.CharField(max_length=255, blank=True, null=True)
    url = models.URLField(blank=True, null=True)
    tags = models.CharField(max_length=255, blank=True, null=True)

    image = models.ImageField(
        upload_to='mystaticfiles/',
        blank=True,
        null=True,
        help_text="Optional image for this event"
    )

    pamphlet = models.TextField("Program", null=True, blank=True)

    def __str__(self):
        return f"{self.name} ({self.startDate})"
