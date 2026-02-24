from django.test import TestCase
from django.urls import reverse
from django.contrib.auth.models import User
from django.db import connection
from django.db.utils import IntegrityError

from .models import Event, EventDate, Registration, CheckIn


# Phase 2: Event View Tests
class EventViewTests(TestCase):
    def setUp(self):
        # 1) create test user and log in
        self.user = User.objects.create_user(
            username="testuser",
            password="testpass",
        )
        self.client.login(username="testuser", password="testpass")

        # 2) create test event with multiple dates
        self.event = Event.objects.create(
            title="Sample Concert",
            description="A great music event",
        )
        # add multiple dates
        EventDate.objects.create(event=self.event, date="2025-10-07")
        EventDate.objects.create(event=self.event, date="2025-10-08")

    def test_event_list_view_status_code(self):
        """check the event list view returns status code 200"""
        url = reverse("events_app:index")
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)

    def test_event_list_view_contains_event(self):
        """check the event list view contains the created event"""
        url = reverse("events_app:index")
        response = self.client.get(url)
        self.assertContains(response, "Sample Concert")
        self.assertContains(response, "A great music event")

    def test_event_list_view_contains_dates(self):
        """check the event list view contains the event dates"""
        url = reverse("events_app:index")
        response = self.client.get(url)
        self.assertContains(response, "Oct. 7, 2025")
        self.assertContains(response, "Oct. 8, 2025")

    def test_event_list_empty(self):
        """check the event list view when no events exist"""
        Event.objects.all().delete()  # remove all events
        url = reverse("events_app:index")
        response = self.client.get(url)
        self.assertContains(response, "No events available.")


# Phase 3: Integration Tests
class IntegrationTests(TestCase):
    def test_database_connection(self):
        """check database connection works"""
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT 1;")
                result = cursor.fetchone()
            self.assertEqual(result[0], 1)
        except Exception as e:
            self.fail(f"Database connection failed: {e}")

    def test_admin_login_page(self):
        """check admin login page is accessible"""
        response = self.client.get("/admin/login/")
        self.assertContains(response, "username", status_code=200)


# Registration view tests
class RegistrationViewTests(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username="student",
            password="pass123",
        )
        self.other_user = User.objects.create_user(
            username="other",
            password="pass123",
        )
        self.event = Event.objects.create(
            title="Limited Recital",
            description="Capacity 1 recital",
            capacity=1,
        )
        EventDate.objects.create(event=self.event, date="2025-10-07")

    def test_register_creates_registration_not_waitlist(self):
        """First registration goes in as regular (not waitlist) when under capacity."""
        self.client.login(username="student", password="pass123")
        url = reverse("events_app:register_event", args=[self.event.id])
        response = self.client.post(url, follow=True)
        self.assertEqual(response.status_code, 200)

        reg = Registration.objects.get(user=self.user, event=self.event)
        self.assertFalse(reg.waitlist)
        self.assertEqual(reg.confirmed, "T")

    def test_register_enforces_waitlist_when_full(self):
        """When event is full, additional registrations go to the waitlist."""
        Registration.objects.create(
            user=self.other_user,
            event=self.event,
            waitlist=False,
            confirmed="T",
        )
        self.client.login(username="student", password="pass123")
        url = reverse("events_app:register_event", args=[self.event.id])
        self.client.post(url)

        reg = Registration.objects.get(user=self.user, event=self.event)
        self.assertTrue(reg.waitlist)
        self.assertEqual(reg.confirmed, "T")

    def test_register_prevents_duplicate_registration(self):
        """Same user cannot create duplicate registrations for the same event."""
        self.client.login(username="student", password="pass123")
        url = reverse("events_app:register_event", args=[self.event.id])

        self.client.post(url)
        self.client.post(url)  # second attempt

        regs = Registration.objects.filter(user=self.user, event=self.event)
        self.assertEqual(regs.count(), 1)

    def test_register_requires_login(self):
        """Anonymous user should be redirected to login when registering."""
        url = reverse("events_app:register_event", args=[self.event.id])
        response = self.client.post(url)
        self.assertEqual(response.status_code, 302)
        self.assertIn("/accounts/login/", response["Location"])


