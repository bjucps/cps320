# events_app/views.py
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib.admin.views.decorators import staff_member_required
from django.contrib import messages
from django.conf import settings
from django.http import HttpResponse
from django.db.models import Count
import csv

from .models import Event, Registration, CheckIn

# index view
@login_required
def index(request):
    # fetch events with related dates and registration counts
    events = (
        Event.objects
        .prefetch_related("dates")
        .annotate(reg_count=Count("registration"))  # count registrations
        .order_by("dates__date")
        .distinct()
    )
    my_event_ids = set(
        Registration.objects.filter(user=request.user)
        .values_list("event_id", flat=True)
    )
    return render(
        request, "events_app/index.html",
        {"events": events, "my_event_ids": my_event_ids}
    )

# register view
@login_required
def register_event(request, event_id):
    if request.method != "POST":
        return redirect("events_app:index")

    event = get_object_or_404(Event, pk=event_id)
    capacity = event.capacity or 0
    current = Registration.objects.filter(event=event, waitlist=False).count()

    # if capacity exceeded, add to waitlist
    waitlist = current >= capacity if capacity > 0 else False

    reg, created = Registration.objects.get_or_create(
        user=request.user,
        event=event,
        defaults={"waitlist": waitlist, "confirmed": "T"},
    )

    if not created:
        messages.info(request, "You are already registered for this event.")
    else:
        if waitlist:
            messages.warning(request, "Capacity full — added to waitlist.")
        else:
            messages.success(request, "Successfully registered!")

    return redirect("events_app:index")

# unregister view
@login_required
def unregister_event(request, event_id):
    if request.method != "POST":
        return redirect("events_app:index")

    event = get_object_or_404(Event, pk=event_id)
    deleted, _ = Registration.objects.filter(user=request.user, event=event).delete()

    if deleted:
        messages.success(request, f'Unregistered from "{event.title}".')

        # If there is a waitlist, promote the first person
        next_wait = (
            Registration.objects
            .filter(event=event, waitlist=True)
            .order_by("registered_at")
            .first()
        )
        if next_wait:
            next_wait.waitlist = False
            next_wait.confirmed = "C"
            next_wait.save()
    else:
        messages.info(request, "You were not registered for this event.")

    return redirect("events_app:index")

# csv export view
@staff_member_required
def export_csv(request, event_id):
    event = get_object_or_404(Event, pk=event_id)
    resp = HttpResponse(content_type="text/csv")
    resp["Content-Disposition"] = f'attachment; filename="registrations_{event_id}.csv"'

    writer = csv.writer(resp)
    writer.writerow(
    ["username", "first_name", "last_name", "email", "waitlist", "confirmed"]
)


    qs = (Registration.objects
          .filter(event=event)
          .select_related("user")
          .order_by("registered_at"))

    for r in qs:
        u = r.user
    writer.writerow([
        u.username,
        u.first_name,
        u.last_name,
        u.email,
        r.waitlist,
        r.confirmed,     # 'T', 'C', 'D' 같은 코드 값
    ])

    return resp

# manage event view
@staff_member_required
def manage_event(request, event_id):
    event = get_object_or_404(Event, pk=event_id)
    registrations = (
        Registration.objects
        .filter(event=event)
        .select_related("user")
        .order_by("registered_at")
    )
    # e.g., http://localhost:8000
    origin = settings.QR_BASE_URL

    return render(request, "events_app/manage_event.html", {
        "event": event,
        "registrations": registrations,
        "origin": origin,
    })

# check-in view
@staff_member_required
def checkin_view(request, registration_id):
    registration = get_object_or_404(
        Registration.objects.select_related("user", "event"),
        pk=registration_id,
    )

    # already checked in?
    if hasattr(registration, "checkin"):
        messages.info(
            request,
            f"{registration.user.username} is already checked in.",
        )
    else:
        CheckIn.objects.create(registration=registration)
        messages.success(
            request,
            f"{registration.user.username} checked in for {registration.event.title}.",
        )

    return redirect("events_app:manage_event", event_id=registration.event_id)

def checkin_by_token(request, token):
    reg = get_object_or_404(Registration, qr_token=token)

    # checked in already?
    if hasattr(reg, 'checkin'):
        return HttpResponse("Already checked in!")

    # create check-in record
    CheckIn.objects.create(registration=reg)

    return HttpResponse("Check-in completed for " + reg.user.username)
