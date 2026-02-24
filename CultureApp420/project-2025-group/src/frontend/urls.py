from django.urls import path

from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path("submit_program_leaflet/", views.submit_program_leaflet, name="submit_program_leaflet"),
]
