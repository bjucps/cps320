import json
from decimal import Decimal

from django.core.management.base import BaseCommand, CommandError

from brunneus_ferrum_malleus.models import Event, Location


class Command(BaseCommand):
    help = "Imports Events and their locations"
    file_path = "events.json"

    def handle(self, *args, **options):
        """The main logic for the command."""
        try:
            with open(self.file_path, "r") as f:
                # Use parse_float=Decimal to correctly handle DecimalFields
                data = json.load(f, parse_float=Decimal)
            for location in data["locations"]:
                name = location.pop("name")
                Location.objects.update_or_create(name=name, defaults=location)
            for event in data["events"]:
                loc_obj = Location.objects.get(name=event.get("location"))
                event["location"] = loc_obj
                title = event.pop("title")
                date_start_time = event.pop("date_start_time")

                Event.objects.update_or_create(
                    title=title, date_start_time=date_start_time, defaults=event
                )

            self.stdout.write("Successfully imported events")

        except FileNotFoundError:
            raise CommandError(f'Error: File "{self.file_path}" does not exist')
        except json.JSONDecodeError:
            raise CommandError(f'Error: Could not decode JSON at "{self.file_path}"')
        except Exception as e:
            raise CommandError(f"An unexpected error occurred: {e}")
