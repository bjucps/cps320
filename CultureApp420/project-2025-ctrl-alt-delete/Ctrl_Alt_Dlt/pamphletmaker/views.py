import os
from datetime import date
from bs4 import BeautifulSoup
from django.conf import settings
from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.http import HttpResponseForbidden, FileResponse
from django.templatetags.static import static
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Image, PageBreak
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.pagesizes import letter
from reportlab.lib.enums import TA_CENTER, TA_LEFT, TA_RIGHT
from reportlab.lib.units import inch
from .models import Event
from webstrings import *
from io import BytesIO

CssFileName = static('styles.css')
sortby = ["startDate", "StartTime"]

ALIGN_MAP = {
    "ql-align-left": TA_LEFT,
    "ql-align-center": TA_CENTER,
    "ql-align-right": TA_RIGHT
}

def index(request):
    events = Event.objects.all().order_by(sortby[0], sortby[1])
    return render(request, "home.html", {"events": events, "title": AlEvnts})

def links(request):
    events = Event.objects.all().order_by(sortby[0], sortby[1])
    file_path = os.path.join(settings.BASE_DIR,
        'pamphletmaker',
        'templates',
        'programStuff',
        'links.txt')
    content = []
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            for line in f:
                temp = line.split(";")
                content.append([temp[0], temp[1][0:len(temp[1])-1]])
    except FileNotFoundError:
        print("AHHH FAILURE")
    return render(request, "links.html", {"events": events, "title": AlEvnts, "Links": content})

@login_required
def pMaker(request):
    events = Event.objects.all()
    selectedEvent = None
    pamphletContent = ""
    file_path = os.path.join(settings.BASE_DIR,
        'pamphletmaker',
        'templates',
        'programStuff',
        'programTemp.html')
    id = request.GET.get('progPicker')

    if request.method == 'POST':
        if 'resetAll' in request.POST:
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                for event in events:
                    event.pamphlet = content
                    event.save()
            except FileNotFoundError:
                print("AHHH FAILURE")
        elif 'pdfconvert' in request.POST:
            if id:
                selectedEvent = Event.objects.get(id=id)
                return pdffer(selectedEvent)
        else:
            pamphlet_text = request.POST.get('pamphlet')
            if id:
                selectedEvent = Event.objects.get(id=id)
                selectedEvent.pamphlet = pamphlet_text
                selectedEvent.save()
                pamphletContent = selectedEvent.pamphlet
    else:
        if id:
            selectedEvent = Event.objects.get(id=id)
            pamphletContent = selectedEvent.pamphlet

    context = {
        'events': events,
        'selectedEvent': selectedEvent,
        'pamphletContent': pamphletContent,
        'title': "Pamphlet Maker",
    }
    return render(request, 'pmaker.html', context)

def getDownlaodsPath(filename):
    downloadDirectory = os.path.join(os.path.expanduser("~"), "Downloads")
    os.makedirs(downloadDirectory, exist_ok=True)
    return os.path.join(downloadDirectory, filename)

QUILL_SIZE_MAP = {
    "ql-size-small": 8,
    "": 12,              # default
    "ql-size-large": 16,
    "ql-size-huge": 20
}

def getStyle(base_style, tag):
    alignment = TA_LEFT
    font_size = 12  # default

    # Alignment from Quill classes
    if 'class' in tag.attrs:
        for cls in tag['class']:
            if cls in ALIGN_MAP:
                alignment = ALIGN_MAP[cls]
            if cls in QUILL_SIZE_MAP:
                font_size = QUILL_SIZE_MAP[cls]

    # Inline style overrides
    if 'style' in tag.attrs:
        styles = tag['style'].split(';')
        for s in styles:
            if 'font-size' in s:
                val = s.split(':')[1].strip()
                if val.endswith('px'):
                    font_size = float(val[:-2])
                elif val.endswith('pt'):
                    font_size = float(val[:-2])
                else:
                    try:
                        font_size = float(val)
                    except:
                        pass

    style = ParagraphStyle(
        name="custom",
        parent=base_style,
        alignment=alignment,
        fontName="Helvetica",
        fontSize=font_size
    )
    return style