# Unregister view tests
class UnregisterViewTests(TestCase):
    def setUp(self):
        self.user1 = User.objects.create_user(
            username="user1",
            password="pass123",
        )
        self.user2 = User.objects.create_user(
            username="user2",
            password="pass123",
        )
        self.event = Event.objects.create(
            title="Small Event",
            description="Event with capacity 1",
            capacity=1,
        )
        EventDate.objects.create(event=self.event, date="2025-10-07")

    def _register(self, username):
        self.client.login(username=username, password="pass123")
        url = reverse("events_app:register_event", args=[self.event.id])
        self.client.post(url)
        self.client.logout()

    def test_unregister_deletes_registration(self):
        """Unregister removes the user's registration."""
        self._register("user1")
        self.client.login(username="user1", password="pass123")

        url = reverse("events_app:unregister_event", args=[self.event.id])
        response = self.client.post(url, follow=True)

        self.assertEqual(response.status_code, 200)
        self.assertFalse(
            Registration.objects.filter(user=self.user1, event=self.event).exists()
        )

    def test_unregister_promotes_waitlist_user(self):
        """When first user unregisters, next waitlisted user is promoted."""
        # user1 becomes confirmed
        self._register("user1")
        # user2 becomes waitlisted
        self._register("user2")

        # reload registrations
        reg1 = Registration.objects.get(user=self.user1, event=self.event)
        reg2 = Registration.objects.get(user=self.user2, event=self.event)
        self.assertFalse(reg1.waitlist)
        self.assertTrue(reg2.waitlist)

        # user1 unregisters
        self.client.login(username="user1", password="pass123")
        url = reverse("events_app:unregister_event", args=[self.event.id])
        self.client.post(url)
        self.client.logout()

        reg2.refresh_from_db()
        self.assertFalse(reg2.waitlist)
        self.assertEqual(reg2.confirmed, "C")

    def test_unregister_when_not_registered_is_safe(self):
        """Calling unregister when user has no registration should not crash."""
        self.client.login(username="user1", password="pass123")
        url = reverse("events_app:unregister_event", args=[self.event.id])
        response = self.client.post(url, follow=True)
        self.assertEqual(response.status_code, 200)
        # Still no registrations
        self.assertEqual(
            Registration.objects.filter(user=self.user1, event=self.event).count(), 0
        )


# CSV export tests
class CsvExportTests(TestCase):
    def setUp(self):
        self.staff = User.objects.create_user(
            username="staff", password="pass123", is_staff=True, is_superuser=True
        )
        self.normal = User.objects.create_user(
            username="normal", password="pass123"
        )
        self.event = Event.objects.create(
            title="CSV Event",
            description="Event for CSV export",
            capacity=10,
        )
        EventDate.objects.create(event=self.event, date="2025-10-07")
        Registration.objects.create(user=self.normal, event=self.event)

    def test_export_csv_requires_staff(self):
        """Non-staff users are redirected away from CSV export."""
        self.client.login(username="normal", password="pass123")
        url = reverse("events_app:export_csv", args=[self.event.id])
        response = self.client.get(url)
        self.assertEqual(response.status_code, 302)

    def test_export_csv_returns_valid_csv(self):
        """Staff can download a CSV file with one row of registrations."""
        self.client.login(username="staff", password="pass123")
        url = reverse("events_app:export_csv", args=[self.event.id])
        response = self.client.get(url)

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response["Content-Type"], "text/csv")
        content = response.content.decode("utf-8")
        # header + one data row
        self.assertIn("username,first_name,last_name,email,waitlist,confirmed", content)
        self.assertIn("normal", content)


# Manage event tests
class ManageEventTests(TestCase):
    def setUp(self):
        self.staff = User.objects.create_user(
            username="staff", password="pass123", is_staff=True
        )
        self.normal = User.objects.create_user(
            username="normal", password="pass123"
        )
        self.event = Event.objects.create(
            title="Manage Me",
            description="Event manage view test",
            capacity=5,
        )
        EventDate.objects.create(event=self.event, date="2025-10-07")
        self.registration = Registration.objects.create(
            user=self.normal, event=self.event
        )

    def test_manage_requires_staff(self):
        """Non-staff user cannot access manage page."""
        self.client.login(username="normal", password="pass123")
        url = reverse("events_app:manage_event", args=[self.event.id])
        response = self.client.get(url)
        self.assertEqual(response.status_code, 302)

    def test_manage_shows_event_and_registrations(self):
        """Staff can see event and registrations on manage page."""
        self.client.login(username="staff", password="pass123")
        url = reverse("events_app:manage_event", args=[self.event.id])
        response = self.client.get(url)

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.context["event"], self.event)
        regs = response.context["registrations"]
        self.assertEqual(list(regs), [self.registration])


