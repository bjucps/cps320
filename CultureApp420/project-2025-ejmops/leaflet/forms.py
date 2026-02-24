from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User

from leaflet.models import Event, Element, EventSection

#
# class SignUpForm(UserCreationForm):
#     email = forms.EmailField(required=True)
#
#     class Meta:
#         model = User
#         fields = ("username", "email", "password1", "password2")

class EventForm(forms.ModelForm):
    date = forms.DateField(widget=forms.DateInput(attrs={'type': 'date'}))
    time = forms.TimeField(widget=forms.TimeInput(attrs={'type': 'time'}))

    class Meta:
        model = Event
        fields = ("title", "location", "date", "institution", "time", "director", 'division')


class EventSectionForm(forms.ModelForm):
    class Meta:
        model = EventSection
        fields = ('section_title',)

class EventElementsForms(forms.ModelForm):
    class Meta:
        model = Element
        fields = ('performance_title', 'author', 'performer', 'type')

# class EditSectionForm(forms.ModelForm):
#     class Meta:
#         model = EventSection
#         fields = ('section_title',)
#
#     def __init__(self,  *args, **kwargs):
#         section_id = kwargs.pop('section_id', None)
#         super().__init__(*args, **kwargs)
#         if section_id:
#             section = EventSection.objects.get(pk=section_id)
#             self.initial['section_title'] = section.section_title