import os
import re

# Global Replacements
GLOBAL_MAP = {
    'Services ?': 'Services ▼',
    '?? +254': '📞 +254',
    '?? chat@': '📧 chat@',
    '(1 Star = ??, 5 Stars = ??)': '(1 Star = 😞, 5 Stars = 🤩)',
    # Footer arrows? usually not there, but let's check.
}

# Icon Map based on H3 headers
ICON_MAP = {
    # Websites
    'Modern Design': '🎨',
    'Integrated Tools': '🛠️',
    'Smart Contacts': '📞',
    'Interactive Maps': '🗺️',
    'Filtered Reviews': '⭐',
    'Website Tracking': '📊',
    'Flexible Pricing': '💲',
    
    # SMS
    'Instant Reach': '⚡',
    'Automated Campaigns': '⚙️',
    '2-Way Conversations': '💬',
    'High ROI': '💰',
    
    # Email
    'Drag & Drop Builder': '🎨',
    'Smart Automation': '🤖',
    'Precise Segmentation': '🎯',
    'Detailed Analytics': '📊',
    
    # Calendar
    'Easy Integration': '🔗',
    'Embed & Share': '🌍',
    'Automated Reminders': '🔔',
    'Team Scheduling': '👥',
    
    # Social Planner (Guessing likely headers if not seen)
    'Multi-Platform': '📱',
    'Bulk Scheduling': '🗓️',
    'Content Calendar': '📅',
    'Analytics': '📊',
    
    # Documents
    'Templates': '📄',
    'E-Signatures': '✍️',
    'Tracking': '👁️',
    'Secure Storage': '🔒',
    
    # CRM
    'Unified Inbox': '📥',
    'Pipeline Management': '📊',
    'Mobile App': '📱',
    'Missed Call Text Back': '↩️',
    
    # GBP
    'Local SEO': '📍',
    'Customer Interaction': '💬',
    'Insights': '📈',
    'Post Updates': '📢',
    
    # Ads
    'Cross-Platform': '🌐',
    'AI Optimization': '🤖',
    'Real-Time Analytics': '📊',
    'Budget Control': '💰',
    
    # AI Chat
    '24/7 Availability': '🌙',
    'Lead Capture': '🧲',
    'Instant Answers': '⚡',
    'Human Handoff': '🤝',
    
    # QR Codes
    'Dynamic Codes': '🔄',
    'Custom Design': '🎨',
    'Tracking & Analytics': '📊',
    'Touchless Interaction': '👋'
}

def restore_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    
    # 1. Global text replacements
    for bad, good in GLOBAL_MAP.items():
        if bad in content:
            content = content.replace(bad, good)
            
    # 2. Context-aware Icon replacements
    # Pattern: <div class="icon">??</div> (whitespace) <h3>Title</h3>
    # We use a regex sub with a callback
    
    def replace_icon(match):
        full_match = match.group(0)
        icon_div = match.group(1) # The <div...>...</div> part
        bad_icon = match.group(2) # The ?? inside
        title = match.group(3)    # The Title
        
        # Check if we have a mapping
        # Title might have extra whitespace
        clean_title = title.strip()
        
        if clean_title in ICON_MAP:
            new_icon = ICON_MAP[clean_title]
            return f'<div class="icon">{new_icon}</div>\n                    <h3>{title}</h3>'
        else:
            # If no map, keep as is
            return full_match

    # Regex:
    # <div class="icon">(\?+)</div>\s*<h3>(.*?)</h3>
    # We want to match explicitly '?' or '??' or '???' inside the div
    pattern = r'(<div class="icon">(\?+)</div>)\s*<h3>(.*?)</h3>'
    
    content = re.sub(pattern, replace_icon, content)

    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Restored icons in {os.path.basename(filepath)}")
    else:
        print(f"No changes in {os.path.basename(filepath)}")

def main():
    files = [f for f in os.listdir('.') if f.endswith('.html')]
    for file in files:
        # Skip index.html if it's already good (it seemed good), but running regex won't hurt if conditions aren't met
        restore_file(file)

if __name__ == "__main__":
    main()
