from datetime import datetime

from django.test import TestCase

from .models import Attendance, Event, Location


class EventModelTests(TestCase):
    def setUp(self):
        self.location = Location.objects.create(name="Welcome Center")
        self.start_time = datetime.fromisoformat("2025-10-04T19:00:00-00:00")
        self.end_time = datetime.fromisoformat("2025-10-04T20:30:00-00:00")
        self.event = Event.objects.create(
            title="Hello There",
            date_start_time=self.start_time,
            date_end_time=self.end_time,
            location=self.location,
        )
        self.attendance = Attendance.objects.create(
            event=self.event,
            email="null@students.bju.edu",
            checked_in_at=self.start_time,
        )

    def test_time_output_fmt(self):
        d = self.event.date
        self.assertEquals(d, "Oct 04, 2025, 7:00 PM – 8:30 PM")

    def test_attendance_str(self):
        self.assertEquals(str(self.attendance), "null@students.bju.edu at Hello There")
