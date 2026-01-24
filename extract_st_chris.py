import subprocess

def get_git_content():
    cmd = ["git", "show", "7e2d34889d0e75e3247f02e30dc8dfe7719e8e54:ai-chat.html"]
    result = subprocess.run(cmd, capture_output=True, text=True, encoding='utf-8')
    return result.stdout

content = get_git_content()
if not content:
    print("Failed to get content")
    exit(1)

lines = content.split('\n')
start_printing = False
printed_lines = 0

# We want the section with St. Christopher
# We'll look for the class "case-study" that CONTAINS St. Christopher
# Or just look for the specific lines.

target_marker = "St. Christopher"
section_start = '<section class="case-study"'
section_end = '</section>'

# Find the line with St. Christopher
target_idx = -1
for i, line in enumerate(lines):
    if target_marker in line:
        target_idx = i
        break

if target_idx == -1:
    print("Target not found")
    exit(1)

# Backtrack to find section start
start_idx = -1
for i in range(target_idx, -1, -1):
    if section_start in lines[i]:
        start_idx = i
        break

# Forward track to find section end
end_idx = -1
nested_divs = 0 
# Simple heuristic: exact matching </section> that closes the one at start_idx
# Since we are just grabbing a block, looking for the next </section> after target might work if it's the main container.
for i in range(target_idx, len(lines)):
    if section_end in lines[i]:
        end_idx = i + 1
        break

if start_idx != -1 and end_idx != -1:
    print('\n'.join(lines[start_idx:end_idx]))
else:
    print(f"Indices not found strings. Start: {start_idx}, End: {end_idx}")
