from django.db import models
from django.forms import ValidationError
from cryptography.fernet import Fernet
import json
import datetime

key = Fernet.generate_key()
fernet = Fernet(key)
attendaces_MU098 = 2
attendaces_MU099 = 5


def next_id():  # provide an option for a default value for the ID. There should never be an item created without one, but this is a failsafe
    index = 1
    try:
        while Event.objects.get(event_id=index):
            index += 1
    except:
        pass
    return index

# Create your models here.
class Event(models.Model):
    event_id = models.CharField(primary_key=True, max_length=50, unique=True, default=next_id)
    event_name = models.CharField(max_length=100)
    event_date = models.DateField()
    event_time = models.TimeField(null=True, blank=True)
    event_location = models.CharField(max_length=100, null=True, blank=True)
    mu_required = models.BooleanField(default=False)

    def attendance_link_address(self):      # generate a link address to the attendance tracker
        enc_name = fernet.encrypt(f"{self.event_name}_{self.pk}".encode())
        return enc_name.decode()
    
    def load_events_json():
        try:
            with open("events.json", "r") as file:
                data = json.load(file)

                items = data['items']
        except FileNotFoundError:
            print("Unable to find 'events.json'")
        except json.JSONDecodeError:
            print("Unable to decode JSON file")

        for item in items:
            item_id = item["id"]
            try:
                o = Event.objects.get(event_id=item_id)
                continue    
            except Event.DoesNotExist:
                pass
            name = item["summary"]
            try:
                location = item["location"]
            except KeyError:
                location = None
            try:
                date_time = item["start"]["dateTime"]
                date, time = date_time.split("T")
                time = time.split("-")[0]
            except KeyError:
                date = item["start"]["date"]
                time = None
            try:
                attendance = item["extendedProperties"]["shared"]["roll"]
                if attendance == "true": attendance = True
                else: attendance = False
            except KeyError:
                attendance = False

            e = Event(event_id=item_id,
                    event_name=name,
                    event_date=date,
                    event_time=time,
                    event_location=location,
                    mu_required=attendance
                    )
            e.save()

class Student(models.Model):
    stu_name = models.CharField(max_length=100)
    stu_email = models.CharField(max_length=100)
    stu_total_attendances = models.IntegerField(default=0)
    stu_enroll_MU098 = models.BooleanField(default=False)   # 2 required attendances
    stu_enroll_MU099 = models.BooleanField(default=False)   # 5 required attendances
    attended_events = models.ManyToManyField(Event)

    def student_increment_attendance(self):
        self.stu_total_attendances += 1
        self.save()

    def student_attendance_needed(self):
        return ((self.stu_enroll_MU098 and (self.stu_total_attendances < attendaces_MU098)) or
                (self.stu_enroll_MU099 and (self.stu_total_attendances < attendaces_MU099)))

    def count_attendances_needed(self):
        if self.stu_enroll_MU098:
            return attendaces_MU098 - self.stu_total_attendances
        elif self.stu_enroll_MU099:
            return attendaces_MU099 - self.stu_total_attendances
        
    def record_attendance(self, e: Event):
        events = self.attended_events.all()
        if e not in events:
            self.student_increment_attendance()
            self.attended_events.add(e)
        
    def reset(self):
        self.stu_total_attendances = 0
        self.save()
        self.attended_events.clear()

    def get_events_list(self):
        events = self.attended_events.all()
        string = ""
        for event in events:
            string += event.event_name
            string += "\n"
        return string
    
    def clean(self):
        if self.stu_enroll_MU098 and self.stu_enroll_MU099:
            raise ValidationError("Student can only be a music major or a music minor, not both!")

class Day:
    def __init__(self, day: str):
        self.day = day
        self.color = (255, 255, 255)
        self.day_num = self.day.split("-")[-1]
        self.events: list[Event] = Event.objects.filter(event_date=self.day)
        self.update()

    def update(self):
        if self.day == datetime.datetime.today().strftime("%Y-%m-%d"):
            self.color = (52, 213, 235)
        else:
            self.color = (255, 255, 255)

class Month_Page:
    months = {}
    day_counts = [31,28,31,30,30,30,31,31,30,31,30,31]
    def __init__(self, month: int = None, year: int = None):
        self.cur_date = datetime.datetime.now()
        self.month = month
        self.year = year

        if not self.month:
            self.month = self.cur_date.month
        if not self.year:
            self.year = self.cur_date.year

        self.days = self.day_counts[self.month-1]

        self.month_name = datetime.datetime(self.year, self.month, 1).strftime("%B")
        Month_Page.months[f"{self.month}-{self.year}"] = self

        if self.month == 2 and not self.year % 4 and (not self.year % 400 or self.year % 100):
            self.days += 1

        d = datetime.date(self.year, self.month, 1)
        weekday = int(d.strftime("%w"))
        self.weeks: list[list[Day]] = []

        for day in range(self.days):
            if len(self.weeks) == 0 or len(self.weeks[-1]) == 7:
                self.weeks.append([])
                if day == 0:
                    for _ in range(weekday):
                        self.weeks[0].append(None)
            self.weeks[-1].append(Day(f"{self.year}-{self.month}-{day+1:02}"))
        while len(self.weeks[-1]) < 7:
            self.weeks[-1].append(None)
    
    def next(self):
        month_num = self.month+1
        year_num = self.year
        if month_num > 12: 
            month_num = 1
            year_num = self.year+1
        try:        # prevent making duplicates of a month if it exists already
            m = Month_Page.months[f"{month_num}-{year_num}"]
        except KeyError:
            m = Month_Page(month_num, year_num)
        return m

    def prev(self):
        month_num = self.month-1
        year_num = self.year
        if month_num < 1: 
            month_num = 12
            year_num = self.year-1
        try:        # prevent making duplicates of a month if it exists already
            m = Month_Page.months[f"{month_num}-{year_num}"]
        except KeyError:
            m = Month_Page(month_num, year_num)
        return m

    def update_days(self):
        for w in self.weeks:
            for d in w:
                if d:
                    d.update()

class Month_Manager:
    def __init__(self):
        self.displayed_month = Month_Page()
        self.current_month = self.displayed_month

    def next(self):
        self.displayed_month = self.displayed_month.next()
        self.displayed_month.update_days()

    def prev(self):
        self.displayed_month = self.displayed_month.prev()
        self.displayed_month.update_days()

    def reset(self):
        self.displayed_month = self.current_month

class Events_Table_Manager:
    def __init__(self, table, size=10):
        self.page_size = size
        self.page = 0
        if table == None:
            return
        self.table = table
        self.displayed = self.table[self.page*self.page_size:self.page_size+self.page*self.page_size]

    def load_table(self, table):        # use to load in a table if the class was initialized without the table available
        self.table = table
        self.displayed = self.table[self.page*self.page_size:self.page_size+self.page*self.page_size]
    
    def next(self):
        if self.page < len(self.table) % self.page_size + 1:
            self.page += 1
        try:
            self.displayed = self.table[self.page*self.page_size:self.page_size+self.page*self.page_size]
        except IndexError:
            self.displayed = self.table[self.page*self.page_size:]

    def prev(self):
        if self.page > 0:
            self.page -= 1
        self.displayed = self.table[self.page*self.page_size:self.page_size+self.page*self.page_size]

    def reset(self):
        self.page = 0
        self.displayed = self.table[self.page*self.page_size:self.page_size+self.page*self.page_size]
    
    def get(self):
        return self.displayed