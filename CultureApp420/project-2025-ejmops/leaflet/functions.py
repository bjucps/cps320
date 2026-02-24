
from django.utils import timezone


def check_user_login(user):
    return user.is_authenticated

def check_is_admin(user):
    return check_user_login(user) and user.groups.filter(name='MusicArtsAdmin').exists()

def get_current_school_year():
    today = timezone.now().date()
    if today.month <= 5:
        return f"{today.year - 1}-{today.year}"
    else:
        return f"{today.year}-{today.year + 1}"
