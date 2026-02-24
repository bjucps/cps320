from django.shortcuts import get_object_or_404, render
from django.core.cache import cache
from rest_framework import generics

from brunneus_ferrum_malleus.models import Attendance, Event
from .serializers import EventSerializer, AttendanceSerializer


def events(request):
    """A view of all bands."""
    events = Event.objects.all()
    return render(
        request,
        "events/event_listing.html",
        {"events": events},
    )


def home(request):
    return render(request, "home.html", {})


def scan(request):
    return render(request, "scan.html", {})


def record_attendance(request, event_id):
    event = get_object_or_404(Event, pk=event_id)
    token = request.GET.get("token")

    email = request.GET.get("email")

    if not email:
        return render(
            request, "attendance_fail.html", {"event": event, "error": f"invalid email"}
        )

    cache_key = f"event_{event_id}_token"
    valid_token = cache.get(cache_key)

    if valid_token == token:
        Attendance.objects.get_or_create(
            event=event, email=email, defaults={"present": True}
        )

        return render(request, "attendance_success.html", {"event": event})
    else:
        return render(
            request, "attendance_fail.html", {"event": event, "error": "invalid email"}
        )


class EventListAPI(generics.ListAPIView):
    """API endpoint to list all events."""
    queryset = Event.objects.select_related('location').order_by('date_start_time')
    serializer_class = EventSerializer


class AttendanceListAPI(generics.ListAPIView):
    """API endpoint to list all attendance records."""
    queryset = Attendance.objects.select_related('event').order_by('-checked_in_at')
    serializer_class = AttendanceSerializer
