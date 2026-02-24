# events_app/models.py
from django.db import models
from django.conf import settings
import uuid
from django.utils import timezone
from django.contrib.auth.models import User

# test model
class Person(models.Model):
    id = models.BigAutoField(auto_created=True, primary_key=True)
    firstName = models.CharField(max_length=20, help_text="Person's first name")
    lastName = models.CharField(max_length=20, help_text="Person's last name")
    age = models.IntegerField()

    def __str__(self):
        return f"{self.firstName} {self.lastName}"


# Event model
class Event(models.Model):
    title = models.CharField(max_length=200)
    description = models.TextField()
    image = models.ImageField(upload_to="events/", blank=True, null=True)
    capacity = models.PositiveIntegerField(default=100)  # maximum number of attendees

    def __str__(self):
        return self.title


# EventDate model
class EventDate(models.Model):
    event = models.ForeignKey(Event, on_delete=models.CASCADE, related_name="dates")
    date = models.DateField()

    def __str__(self):
        return f"{self.event.title} - {self.date}"


# Registration model
class Registration(models.Model):
    STATUS_CHOICES = [
        ('T', 'Tentative'),
        ('C', 'Confirmed'),
        ('D', 'Declined'),
    ]
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    event = models.ForeignKey(Event, on_delete=models.CASCADE)
    waitlist = models.BooleanField(default=False)
    confirmed = models.CharField(max_length=1, choices=STATUS_CHOICES, default='T')
    registered_at = models.DateTimeField(auto_now_add=True)
    qr_token = models.CharField(max_length=64, unique=True, blank=True)

    class Meta:
        unique_together = ('user', 'event')

    def save(self, *args, **kwargs):
        if not self.qr_token:
            self.qr_token = uuid.uuid4().hex
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.user.username} → {self.event.title} ({self.get_confirmed_display()})"


# CheckIn model (QR scanning)
class CheckIn(models.Model):
    registration = models.OneToOneField(Registration, on_delete=models.CASCADE, related_name="checkin")
    checked_in_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"CheckIn: {self.registration.user.username} at {timezone.localtime(self.checked_in_at)}"
