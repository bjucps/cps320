from django.test import TestCase, Client
from django.contrib.auth.models import User, Group
from leaflet.models import Event, EventSection, Element, Division


class BaseLeafletTestCase(TestCase):

    @classmethod
    def setUpTestData(cls):
        cls.admin_user = User.objects.create_superuser(username='admin', password='pass123', email='admin@test.com')
        admin_group = Group.objects.create(name='MusicArtsAdmin')
        cls.admin_user.groups.add(admin_group)
        cls.regular_user = User.objects.create_user(username='user', password='pass123')

        cls.division = Division.objects.create(division='Test Music', mission_statement='We Love Music!')

        cls.event = Event.objects.create(
            title="Test Event",
            director="Director A",
            date="2025-10-01",
            time="10:00",
            institution= 'BOB JONES UNIVERSITY',
            location="Location A",
            division=cls.division,
        )

        cls.section = EventSection.objects.create(event=cls.event, section_title="Opening Section")

        cls.element = Element.objects.create(
            event_section=cls.section,
            performance_title="Performance 1",
            author="Author A",
            performer="Performer A",
            type="Solo"
        )

    def setUp(self):
        self.client = Client()