def htmlToRl(tag):
    if isinstance(tag, str):
        return tag
    text = ""
    for child in tag.contents:
        t = ""
        if child.name in ["strong", "b"]:
            t = f"<b>{htmlToRl(child)}</b>"
        elif child.name in ["em", "i"]:
            t = f"<i>{htmlToRl(child)}</i>"
        elif child.name == "u":
            t = f"<u>{htmlToRl(child)}</u>"
        elif child.name == "span":
            font_size_tag = ""
            if 'class' in child.attrs:
                for cls in child['class']:
                    if cls in QUILL_SIZE_MAP:
                        font_size_tag = f'<font size="{QUILL_SIZE_MAP[cls]}">'
            style_font_size = ""
            color_tag = ""
            if 'style' in child.attrs:
                styles = child['style'].split(';')
                for s in styles:
                    if 'font-size:' in s:
                        val = s.split(':')[1].strip()
                        if val.endswith('px') or val.endswith('pt'):
                            val = float(val[:-2])
                        else:
                            try:
                                val = float(val)
                            except:
                                val = None
                        if val:
                            style_font_size = f'<font size="{val}">'
                    if 'color:' in s:
                        color = s.split('color:')[1].split(';')[0].strip()
                        color_tag = f'<font color="{color}">'

            inner = htmlToRl(child)
            if style_font_size:
                t = f"{style_font_size}{inner}</font>"
            elif color_tag:
                t = f"{color_tag}{inner}</font>"
            elif font_size_tag:
                t = f"{font_size_tag}{inner}</font>"
            else:
                t = inner
        else:
            t = htmlToRl(child)
        text += t
    return text


def addPageBrs(ptagText, story, styles):
    if isinstance(ptagText, str):
        lines = ptagText.splitlines()
        for line in lines:
            if line.strip() == "[PAGE_BREAK]":
                story.append(PageBreak())
            elif line.strip():
                story.append(Paragraph(line.strip(), styles['Normal']))
                story.append(Spacer(1, 0.2*inch))
    else:
        rl_text = htmlToRl(ptagText)
        style = getStyle(styles['Normal'], ptagText)
        story.append(Paragraph(rl_text, style))
        story.append(Spacer(1, 0.2*inch))
        if 'class' in ptagText.attrs and 'page-break' in ptagText['class']:
            story.append(PageBreak())



def handleImages(tag, story, max_width=200, max_height=200):
    for imgTag in tag.find_all('img'):
        src = imgTag.get('src')
        if src:
            if src.startswith('/static/'):
                img_path = os.path.join(settings.BASE_DIR, src.lstrip('/').replace('/', os.sep))
            else:
                img_path = src
            try:
                im = Image(img_path)
                # Maintain aspect ratio while limiting size
                if im.drawWidth > max_width or im.drawHeight > max_height:
                    ratio = min(max_width / im.drawWidth, max_height / im.drawHeight)
                    im.drawWidth *= ratio
                    im.drawHeight *= ratio

                im.hAlign = 'CENTER'
                story.append(im)
                story.append(Spacer(1, 0.2*inch))
            except Exception as e:
                print(f"Failed to add image: {img_path}, {e}")
        imgTag.decompose()


def pdffer(event):
    buffer = BytesIO()
    doc = SimpleDocTemplate(buffer, pagesize=letter,
                            rightMargin=72, leftMargin=72,
                            topMargin=72, bottomMargin=72)
    styles = getSampleStyleSheet()
    story = []

    sections = event.pamphlet.split("[PAGE_BREAK]")

    for section in sections:
        soup = BeautifulSoup(section, 'html.parser')
        handleImages(soup, story)
        for pTag in soup.find_all(['p', 'div']):
            text = htmlToRl(pTag)
            style = getStyle(styles['Normal'], pTag)
            if text.strip():
                story.append(Paragraph(text, style))
                story.append(Spacer(1, 0.2*inch))
        story.append(PageBreak())

    if story and isinstance(story[-1], PageBreak):
        story.pop()

    doc.build(story)
    buffer.seek(0)
    safe_name = "".join(c for c in event.name if c.isalnum() or c in (' ', '_')).rstrip()
    return FileResponse(buffer, as_attachment=True, filename=f"{safe_name}_pamphlet.pdf")

@login_required
def emailGen(request):
    if not request.user.has_perm(generalAdminPerms):
        return HttpResponseForbidden(genNoPermResp)
    today = date.today()
    events = Event.objects.filter(startDate__year=today.year, startDate__month=today.month).order_by(sortby[0], sortby[1])
    return render(request, 'emailGen.html', {"events": events, "title": emailGenTxt})
