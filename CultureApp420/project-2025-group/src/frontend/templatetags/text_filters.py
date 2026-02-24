from django import template
from django.utils.safestring import mark_safe
import re

register = template.Library()

@register.filter
def format_bold(value):
    """
    Convert **text** to <strong>text</strong>, *text* to <em>text</em>, and _text_ to <u>text</u>.
    Usage: {{ text|format_bold }}
    """
    if not value:
        return value
    
    formatted = str(value)
    
    # Convert **text** to <strong>text</strong> (bold)
    formatted = re.sub(r'\*\*(.*?)\*\*', r'<strong>\1</strong>', formatted)
    
    # Convert *text* to <em>text</em> (italic) - but not if it's already part of **text**
    formatted = re.sub(r'(?<!\*)\*([^*]+?)\*(?!\*)', r'<em>\1</em>', formatted)
    
    # Convert _text_ to <u>text</u> (underline)
    formatted = re.sub(r'_([^_]+?)_', r'<u>\1</u>', formatted)
    
    return mark_safe(formatted)

@register.filter
def format_text(value):
    """
    Format text with bold/italic/underline support and preserve line breaks.
    Usage: {{ text|format_text }}
    """
    if not value:
        return value
    
    formatted = str(value)
    
    # Convert **text** to <strong>text</strong> (bold)
    formatted = re.sub(r'\*\*(.*?)\*\*', r'<strong>\1</strong>', formatted)
    
    # Convert *text* to <em>text</em> (italic) - but not if it's already part of **text**
    formatted = re.sub(r'(?<!\*)\*([^*]+?)\*(?!                             \*)', r'<em>\1</em>', formatted)
    
    # Convert _text_ to <u>text</u> (underline)
    formatted = re.sub(r'_([^_]+?)_', r'<u>\1</u>', formatted)
    
    # Convert line breaks to <br> tags
    formatted = formatted.replace('\n', '<br>')
    
    return mark_safe(formatted)

@register.filter
def add_class(field, css_class):
    """
    Add CSS classes to form field widgets.
    Usage: {{ form.field|add_class:"form-control" }}
    """
    if hasattr(field, 'as_widget'):
        return field.as_widget(attrs={'class': css_class})
    return field
