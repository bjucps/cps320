from django.urls import path

from . import views

app_name = 'HelloWorld'
urlpatterns = [
    path("", views.events_view, name="events"),
    path("attendance/success", views.success_view, name="success"),
    path("attendance/<str:atd_str>", views.attendance_view, name="attendance"),
    path("attendance/attendance_stats/", views.student_attendance_view, name="stats"),
    path("attendance/<str:ev_name>/", views.qr_view),
    path("calendar/", views.calendar_view, name="calendar"),
    path("next_month/", views.next_month_view, name="next_month"),
    path("prev_month/", views.prev_month_view, name="prev_month"),
    path("reset_month/", views.reset_month_view, name="reset_month"),
    path("next_table/", views.next_table_view, name="next_table"),
    path("prev_table/", views.prev_table_view, name="prev_table"),
    path("reset_table/", views.reset_table_view, name="reset_table")
]