from django.test import TestCase, Client
from django.urls import reverse
from django.contrib.auth.models import User, Permission
from .models import Event
from datetime import date, time
from django.utils import timezone

class EventModelTests(TestCase):
    def setUp(self):
        self.event = Event.objects.create(
            eventId="EVT001",
            name="Sample Event",
            status="confirmed",
            htmlLink="https://example.com/event",
            created=timezone.now(),
            updated=timezone.now(),
            summary="Sample summary",
            location="FMA",
            creator_email="creator@example.com",
            organizerEmail="organizer@example.com",
            organizerName="Organizer Name",
            StartTime=time(10, 0),
            startDate=date(2025, 9, 1),
            endDate=date(2025, 9, 2),
            roll=False,
            url_text="sample-url",
            short_title="Sample Short Title",
            room="Room 101",
            url="https://example.com",
            tags="sample, event",
            pamphlet="Sample pamphlet text"
        )

        self.user = User.objects.create_user(username="admin", password="superuser")
        perm = Permission.objects.get(codename="add_event")
        self.user.user_permissions.add(perm)
        self.client = Client()

    def test_eventCreation(self):
        self.assertEqual(Event.objects.count(), 1)

    def test_checkEventName(self):
        self.assertEqual(self.event.name, "Sample Event")

    def test_checkEventId(self):
        self.assertEqual(self.event.eventId, "EVT001")

    def test_checkEventStatus(self):
        self.assertEqual(self.event.status, "confirmed")

    def test_checkEventSummary(self):
        self.assertEqual(self.event.summary, "Sample summary")

    def test_checkEventLocation(self):
        self.assertEqual(self.event.location, "FMA")

    def test_checkStartDate(self):
        self.assertEqual(self.event.startDate, date(2025, 9, 1))

    def test_checkEndDate(self):
        self.assertEqual(self.event.endDate, date(2025, 9, 2))

    def test_checkStartTime(self):
        self.assertEqual(self.event.StartTime, time(10, 0))

    def test_checkRoll(self):
        self.assertFalse(self.event.roll)

    def test_checkRoom(self):
        self.assertEqual(self.event.room, "Room 101")

    def test_checkUrl(self):
        self.assertEqual(self.event.url, "https://example.com")

    def test_checkPamphlet(self):
        self.assertEqual(self.event.pamphlet, "Sample pamphlet text")

    def test_strOutput(self):
        expected = f"{self.event.name} ({self.event.startDate})"
        self.assertEqual(str(self.event), expected)


class EventViewTests(TestCase):
    def setUp(self):
        self.event = Event.objects.create(
            eventId="EVT002",
            name="View Test Event",
            status="confirmed",
            htmlLink="https://example.com/event2",
            created=timezone.now(),
            updated=timezone.now(),
            summary="View test summary",
            location="FMA",
            creator_email="creator2@example.com",
            organizerEmail="organizer2@example.com",
            organizerName="Organizer Two",
            StartTime=time(9, 0),
            startDate=date.today(),
            endDate=date.today(),
            roll=True,
            url_text="view-url",
            short_title="View Short",
            room="Room 202",
            url="https://example2.com",
            tags="view, test",
            pamphlet="View pamphlet"
        )

        self.user = User.objects.create_user(username="admin", password="superuser")
        perm = Permission.objects.get(codename="add_event")
        self.user.user_permissions.add(perm)
        self.client = Client()

    def test_Index(self):
        response = self.client.get(reverse("index"))
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, "home.html")
        self.assertIn("events", response.context)

    def test_pMaker(self):
        response = self.client.get(reverse("pMaker"))
        self.assertEqual(response.status_code, 302)
        self.client.login(username="admin", password="superuser")
        response = self.client.get(reverse("pMaker"))
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, "pmaker.html")
        self.assertIn("events", response.context)

    def test_emailGen(self):
        response = self.client.get(reverse("emailGen"))
        self.assertEqual(response.status_code, 302)
        self.client.login(username="admin", password="superuser")
        response = self.client.get(reverse("emailGen"))
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, "emailGen.html")
        self.assertIn("events", response.context)
