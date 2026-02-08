from django.http import HttpResponse

# Health endpoint (for ALB)
def health(request):
    return HttpResponse("OK")


def health(request):
    return HttpResponse("Media Analytics App is Running")
