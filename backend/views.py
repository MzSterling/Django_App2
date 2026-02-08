from django.http import HttpResponse

def health(request):
    return HttpResponse("Media Analytics App is Running")
