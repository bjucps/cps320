"""
URL configuration for brunneus_ferrum_malleus project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""

from django.contrib import admin
from django.urls import path

from . import views

urlpatterns = [
    path("admin/", admin.site.urls),
    path("events/", views.events),
    path("scan/", views.scan),
    path("", views.home),
    path("record/<int:event_id>/", views.record_attendance, name="record_attendance"),
    path("api/events/", views.EventListAPI.as_view(), name="api_events"),
    path("api/attendance/", views.AttendanceListAPI.as_view(), name="api_attendance"),
]
