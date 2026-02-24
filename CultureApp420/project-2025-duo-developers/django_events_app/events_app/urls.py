from django.urls import path
from . import views

app_name = "events_app"

urlpatterns = [
    path("", views.index, name="index"),

    path("register/<int:event_id>/", views.register_event, name="register_event"),
    path("unregister/<int:event_id>/", views.unregister_event, name="unregister_event"),

    path("export/<int:event_id>/", views.export_csv, name="export_csv"),

    path("manage/<int:event_id>/", views.manage_event, name="manage_event"),

    path("checkin/<int:registration_id>/", views.checkin_view, name="checkin"),
    path("checkin/<str:token>/", views.checkin_by_token, name="checkin_token"),
]
