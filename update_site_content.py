
import re

def update_ai_chat():
    path = "ai-chat.html"
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    # CSS Fix
    css_insertion = """
            .case-study .btn-primary {
                padding: 0.8rem 1.5rem !important;
                font-size: 0.9rem !important;
                white-space: nowrap;
                width: auto !important;
            }
        }"""
    # Look for the end of the desktop-headline block inside the media query
    target_css = """            .desktop-headline {
                display: none !important;
            }
        }"""
    
    if target_css in content:
        # Check if we already added it (to avoid duplication if previous partial steps worked)
        if ".case-study .btn-primary" not in content:
            content = content.replace(target_css, """            .desktop-headline {
                display: none !important;
            }

            .case-study .btn-primary {
                padding: 0.8rem 1.5rem !important;
                font-size: 0.9rem !important;
                white-space: nowrap;
                width: auto !important;
            }
        }""")
            print("Updated CSS in ai-chat.html")

    # Text Update
    # Old text pattern (partial) to identify the paragraph
    # We will use regex to find the paragraph containing "St. Christopher's International School's"
    
    new_text = """                    <p style="margin-bottom: 1.5rem; font-size: 1.1rem; line-height: 1.6;">For example, we integrated an
                        <strong>AI Chat, School Visit Calendar, and Careers Form</strong> into
                        <strong>St. Christopher's International School's</strong> existing website. The result?
                        <strong>Instant 24/7 responses</strong>, more <strong>school visit tours</strong>, and a transparent <strong>visual pipeline</strong>—directly resulting in <strong>more enrollments</strong>.
                    </p>"""
    
    # Regex to capture the full paragraph
    pattern = re.compile(r'<p style="margin-bottom: 1\.5rem; font-size: 1\.1rem; line-height: 1\.6;">.*?St\. Christopher\'s International School\'s.*?<\/p>', re.DOTALL)
    
    if pattern.search(content):
        content = pattern.sub(new_text, content)
        print("Updated Text in ai-chat.html")
    else:
        print("Could not find text pattern in ai-chat.html")

    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

def update_online_calendar():
    path = "online-calendar.html"
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    # CSS Fix
    target_css = """            .desktop-headline {
                display: none !important;
            }
        }"""

    if target_css in content:
        if ".case-study .btn-primary" not in content:
            content = content.replace(target_css, """            .desktop-headline {
                display: none !important;
            }

            .case-study .btn-primary {
                padding: 0.8rem 1.5rem !important;
                font-size: 0.9rem !important;
                white-space: nowrap;
                width: auto !important;
            }
        }""")
            print("Updated CSS in online-calendar.html")

    # Text Update
    new_text = """                    <p style="margin-bottom: 1.5rem; font-size: 1.1rem; line-height: 1.6;">For example, we integrated a
                        <strong>School Visit Calendar</strong> into
                        <strong>St. Christopher's International School's</strong> existing website. The result? Parents
                        can now <strong>book school tours 24/7</strong> and receive <strong>automated appointment
                            reminders</strong>. The system provides a transparent <strong>visual pipeline</strong> and
                        <strong>automatically follows up on missed appointments</strong>—directly resulting in <strong>more enrollments</strong>.
                    </p>"""

    pattern = re.compile(r'<p style="margin-bottom: 1\.5rem; font-size: 1\.1rem; line-height: 1\.6;">.*?St\. Christopher\'s International School\'s.*?<\/p>', re.DOTALL)
    
    if pattern.search(content):
        content = pattern.sub(new_text, content)
        print("Updated Text in online-calendar.html")
    else:
        print("Could not find text pattern in online-calendar.html")

    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

if __name__ == "__main__":
    update_ai_chat()
    update_online_calendar()
