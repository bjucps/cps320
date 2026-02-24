import json
from django.core.management.base import BaseCommand
from django.utils.dateparse import parse_date, parse_datetime
from django.utils import timezone
from django.utils.timezone import make_aware
from pamphletmaker.models import Event


class Command(BaseCommand):
    help = "Load events from a JSON file into the database"

    def add_arguments(self, parser):
        parser.add_argument("file_path", type=str, help="Path to the JSON file")

    def dateConverter(self, value):
        """Convert a string to a date (handles both date and dateTime)."""
        if not isinstance(value, str):
            return None
        date = parse_datetime(value)
        if date:
            return date.date()
        date = parse_date(value)
        if date:
            return date
        return None

    def datetimeConverter(self, value):
        """Convert to timezone-aware datetime (for created/updated)."""
        if not isinstance(value, str):
            return None
        date = parse_datetime(value)
        if date:
            return make_aware(date) if timezone.is_naive(date) else date
        date = parse_date(value)
        if date:
            return make_aware(timezone.datetime.combine(date, timezone.datetime.min.time()))
        return None

    def handle(self, *args, **options):
        file_path = options["file_path"]
        print(f"Loading events from {file_path}...")

        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        events = data.get("items", [])
        for ev in events:
            extended = ev.get("extendedProperties", {}).get("shared", {})

            # Safely handle both "date" and "dateTime"
            startTemp = ev.get("start", {}).get("dateTime") or ev.get("start", {}).get("date")
            endTemp = ev.get("end", {}).get("dateTime") or ev.get("end", {}).get("date")

            startDate = self.dateConverter(startTemp) or timezone.now().date()
            endDate = self.dateConverter(endTemp) or timezone.now().date()

            createdDate = self.datetimeConverter(ev.get("created")) or timezone.now()
            updatedDate = self.datetimeConverter(ev.get("updated")) or timezone.now()

            Event.objects.update_or_create(
                eventId=ev.get("id"),
                defaults={
                    "name": ev.get("summary"),
                    "status": ev.get("status") or "pending",
                    "htmlLink": ev.get("htmlLink"),
                    "created": createdDate,
                    "updated": updatedDate,
                    "summary": ev.get("summary"),
                    "location": ev.get("location"),
                    "creator_email": ev.get("creator", {}).get("email"),
                    "organizerEmail": ev.get("organizer", {}).get("email"),
                    "organizerName": ev.get("organizer", {}).get("displayName"),
                    "startDate": startDate,
                    "endDate": endDate,
                    "StartTime": timezone.now(),
                    "roll": extended.get("roll", "false").lower() == "true",
                    "url_text": extended.get("url_text"),
                    "short_title": extended.get("short_title"),
                    "room": extended.get("room"),
                    "url": extended.get("url"),
                    "tags": extended.get("tags"),
                },
            )

        print("done")
