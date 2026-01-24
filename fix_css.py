
import os

file_path = "online-calendar.html"
with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Define the insertion point: the closing brace of the media query before </style>
# Based on view_file:
# 154:                 }
# 155:             }
# 156:         </style>

target_str = "            }\n        </style>"
# We want to insert our CSS before the last brace of the media query, 
# OR just replace the end of the media query.

# Let's try to match the ".desktop-headline" block end.
context = """            .desktop-headline {
                display: none !important;
            }
        }"""

new_css = """            .desktop-headline {
                display: none !important;
            }

            .case-study .btn-primary {
                padding: 0.8rem 1.5rem !important;
                font-size: 1rem !important;
                white-space: nowrap;
                width: auto !important;
            }
        }"""

if context in content:
    new_content = content.replace(context, new_css)
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(new_content)
    print("Successfully replaced content using context match.")
else:
    # Try a looser match if indentation varies
    print("Exact match failed. Trying to find the style block end.")
    # Look for the last </style> (there might be multiple, but this one is near the top/middle)
    # Actually, the file has only one style block we inserted.
    
    start_marker = ".desktop-headline {"
    end_marker = "</style>"
    
    start_idx = content.find(start_marker)
    if start_idx != -1:
        end_idx = content.find(end_marker, start_idx)
        if end_idx != -1:
            # We found the block. Let's try to splice it in.
            # Find the last "}" before </style>
            last_brace = content.rfind("}", start_idx, end_idx)
            if last_brace != -1:
                # Insert before that brace? No, that brace closes the media query.
                insertion = """
            .case-study .btn-primary {
                padding: 0.8rem 1.5rem !important;
                font-size: 1rem !important;
                white-space: nowrap;
                width: auto !important;
            }
"""
                new_content = content[:last_brace] + insertion + content[last_brace:]
                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(new_content)
                print("Successfully spliced content.")
            else:
                print("Could not find closing brace.")
        else:
            print("Could not find </style>")
    else:
        print("Could not find .desktop-headline")
