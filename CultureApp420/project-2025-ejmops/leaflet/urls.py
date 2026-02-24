from django.urls import path
from . import views
from django.conf.urls import handler404
from django.shortcuts import render

urlpatterns = [
    path('', views.home, name='home'),
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('event_builder/', views.event_builder, name='event_builder'),

    path('event/<int:pk>', views.event_view, name='event'),
    path('section_builder/<int:event_id>', views.event_section_builder, name='section_builder'),
    path('elements_builder/<int:event_id>/<int:event_section_id>', views.event_elements_builder, name='elements_builder'),
    path('edit_event/<int:pk>', views.edit_event, name='edit_event'),
    path('delete_event/<int:pk>', views.delete_event, name='delete_event'),
    path('delete_section/<int:pk>/<int:section_id>', views.delete_section, name='delete_section'),
    path('no_permission/', views.no_permission, name='no_permission'),
    path('delete_element/<int:event_id>/<int:element_id>', views.delete_element_view, name='delete_element'),
]

def custom_404(request, exception):
    return render(request, 'leaflet/leaflet_404.html', status=404)

handler404 = custom_404