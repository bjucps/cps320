from django.forms import ValidationError
from django.test import Client, TestCase
from django.urls import reverse
from HelloWorld.models import Event, Month_Manager, Month_Page, Student, fernet, Events_Table_Manager, next_id


class EventModelTests(TestCase):
    def setUp(self):
        self.event = Event.objects.create(event_id = 1, event_name="Test Event", event_date = "2025-12-31", event_time="12:00", event_location="Stage")
        self.event2 = Event.objects.create(event_id = 2, event_name="Test Event2", event_date = "2026-12-31", event_time="11:00", event_location="Stage2")

    def test_event_creation(self):
        self.assertEqual(self.event.pk, 1)
        self.assertEqual(self.event.event_name, "Test Event")
        self.assertEqual(self.event.event_date, "2025-12-31")
        self.assertEqual(self.event.event_time, "12:00")
        self.assertEqual(self.event.event_location, "Stage")
        
        self.assertEqual(self.event2.pk, 2)
        self.assertEqual(self.event2.event_name, "Test Event2")
        self.assertEqual(self.event2.event_date, "2026-12-31")
        self.assertEqual(self.event2.event_time, "11:00")
        self.assertEqual(self.event2.event_location, "Stage2")

        objs = Event.objects.all()
        self.assertEqual(len(objs), 2)
    
    def test_link_address_generation(self):
        link = self.event.attendance_link_address()
        link2 = self.event2.attendance_link_address()

        self.assertEqual(fernet.decrypt(link).decode(), "Test Event_1")
        self.assertEqual(fernet.decrypt(link2).decode(), "Test Event2_2")

    def test_next_id(self):
        i = next_id()
        self.assertEqual(i, 3)

class StudentModelTests(TestCase):
    def setUp(self):
        self.s1 = Student.objects.create(stu_name="Jeremy",
                                        stu_email="jeremy@hotmail.com",
                                        stu_enroll_MU098=True)
        self.s2 = Student.objects.create(stu_name="Leremy",
                                        stu_email="leremy@oreos.com",
                                        stu_enroll_MU099=True)
        self.event = Event.objects.create(event_id = 1, event_name="Test Event", event_date = "2025-12-31", event_time="12:00", event_location="Stage")
    
    def test_student_creation(self):
        self.assertEqual(self.s1.pk, 1)
        self.assertEqual(self.s1.stu_name, "Jeremy")
        self.assertEqual(self.s1.stu_email, "jeremy@hotmail.com")
        self.assertEqual(self.s1.stu_total_attendances, 0)
        self.assertTrue(self.s1.stu_enroll_MU098)
        self.assertFalse(self.s1.stu_enroll_MU099)
        
        self.assertEqual(self.s2.pk, 2)
        self.assertEqual(self.s2.stu_name, "Leremy")
        self.assertEqual(self.s2.stu_email, "leremy@oreos.com")
        self.assertEqual(self.s2.stu_total_attendances, 0)
        self.assertFalse(self.s2.stu_enroll_MU098)
        self.assertTrue(self.s2.stu_enroll_MU099)

    def test_student_attendance_increase(self):
        self.s1.student_increment_attendance()
        self.assertEqual(self.s1.stu_total_attendances, 1)

    def test_attendances_needed(self):
        self.s1.reset()
        self.s2.reset()
        self.assertEqual(self.s1.count_attendances_needed(), 2)
        self.assertEqual(self.s2.count_attendances_needed(), 5)

    def test_record_attendance(self):
        self.s1.record_attendance(self.event)
        self.assertEqual(self.s1.stu_total_attendances, 1)

    def test_events_list(self):
        self.s1.record_attendance(self.event)
        events = self.s1.get_events_list()
        self.assertEqual("Test Event\n", events)

    def test_student_requires_more_attendance(self):
        self.assertTrue(self.s2.student_attendance_needed())
    
    def test_student_does_not_require_more_attendance(self):
        self.s1.student_increment_attendance()
        self.s1.student_increment_attendance()
        self.assertFalse(self.s1.student_attendance_needed())

    def test_unique_MU098_and_MU099(self):
        s3 = Student.objects.create(stu_name="Illegal",
                stu_email="illegal@ICE.com",
                stu_enroll_MU098=True,
                stu_enroll_MU099=True)
        self.assertRaises(ValidationError, s3.full_clean)


class TemplatesTests(TestCase):
    def setUp(self):
        self.client = Client()

    def test_events_page_template(self):
        url = reverse('HelloWorld:events')
        response = self.client.get(url)

        ctx = response.context

        self.assertEqual(response.status_code, 200)     # success code
        # events_page template
        self.assertTemplateUsed(response, 'templates/events_page.html')

        self.assertIn('events_headers', ctx)
        self.assertIn('events', ctx)
        
        self.assertEqual(ctx['events_headers'], ["Event", "Date", "Time", "Location", "Attendance"])
        objs = ctx['events']
        for o in objs:
            self.assertEqual(type(o), Event)

        # table template
        self.assertTemplateUsed(response, '_event_table.html')

        self.assertIn('width', ctx)
        self.assertIn('title', ctx)
        self.assertIn('link_address', ctx)
        self.assertIn('link_text', ctx)

        self.assertEqual(ctx['width'], '10')
        self.assertEqual(ctx['title'], 'Events')
        self.assertEqual(ctx['link_address'], 'attendance/')
        self.assertEqual(ctx['link_text'], 'Record Attendance')
        
class Test_Events_Table_Manager(TestCase):
    def setUp(self):
        self.display_size = 5
        self.table_size = 23
        self.table = [i for i in range(self.table_size)]
        self.manager = Events_Table_Manager(self.table, size=self.display_size)  # 4 pages of 5, 1 partial page

    def test_get(self):
        t = self.manager.get()
        self.assertEqual(len(t), self.display_size)
        self.assertEqual(t, [i for i in range(self.display_size)])

    def test_next(self):
        self.manager.next()
        self.assertEqual(self.manager.get(), [i for i in range(5, 10)])

    def test_prev(self):
        self.manager.next()
        self.manager.prev()
        self.assertEqual(self.manager.get(), [i for i in range(self.display_size)])

    def test_reset(self):
        self.manager.next()
        self.manager.next()
        self.manager.reset()
        self.assertEqual(self.manager.page, 0)
        self.assertEqual(self.manager.get(), [i for i in range(self.display_size)])

    def test_partial_page(self):
        for i in range(5):
            self.manager.next()
        t = self.manager.get()
        self.assertTrue(len(t) < self.display_size)
        self.assertEqual(t, [i for i in range(20, 23)])

class Test_Month_Manager(TestCase):
    def setUp(self):
        self.m = Month_Manager()
        self.current_month = 1
        self.m.displayed_month.month = self.current_month

    def test_month_next(self):
        self.m.prev()
        self.assertEqual(self.m.displayed_month.month, 12)
        self.m.next()
        self.assertEqual(self.m.displayed_month.month, self.current_month)
        self.m.next()
        self.assertEqual(self.m.displayed_month.month, self.current_month+1)
        self.m.reset()
        self.assertEqual(self.current_month, self.m.displayed_month.month)

    def test_leap_year(self):
        m = Month_Page(2, 2004)
        self.assertEqual(m.days, 29)