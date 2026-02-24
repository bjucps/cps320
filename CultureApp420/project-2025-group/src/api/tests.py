from django.test import TestCase
from api.models import Event

class EventTestCase(TestCase):
    def setUp(self):
        Event.objects.create(name="Test Event 1", date="1997-10-10", location="Vietnam", desc="A nice event", performer="Anonymous")
    
    def test_creation(self):
        event = Event.objects.get(name="Test Event 1")
        self.assertEqual(str(event.date), "1997-10-10")
        self.assertEqual(str(event.name), "Test Event 1")
        self.assertEqual(str(event.location), "Vietnam")
        self.assertEqual(str(event.desc), "A nice event")
        self.assertEqual(str(event.performer), "Anonymous")


