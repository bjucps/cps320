import base64
import io
import secrets

import qrcode
from django.contrib import admin, messages
from django.core.cache import cache
from django.core.management import call_command
from django.http import HttpResponseRedirect, JsonResponse
from django.shortcuts import render
from django.urls import path, reverse
from django.utils.html import format_html

from .models import Attendance, Event, Location

admin.site.register(Location)


@admin.register(Attendance)
class AttendanceAdmin(admin.ModelAdmin):
    list_display = ("event", "email", "present", "checked_in_at")
    list_filter = ("event", "present")
    search_fields = ("email",)


@admin.register(Event)
class EventAdmin(admin.ModelAdmin):
    list_display = ("title", "date", "qr_code")
    change_list_template = "admin/event_changelist.html"

    @admin.display(description="Generate QR code")
    def qr_code(self, obj):
        url = reverse("admin:brunneus_ferrum_malleus_event_qr_code", args=[obj.pk])

        return format_html('<a href="{}" class="button">Generate QR code</a>', url)

    def get_urls(self):
        urls = super().get_urls()
        new_urls = [
            path(
                "import-events/",
                self.admin_site.admin_view(self.import_events_view),
                name="brunneus_ferrum_malleus_event_import",
            ),
            path(
                "<int:object_id>/qr-code",
                self.admin_site.admin_view(self.event_qr_code),
                name="brunneus_ferrum_malleus_event_qr_code",
            ),
            path(
                "<int:object_id>/gen-token",
                self.admin_site.admin_view(self.gen_qr_token),
                name="brunneus_ferrum_malleus_gen_token",
            ),
        ]
        return new_urls + urls

    def import_events_view(self, request):
        """Run the import_events management command and redirect back."""
        try:
            call_command("import_events")
            messages.success(request, "Successfully imported events from events.json")
        except Exception as e:
            messages.error(request, f"Error importing events: {e}")
        return HttpResponseRedirect(reverse("admin:brunneus_ferrum_malleus_event_changelist"))

    def event_qr_code(self, request, object_id):
        event = self.get_object(request, object_id)

        token_url_name = f"admin:{self.model._meta.app_label}_gen_token"
        token_url = reverse(token_url_name, args=[event.pk])

        context = dict(
            self.admin_site.each_context(request),
            event=event,
            token_url=token_url,
        )

        return render(request, "admin/event_qr_code.html", context)

    def gen_qr_token(self, request, object_id):
        token = secrets.token_hex(4)
        cache_key = f"event_{object_id}_token"
        cache.set(cache_key, token, timeout=5)

        url = request.build_absolute_uri(
            reverse("record_attendance", args=[object_id]) + f"?token={token}"
        )

        qr = qrcode.QRCode(version=1)
        qr.add_data(url)
        qr.make(fit=True)
        img = qr.make_image()
        buffer = io.BytesIO()
        img.save(buffer, "PNG")
        string = base64.b64encode(buffer.getvalue()).decode()
        return JsonResponse({"qr_image_data": string})
