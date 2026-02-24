from django.shortcuts import get_object_or_404, render, redirect
from django.utils import timezone
from HelloWorld.models import Event, Student, fernet, Month_Manager, Events_Table_Manager
import QRgenerator
# Create your views here.

month_manager = Month_Manager()
table_manager = Events_Table_Manager(None)  # have to manually load the table in later
try:
    current_user = Student.objects.all()[0]     # grab a student object as a filler user
    current_user.reset()            # TODO: RESETS EVERYTIME JUST FOR A CLEAN RUN NEEDS TO BE REMOVED IN ANY COMPLETE RELEASE
except IndexError:
    current_user = None

def qr_view(request, ev_name):
    QRgenerator.gen_QR("http://localhost:8000/")
    name, key = ev_name.split('_')      # link is formatted as EVENTNAME_PRIMARYKEY
    event = get_object_or_404(Event, event_name=name, pk=key)       # match both the name and the key
    return render(request, 'qr_viewer.html', {'event_name': event, 'image': 'qr.png'})

def calendar_view(request):
    return render(request, "templates/calendar_page.html", {'month' : month_manager.displayed_month})

def next_month_view(request):
    month_manager.next()
    return redirect('HelloWorld:calendar')

def prev_month_view(request):
    month_manager.prev()
    return redirect('HelloWorld:calendar')

def reset_month_view(request):
    month_manager.reset()
    return redirect('HelloWorld:calendar')

def next_table_view(request):
    table_manager.next()
    return redirect('HelloWorld:events')

def prev_table_view(request):
    table_manager.prev()
    return redirect('HelloWorld:events')

def reset_table_view(request):
    table_manager.reset()
    return redirect('HelloWorld:events')

def attendance_view(request, atd_str):
    # record successful attendance information
    # redirect to success_view
    ev_name = fernet.decrypt(atd_str).decode()
    name, key = ev_name.split('_')      # link is formatted as EVENTNAME_PRIMARYKEY
    event = get_object_or_404(Event, event_name=name, pk=key)       # match both the name and the key
    # TODO: get a working system to keep track of the current student
    current_user.record_attendance(event)
    return redirect('HelloWorld:success')

def success_view(request):
    return render(request, 'success.html')

def student_attendance_view(request):
    return render(request, "attendance_table.html", {'student': current_user})

def events_view(request):
    Event.load_events_json()
    objs = Event.objects.filter(event_date__gt=timezone.now().date())
    table_manager.load_table(objs)
    return render(request, "templates/events_page.html", 
                  {'events_headers': ["Event", "Date", "Time", "Location", "Attendance"],
                   'events': table_manager.get()})
