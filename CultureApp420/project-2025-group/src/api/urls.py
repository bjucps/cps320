from django.urls import path
from api import views

urlpatterns = [
    path('api/events/', views.event_list),
    path('api/events/<int:pk>', views.event_detail),
    path('events/<int:pk>', views.event_page)

]