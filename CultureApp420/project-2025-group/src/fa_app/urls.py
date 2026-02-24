"""
URL configuration for fa_app project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
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
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path, include
from django.http import (HttpResponse)



from fa_app import settings

# Force admin to use our login
admin.site.login_template = None
admin.autodiscover()

urlpatterns = [
    path('', include('api.urls')),
    path("admin/", admin.site.urls),
    path("", include("frontend.urls")),
    path('oauth2/', include('django_auth_adfs.urls', namespace='django_auth_adfs')),
    path("health/", lambda request: HttpResponse("OK"), name="health_check"),
]


urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
if hasattr(settings, 'MEDIA_URL') and hasattr(settings, 'MEDIA_ROOT'):
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
