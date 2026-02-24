from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone
from rest_framework import serializers




class ProgramLeaflet(models.Model):
    title = models.CharField(max_length=200)
    subtitle = models.CharField(max_length=200, blank=True)
    institution = models.CharField(max_length=200, default='Bob Jones University')
    division = models.CharField(max_length=200, default='Division of Music')
    director = models.CharField(max_length=200)
    location = models.CharField(max_length=200)
    date = models.CharField(max_length=100)
    time = models.CharField(max_length=100)

    # Store program content as JSON
    program_content = models.JSONField(default=list)

    # Back page content
    contributors = models.TextField(help_text="One per line, format: Name - Role")
    donor_title = models.CharField(max_length=100)
    donor_text = models.TextField()
    donor_link = models.URLField(blank=True)
    upcoming_events = models.TextField(help_text="One per line")
    mission_statement = models.TextField(
        blank=True,
        default='_The Division of Music at BJU is a community of students, faculty, and staff committed to\n**empowering musicians to pursue and share the beauty of God through redemptive artistry.**_\nBob Jones University is an accredited institutional member of the\n**National Association of Schools of Music.**',
        help_text='Use **text** for bold, *text* for italic, _text_ for underline'
    )

class ProgramLeafletSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProgramLeaflet
        fields = ["title", "subtitle", "institution", "division", "director", "location", "date", "program_content", "contributors", "donor_title", "donor_text", "donor_link",
        "upcoming_events", "mission_statement"]


