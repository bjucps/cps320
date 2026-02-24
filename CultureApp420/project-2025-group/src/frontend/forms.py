from django import forms
from .models import ProgramLeaflet
import json


class ProgramLeafletForm(forms.ModelForm):
    mission_statement = forms.CharField(
        required=False,
        widget=forms.Textarea(attrs={'rows': 4}),
        help_text='Use **text** for bold, *text* for italic, _text_ for underline'
    )
    
    class Meta:
        model = ProgramLeaflet
        fields = '__all__'
        exclude = ['program_content']
        widgets = {
            'contributors': forms.Textarea(attrs={'rows': 5}),
            'donor_text': forms.Textarea(attrs={'rows': 3}),
            'upcoming_events': forms.Textarea(attrs={'rows': 4}),
        }


class ProgramContentForm(forms.Form):
    CONTENT_TYPES = [
        ('piece', 'Musical Piece'),
        ('performers', 'Performers List'),
        ('heading', 'Section Heading'),
        ('participants', 'Participants'),
        ('instruction', 'Instruction'),
    ]

    content_type = forms.ChoiceField(choices=CONTENT_TYPES)

    # Piece fields
    piece_title = forms.CharField(required=False, max_length=200)
    piece_author = forms.CharField(required=False, max_length=200)
    composer_dates = forms.CharField(required=False, max_length=50)

    # Performers field
    performers_list = forms.CharField(required=False, widget=forms.Textarea(attrs={'rows': 3}))

    # Heading field
    heading_text = forms.CharField(required=False, max_length=200)

    # Participants fields
    participant_part = forms.CharField(required=False, max_length=100)
    participant_names = forms.CharField(required=False, max_length=500)

    # Instruction field
    instruction_text = forms.CharField(required=False, max_length=500)
