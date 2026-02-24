from django.shortcuts import render, redirect
from django.contrib.auth.forms import AuthenticationForm
from django.contrib.auth import login
from .forms import EventForm, EventElementsForms, EventSectionForm
from .functions import check_user_login, check_is_admin, get_current_school_year
from django.contrib.auth import logout
from django.contrib.auth.decorators import user_passes_test
from django.shortcuts import get_object_or_404
from .models import Event, Element, EventSection
import qrcode
import base64
from io import BytesIO

def home(request):
    is_logged_in = check_user_login(request.user)
    is_admin = check_is_admin(request.user)
    events = Event.objects.filter(school_year=get_current_school_year())
    return render(request, 'leaflet/leaflet_home.html', {'is_logged_in': is_logged_in, 'is_admin': is_admin, 'events': events})

def login_view(request):
    if request.method == "POST":
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)
            return redirect("home")
    else:
        form = AuthenticationForm()
    return render(request, "leaflet/leaflet_login.html", {"form": form})

def logout_view(request):
    logout(request)
    return redirect("home")


@user_passes_test(check_is_admin, login_url="no_permission")
def event_builder(request):
    if request.method == "POST":
        form = EventForm(request.POST)
        if form.is_valid():
            title = form.cleaned_data['title']
            director = form.cleaned_data['director']
            date = form.cleaned_data['date']
            time = form.cleaned_data['time']
            institution = form.cleaned_data['institution']
            location = form.cleaned_data['location']
            division = form.cleaned_data['division']
            Event.objects.create(title=title, director=director, date=date, time=time, institution=institution, location=location, division=division)
            last_event = Event.objects.filter().order_by("created_at").last()
            return redirect("event", last_event.id)
    else:
        form = EventForm()
    return render(request, "leaflet/leaflet_event_builder.html", {'form': form})

@user_passes_test(check_is_admin, login_url="no_permission")
def event_section_builder(request, event_id):
    event = get_object_or_404(Event, id=event_id)
    if request.method == "POST":
        form = EventSectionForm(request.POST)
        if form.is_valid():
            event_title = form.cleaned_data['section_title']
            EventSection.objects.create(event=event, section_title=event_title)
            return redirect("event", event_id)
    return redirect("event", event_id)


@user_passes_test(check_is_admin, login_url="no_permission")
def event_elements_builder(request, event_id, event_section_id):
    event_section = get_object_or_404(EventSection, pk=event_section_id)
    event = get_object_or_404(Event, id=event_id)
    if request.method == "POST":
        form = EventElementsForms(request.POST)
        if form.is_valid():
            performance_title = form.cleaned_data['performance_title']
            author = form.cleaned_data['author']
            performer = form.cleaned_data['performer']
            performance_type = form.cleaned_data['type']
            Element.objects.create(event_section=event_section, performance_title=performance_title, author=author, performer=performer, type=performance_type)
    return redirect("event", event.id)


def event_view(request, pk):
    is_admin = check_is_admin(request.user)
    event = get_object_or_404(Event, pk=pk)
    sections = EventSection.objects.filter(event=event)
    event_contents = {}
    data = "https://music.bju.edu/friends"
    qr = qrcode.make(data)

    buffer = BytesIO()
    qr.save(buffer, format="PNG")
    donor_qr = base64.b64encode(buffer.getvalue()).decode()
    buffer.close()
    # edit_section_forms = {}
    for section in sections:
        event_contents[section.section_title] = [section, Element.objects.filter(event_section=section)]
        # edit_section_forms[section.id] = EditSectionForm(instance=section)
    section_form = EventSectionForm()
    element_form = EventElementsForms()
    edit_form = EventForm(initial={'title': event.title, 'director': event.director, 'date': event.date, 'time': event.time, 'institution': event.institution, 'location': event.location, 'division': event.division})
    return render(request, "leaflet/leaflet_event_view.html", {
        'event': event,
        'element_form':element_form,
        'section_form':section_form ,
        'event_contents': event_contents,
        'is_admin': is_admin,
        'edit_form': edit_form,
        # 'edit_section_forms': edit_section_forms,
        'donor_qr': donor_qr,
    })


@user_passes_test(check_is_admin, login_url="no_permission")
def edit_event(request, pk):
    event = get_object_or_404(Event, pk=pk)
    if request.method == "POST":
        form = EventForm(request.POST, instance=event)
        if form.is_valid():
            event.title = form.cleaned_data['title']
            event.director = form.cleaned_data['director']
            event.date = form.cleaned_data['date']
            event.time = form.cleaned_data['time']
            event.institution = form.cleaned_data['institution']
            event.location = form.cleaned_data['location']
            event.division = form.cleaned_data['division']
            form.save()
            return redirect("event", pk)
    return redirect("event", pk)

@user_passes_test(check_is_admin, login_url="no_permission")
def delete_event(request, pk):
    event = get_object_or_404(Event, pk=pk)
    if request.method == "POST":
        event_sections = EventSection.objects.filter(event=event)
        for event_section in event_sections:
            element = Element.objects.filter(event_section=event_section)
            element.delete()
            event_section.delete()
        event.delete()
        return redirect("home")
    else:
        return redirect("home")

@user_passes_test(check_is_admin, login_url="no_permission")
def delete_section(request, pk, section_id):
    event = get_object_or_404(Event, pk=pk)
    section = EventSection.objects.filter(event=event ,id=section_id).first()
    if section:
        elements = Element.objects.filter(event_section=section)
        for element in elements:
            element.delete()
    section.delete()
    return redirect("event", pk)

def delete_element_view(request, event_id, element_id):
    element = get_object_or_404(Element, pk=element_id)
    element.delete()
    return redirect("event", event_id)


def no_permission(request):
    return render(request, "leaflet/leaflet_no_permission.html")

