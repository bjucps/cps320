from django.urls import path
from django.conf import settings
from django.contrib.auth import views as auth_views
from django.conf.urls.static import static

from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path("pm/", views.pMaker, name="pMaker"),
    path("eg/", views.emailGen, name="emailGen"),
    path("links/", views.links, name="resLink"),
    path('logout/', auth_views.LogoutView.as_view(), name='logout', kwargs={'next_page': '/'}),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)