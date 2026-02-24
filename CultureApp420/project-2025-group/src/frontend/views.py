from django.contrib.auth.decorators import login_required
from django.shortcuts import render
from .forms import ProgramLeafletForm
from .models import ProgramLeaflet
import json


@login_required
def index(request):
    form = ProgramLeafletForm()
    return render(request, "frontend/program_leaflet_form.html", {"form": form})

# take the post request and save the form data to the database
@login_required
def submit_program_leaflet(request):
    if request.method == "POST":
        form = ProgramLeafletForm(request.POST)
        if form.is_valid():
            leaflet = form.save()
            
         
            program_content_json = request.POST.get('program_content', '[]')
            try:
                program_content = json.loads(program_content_json)
              
                for item in program_content:
                    if item.get('type') == 'participants' and 'names' in item:
                        item['names_str'] = item.pop('names')
                leaflet.program_content = program_content
                leaflet.save()
            except json.JSONDecodeError:
           
                pass
            
            # Process contributors for display (split into two columns)
            contributors_lines = leaflet.contributors.strip().split('\n') if leaflet.contributors else []
            mid_point = len(contributors_lines) // 2
            contributors_left = contributors_lines[:mid_point]
            contributors_right = contributors_lines[mid_point:]
            
            return render(request, "frontend/program_leaflet_detail.html", {
                "leaflet": leaflet,
                "contributors_left": contributors_left,
                "contributors_right": contributors_right,
            })
    else:
        form = ProgramLeafletForm()
    return render(request, "frontend/program_leaflet_form.html", {"form": form})


