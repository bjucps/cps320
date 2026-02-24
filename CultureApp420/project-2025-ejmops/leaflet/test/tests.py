from django.contrib.auth.forms import AuthenticationForm
from django.test import TestCase
from django.urls import reverse
from django.contrib.auth.models import User
from leaflet.functions import get_current_school_year
from .test_base import BaseLeafletTestCase
from leaflet.models import Event, EventSection, Element
from datetime import date
from leaflet.urls import custom_404
from django.http import HttpRequest


class TestUserAuth(TestCase):
    def test_login_get(self):
        url = reverse('login')
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "<form")
        self.assertIsInstance(response.context['form'], AuthenticationForm)

    def test_login_post(self):
        User.objects.create_user(username='testuser', password='strongpassword123')
        url = reverse('login')
        data = {'username': 'testuser', 'password': 'strongpassword123'}
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, 302)

        response = self.client.get(reverse('home'))
        self.assertEqual(str(response.context['user']), 'testuser')
        self.assertTrue(response.context['user'].is_authenticated)

    def test_logout(self):
        User.objects.create_user(username='testuser', password='strongpassword123')
        self.client.login(username='testuser', password='strongpassword123')
        url = reverse('logout')
        response = self.client.get(url)
        self.assertEqual(response.status_code, 302)

        response = self.client.get(reverse('home'))
        self.assertFalse(response.context['user'].is_authenticated)

class LeafletViewsTest(BaseLeafletTestCase):

    def test_event_builder_view_post(self):
        self.client.login(username='admin', password='pass123')
        data = {
            'title': 'New Event',
            'director': 'Director B',
            'date': date(2025, 10, 2),
            'time': '12:00',
            'school_year': get_current_school_year(),
            'institution': 'BOB JONES UNIVERSITY',
            'location': 'Location B',
            'division': self.division.id,
        }
        response = self.client.post(reverse('event_builder'), data)
        self.assertEqual(response.status_code, 302)
        self.assertTrue(Event.objects.filter(title='New Event').exists())

    def test_event_section_builder_view_post(self):
        self.client.login(username='admin', password='pass123')
        data = {'section_title': 'Closing Section'}
        response = self.client.post(reverse('section_builder', args=[self.event.id]), data)
        self.assertEqual(response.status_code, 302)
        self.assertTrue(EventSection.objects.filter(event=self.event, section_title='Closing Section').exists())

    def test_event_elements_builder_view_post(self):
        self.client.login(username='admin', password='pass123')
        data = {
            'performance_title': 'New Performance',
            'author': 'Author B',
            'performer': 'Performer B',
            'type': 'Singing'
        }
        response = self.client.post(reverse('elements_builder', args=[self.event.id, self.section.id]), data)
        self.assertEqual(response.status_code, 302)
        self.assertTrue(Element.objects.filter(event_section=self.section, performance_title='New Performance').exists())

    def test_event_view_get(self):
        self.client.login(username='admin', password='pass123')
        response = self.client.get(reverse('event', args=[self.event.id]))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, self.event.title)
        self.assertContains(response, self.section.section_title)
        self.assertContains(response, self.element.performance_title)

    def test_edit_event_post(self):
        self.client.login(username='admin', password='pass123')
        data = {
            'title': 'Updated Event',
            'director': 'Director Updated',
            'date': '2025-10-05',
            'time': '15:00',
            'institution': 'BOB JONES UNIVERSITY',
            'location': 'Location B',
            'division': self.division.id,
        }
        response = self.client.post(reverse('edit_event', args=[self.event.id]), data)
        self.assertEqual(response.status_code, 302)
        event = Event.objects.get(id=self.event.id)
        self.assertEqual(event.title, 'Updated Event')
        self.assertEqual(event.director, 'Director Updated')


    def test_delete_event_post(self):
        self.client.login(username='admin', password='pass123')

        self.assertTrue(Event.objects.filter(pk=self.event.id).exists())
        self.assertTrue(EventSection.objects.filter(pk=self.section.id).exists())
        self.assertTrue(Element.objects.filter(pk=self.element.id).exists())

        response = self.client.post(reverse('delete_event', args=[self.event.id]))
        self.assertRedirects(response, reverse('home'))

        self.assertFalse(Event.objects.filter(pk=self.event.id).exists())
        self.assertFalse(EventSection.objects.filter(pk=self.section.id).exists())
        self.assertFalse(Element.objects.filter(pk=self.element.id).exists())

    def test_delete_section_post(self):
        self.client.login(username='admin', password='pass123')

        other_section = EventSection.objects.create(event=self.event, section_title="Closing Section")
        other_element = Element.objects.create(
            event_section=other_section,
            performance_title="Performance 2",
            author="Author B",
            performer="Performer B",
            type="Ensemble"
        )

        self.assertTrue(EventSection.objects.filter(pk=self.section.id).exists())
        self.assertTrue(Element.objects.filter(pk=self.element.id).exists())
        self.assertTrue(EventSection.objects.filter(pk=other_section.id).exists())
        self.assertTrue(Element.objects.filter(pk=other_element.id).exists())


        response = self.client.get(reverse('delete_section', args=[self.event.id, self.section.id]))
        self.assertRedirects(response, reverse('event', args=[self.event.id]))


        self.assertFalse(EventSection.objects.filter(pk=self.section.id).exists())
        self.assertFalse(Element.objects.filter(pk=self.element.id).exists())
        self.assertTrue(EventSection.objects.filter(pk=other_section.id).exists())
        self.assertTrue(Element.objects.filter(pk=other_element.id).exists())


# class Custom404Test(TestCase):
#     def test_custom_404_handler(self):
#         request = HttpRequest()
#         response = custom_404(request, Exception())
#         self.assertEqual(response.status_code, 404)
#         self.assertIn("leaflet/leaflet_404.html", response.template_name)

class DeleteElementViewTest(BaseLeafletTestCase):

    def test_delete_element_success(self):
        self.client.login(username='admin', password='pass123')

        url = reverse("delete_element", args=[self.event.id, self.element.id])
        response = self.client.get(url)

        self.assertEqual(response.status_code, 302)
        self.assertEqual(response.url, reverse("event", args=[self.event.id]))

        # Ensure the element is deleted
        self.assertFalse(Element.objects.filter(pk=self.element.id).exists())

    def test_delete_element_not_found(self):
        self.client.login(username='admin', password='pass123')

        url = reverse("delete_element", args=[self.event.id, 999999])  # nonexistent element
        response = self.client.get(url)

        self.assertEqual(response.status_code, 404)


class NoPermissionViewTest(BaseLeafletTestCase):

    def test_no_permission_renders_template(self):
        response = self.client.get(reverse("no_permission"))
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, "leaflet/leaflet_no_permission.html")