# Check-in tests
class CheckInViewTests(TestCase):
    def setUp(self):
        self.staff = User.objects.create_user(
            username="staff", password="pass123", is_staff=True
        )
        self.normal = User.objects.create_user(
            username="normal", password="pass123"
        )
        self.event = Event.objects.create(
            title="Check-in Event",
            description="Event for check-in",
            capacity=5,
        )
        EventDate.objects.create(event=self.event, date="2025-10-07")
        self.registration = Registration.objects.create(
            user=self.normal, event=self.event
        )

    def test_checkin_requires_staff(self):
        """Non-staff user should be redirected from staff check-in view."""
        self.client.login(username="normal", password="pass123")
        url = reverse("events_app:checkin", args=[self.registration.id])
        response = self.client.post(url)
        self.assertEqual(response.status_code, 302)

    def test_staff_checkin_creates_checkin_object(self):
        """Staff check-in should create exactly one CheckIn object."""
        self.client.login(username="staff", password="pass123")
        url = reverse("events_app:checkin", args=[self.registration.id])

        response = self.client.post(url, follow=True)
        self.assertEqual(response.status_code, 200)

        checkins = CheckIn.objects.filter(registration=self.registration)
        self.assertEqual(checkins.count(), 1)


class CheckInByTokenTests(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username="tokenuser", password="pass123"
        )
        self.event = Event.objects.create(
            title="Token Event",
            description="Event for token check-in",
            capacity=5,
        )
        EventDate.objects.create(event=self.event, date="2025-10-07")
        self.registration = Registration.objects.create(
            user=self.user, event=self.event
        )

    def test_checkin_by_valid_token_creates_checkin(self):
        """Visiting QR token URL should create a CheckIn if not already checked in."""
        url = reverse("events_app:checkin_token", args=[self.registration.qr_token])
        response = self.client.get(url)

        self.assertEqual(response.status_code, 200)
        self.assertIn("Check-in completed", response.content.decode("utf-8"))
        self.assertTrue(
            CheckIn.objects.filter(registration=self.registration).exists()
        )

    def test_checkin_by_token_second_time_does_not_duplicate(self):
        """Second visit to the same token should not create duplicate CheckIns."""
        url = reverse("events_app:checkin_token", args=[self.registration.qr_token])
        self.client.get(url)
        self.client.get(url)

        checkins = CheckIn.objects.filter(registration=self.registration)
        self.assertEqual(checkins.count(), 1)


# Model-focused tests
class RegistrationModelTests(TestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username="modeluser", password="pass123"
        )
        self.event = Event.objects.create(
            title="Model Event",
            description="Event for model tests",
            capacity=0,  # unlimited
        )
        EventDate.objects.create(event=self.event, date="2025-10-07")

    def test_qr_token_autogenerated(self):
        """Saving a Registration without qr_token generates a hex token."""
        reg = Registration.objects.create(user=self.user, event=self.event)
        self.assertTrue(reg.qr_token)
        self.assertEqual(len(reg.qr_token), 32)
        # all hex characters (raises ValueError if not hex)
        int(reg.qr_token, 16)

    def test_unique_user_event_constraint(self):
        """(user, event) pair must be unique according to model Meta."""
        Registration.objects.create(user=self.user, event=self.event)
        with self.assertRaises(IntegrityError):
            Registration.objects.create(user=self.user, event=self.event)


# URL helper tests (lightweight)
class UrlRoutingTests(TestCase):
    def test_reverse_register_event(self):
        url = reverse("events_app:register_event", args=[1])
        self.assertEqual(url, "/events/1/register/")

    def test_reverse_checkin_by_token(self):
        url = reverse("events_app:checkin_token", args=["abc123"])
        self.assertEqual(url, "/checkin/abc123/")
