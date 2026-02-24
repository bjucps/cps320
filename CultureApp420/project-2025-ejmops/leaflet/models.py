from django.db import models
from datetime import datetime

class Division(models.Model):
    division = models.CharField(max_length=255)
    mission_statement = models.CharField(max_length=255)

    def __str__(self):
        return self.division

class Event(models.Model):
    ''' Institution and Division choices is not final and confirmed but only placeholder for now'''
    Institution_Choices = (
    ('BOB JONES ACADEMY', "Bob Jones Academy"),
    ('BOB JONES UNIVERSITY', "Bob Jones University"),
    )

    title = models.CharField(max_length=255)
    director = models.CharField(max_length=255, blank=True, null=True)
    institution = models.CharField(max_length=255, choices=Institution_Choices)
    division = models.ForeignKey('Division', on_delete=models.PROTECT)
    location = models.CharField(max_length=255)
    date = models.DateField()
    school_year = models.CharField(max_length=255, default=f"{datetime.now().year}")
    time = models.TimeField()

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    created_by = models.ForeignKey("auth.User", on_delete=models.SET_NULL, null=True, blank=True)

    def __str__(self):
        return f"{self.title} ({self.date})"

    def save(self, *args, **kwargs):
        # Convert string → date if needed
        if isinstance(self.date, str):
            self.date = datetime.strptime(self.date, "%Y-%m-%d").date()

        # Compute school year
        if self.date.month <= 5:
            self.school_year = f"{self.date.year - 1}-{self.date.year}"
        else:
            self.school_year = f"{self.date.year}-{self.date.year + 1}"

        super().save(*args, **kwargs)

class EventSection(models.Model):
    event = models.ForeignKey('Event', on_delete=models.PROTECT)
    section_title = models.CharField(max_length=255)

    def __str__(self):
        return self.section_title


class Element(models.Model):
    event_section = models.ForeignKey('EventSection', on_delete=models.PROTECT, null=True, blank=True)
    performance_title = models.CharField(max_length=255)
    author = models.CharField(max_length=255)
    performer = models.CharField(max_length=255)
    type = models.CharField(max_length=255) #Can be turned into a dropdown once we get access to the type of performances
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    created_by = models.ForeignKey("auth.User", on_delete=models.SET_NULL, null=True, blank=True)


    def __str__(self):
        return f'{self.event_section} {self.performance_title }'


