from django.conf.urls import patterns, include, url
from django.contrib import admin
from rest_framework_nested import routers

from authentication.views import AccountViewSet
from blog.views import IndexView
from authentication.views import LoginView

router = routers.SimpleRouter()
router.register(r'accounts', AccountViewSet)

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'blog.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^admin/', include(admin.site.urls)),
    url(r'^api/v1/', include(router.urls)),
    url(r'^api/v1/auth/login/$', LoginView.as_view(), name='login'),
    url('^.*$', IndexView.as_view(), name='index'),

)



