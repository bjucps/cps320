from django.db import models
from django.utils.timezone import localtime


class Location(models.Model):
    name = models.CharField(max_length=64)
    room = models.IntegerField(null=True, blank=True)
    link = models.URLField(null=True, blank=True)
    what_three_words = models.URLField(null=True, blank=True)

    def __str__(self):
        return f"{self.name} at {self.room}"


class Event(models.Model):
    date_start_time = models.DateTimeField()
    date_end_time = models.DateTimeField()
    title = models.CharField(max_length=256)
    description = models.CharField(max_length=2048, null=True, blank=True)
    # TODO: category
    link = models.URLField(null=True, blank=True)
    location = models.ForeignKey(
        Location, on_delete=models.CASCADE, null=True, blank=True
    )

    @property
    def date(self):
        def format_time(t):
            return t.strftime(time_format).lstrip("0")

        date_format = "%b %d, %Y"  # "Oct 21, 2025"
        time_format = "%I:%M %p"  # "09:30 PM"

        start = localtime(self.date_start_time)
        end = localtime(self.date_end_time)

        return (
            f"{start.strftime(date_format)}, {format_time(start)} – {format_time(end)}"
        )

    def __str__(self):
        return f"{self.title} at {self.date_start_time}, {self.location}"


class Attendance(models.Model):
    event = models.ForeignKey(Event, on_delete=models.CASCADE)
    email = models.EmailField()
    present = models.BooleanField(default=True)  
    checked_in_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("event", "email")

    def __str__(self):
        return f"{self.email} at {self.event.title}"
