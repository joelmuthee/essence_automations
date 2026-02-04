---
description: Ensure changes to CSS/JS propagate immediately by busting cache
---
# Cache Busting Protocol

## Context
Browsers aggressively cache CSS and JS files to improve performance. When making rapid iterative changes (especially for mobile layouts), users often don't see the updates because their device is loading the old cached file. This leads to frustration ("It's not fixed!") and unnecessary debugging cycles.

## Protocol
Whenever you modify a `.css` or `.js` file that is linked in HTML, you MUST update the version query parameter in the HTML file(s) linking to it.

### Incorrect
```html
<link rel="stylesheet" href="style.css?v=74">
```
*Making changes to `style.css` without touching this line.*

### Correct
```html
<link rel="stylesheet" href="style.css?v=75">
```
*Incrementing the version number `v=` by 1.*

## When to Apply
- **Always** when the user reports "I don't see the change".
- **Always** when modifying visual layout logic (CSS).
- **Always** when modifying interactive behavior (JS).
- **Especially Critical** for mobile debugging where hard-refreshing is difficult for users.

## Implementation Steps
1. Edit the target file (e.g., `style.css`).
2. Immediately edit the importing HTML file (e.g., `index.html`).
3. Find the `?v=XX` parameter.
4. Increment it: `?v=XX+1`.
5. Commit both files together.
