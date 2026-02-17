# mysite/mysite/urls.py     
from django.contrib import admin
from django.urls import include, path
from icecream import views
from rest_framework import routers
from django.conf.urls.static import static
from django.conf import settings

admin.site.site_header = 'Ice Cream Shop'                # default: "Django Administration"
admin.site.index_title = 'Ice Cream Management'          # default: "Site administration"
admin.site.site_title = 'Ice Cream Admin'                # default: "Django site admin"

router = routers.DefaultRouter(trailing_slash=False)
router.register('flavors', views.Flavor)
router.register('orders', views.Order)

urlpatterns = [
    path('admin/', admin.site.urls),
    path("icecream/", include("icecream.urls")),
    path('', include("icecream.urls")),
    path('rest/', include(router.urls)),
    path('accounts/login/', admin.site.login)
]  + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
 