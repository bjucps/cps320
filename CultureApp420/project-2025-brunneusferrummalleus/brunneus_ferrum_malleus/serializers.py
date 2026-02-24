from rest_framework import serializers

from .models import Attendance, Event


class EventSerializer(serializers.ModelSerializer):
    location_name = serializers.CharField(
        source="location.name", read_only=True, default=None
    )
    formatted_date = serializers.CharField(source="date", read_only=True)

    class Meta:
        model = Event
        fields = [
            "id",
            "title",
            "description",
            "date_start_time",
            "date_end_time",
            "formatted_date",
            "link",
            "location_name",
        ]


class AttendanceSerializer(serializers.ModelSerializer):
    event_title = serializers.CharField(source="event.title", read_only=True)

    class Meta:
        model = Attendance
        fields = ["id", "event", "event_title", "email", "present", "checked_in_at"]
