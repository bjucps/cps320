from django.test import TestCase, Client
from django.core.exceptions import ValidationError
from django.contrib.auth.models import User
from django.urls import reverse
import json

from frontend.models import ProgramLeaflet
from frontend.templatetags.text_filters import format_bold, format_text, add_class


class ProgramLeafletTests(TestCase):
    def setUp(self):
        """Set up test data."""
        self.valid_data = {
            'title': 'ALL CREATION SINGS!',
            'subtitle': 'LYRIC CHOIR',
            'director': 'Laura Brundage, director',
            'location': 'War Memorial Chapel',
            'date': 'Wednesday, April  30, 2025',
            'time': '5:30 P.M.',
            'program_content': [{'type': 'piece', 'title': 'Exsultate', 'author': 'Andy Beck  (b. 1896)'}],
            'contributors': 'Anonymous\nAnonymous',
            'donor_title': 'BECOME A  FRIEND OF MUSIC AT BJU!',
            'donor_text': ("We depend on Friends like you to deliver transformative learning experiences for our Music At BJU students. "
                           "Join us in our commitment to pursuing and sharing the beauty of God through musical excellence and redemptive artistry by making a tax-deductible donation to the Division of Music"),
            'donor_link': 'https://music.bju.edu/friends',
            'upcoming_events': 'Men’s Glee, May 1, 5:30 p.m., War Memorial Chapel',
            'mission_statement': 'The Division of Music at BJU is a community of students, faculty, and staff committed to empowering musicians to pursue and share the beauty of God through redemptive artistry.'
        }

    def test_create_program_leaflet(self):
        """Test basic creation of a program leaflet using provided valid_data."""
        leaflet = ProgramLeaflet.objects.create(**self.valid_data)
        self.assertEqual(leaflet.title, self.valid_data['title'])
        self.assertEqual(leaflet.subtitle, self.valid_data['subtitle'])
        self.assertEqual(leaflet.director, self.valid_data['director'])
        self.assertEqual(leaflet.location, self.valid_data['location'])
        self.assertEqual(leaflet.program_content[0]['title'], 'Exsultate')

    def test_default_values(self):
        """Test that default values are set correctly for institution and division."""
        leaflet = ProgramLeaflet.objects.create(**self.valid_data)
        self.assertEqual(leaflet.institution, 'Bob Jones University')
        self.assertEqual(leaflet.division, 'Division of Music')

    def test_blank_subtitle(self):
        """Test that subtitle can be blank."""
        data = self.valid_data.copy()
        data['subtitle'] = ''
        leaflet = ProgramLeaflet.objects.create(**data)
        self.assertEqual(leaflet.subtitle, '')

    def test_json_field(self):
        """Test that JSON data is stored and retrieved correctly."""
        program_items = [
            {'type': 'piece', 'title': 'Moonlight Sonata', 'author': 'Beethoven'},
            {'type': 'piece', 'title': 'Clair de Lune', 'author': 'Debussy'}
        ]
        data = self.valid_data.copy()
        data['program_content'] = program_items
        leaflet = ProgramLeaflet.objects.create(**data)
        saved_leaflet = ProgramLeaflet.objects.get(id=leaflet.id)
        self.assertEqual(saved_leaflet.program_content, program_items)
        self.assertEqual(len(saved_leaflet.program_content), 2)

    def test_empty_json_field(self):
        """Test default empty list for JSON field when not provided."""
        data = self.valid_data.copy()
        data.pop('program_content')
        leaflet = ProgramLeaflet.objects.create(**data)
        self.assertEqual(leaflet.program_content, [])

    def test_required_fields(self):
        """Test that required (non-default, non-blank) fields must be provided."""
        # Fields that are truly required (not blank=True, not default)
        required_fields = [
            'title', 'director', 'location', 'date', 'time',
            'contributors', 'donor_title', 'donor_text', 'upcoming_events'
        ]
        for field in required_fields:
            data = self.valid_data.copy()
            data.pop(field)
            leaflet = ProgramLeaflet(**data)
            with self.assertRaises(Exception):  # ValidationError or other
                leaflet.full_clean()

    def test_max_length_constraints(self):
        """Test character field maximum length constraints by exceeding allowed length."""
        char_fields = {
            'title': 200,
            'subtitle': 200,
            'institution': 200,
            'division': 200,
            'director': 200,
            'location': 200,
            'date': 100,
            'time': 100,
            'donor_title': 100,
        }
        for field, max_length in char_fields.items():
            data = self.valid_data.copy()
            data[field] = 'x' * (max_length + 1)
            leaflet = ProgramLeaflet(**data)
            with self.assertRaises(Exception):
                leaflet.full_clean()

    def test_valid_url(self):
        """Test that donor_link must be a valid URL (expects ValidationError)."""
        data = self.valid_data.copy()
        data['donor_link'] = 'not-a-valid-url'
        leaflet = ProgramLeaflet(**data)
        with self.assertRaises(ValidationError):
            leaflet.full_clean()


class TemplateFilterTests(TestCase):
    def test_format_bold(self):
        """Test bold formatting filter."""
        result = format_bold('**bold text**')
        self.assertIn('<strong>bold text</strong>', result)
    
    def test_format_italic(self):
        """Test italic formatting filter."""
        result = format_bold('*italic text*')
        self.assertIn('<em>italic text</em>', result)
    
    def test_format_underline(self):
        """Test underline formatting filter."""
        result = format_bold('_underline text_')
        self.assertIn('<u>underline text</u>', result)
    
    def test_format_text_with_linebreaks(self):
        """Test format_text preserves line breaks."""
        result = format_text('line1\nline2')
        self.assertIn('<br>', result)
    
    def test_format_empty(self):
        """Test filters handle empty values."""
        self.assertEqual(format_bold(''), '')
        self.assertEqual(format_text(None), None)


class ViewTests(TestCase):
    def setUp(self):
        """Create a test user and client."""
        self.client = Client()
        self.user = User.objects.create_user(username='testuser', password='testpass')
        self.client.login(username='testuser', password='testpass')
    
    def test_index_view_requires_login(self):
        """Test that index view requires authentication."""
        self.client.logout()
        response = self.client.get(reverse('index'))
        self.assertEqual(response.status_code, 302)  # Redirect to login
    
    def test_index_view_authenticated(self):
        """Test that authenticated users can access index."""
        response = self.client.get(reverse('index'))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'form')
    
    def test_submit_get_request(self):
        """Test GET request to submit view returns form."""
        response = self.client.get(reverse('submit_program_leaflet'))
        self.assertEqual(response.status_code, 200)
