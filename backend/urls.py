from django.urls import path
from .views import health, root

urlpatterns = [
    path('health', health),
    path('', root),  # Root endpoint
]

