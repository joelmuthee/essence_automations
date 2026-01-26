# GA4 Button Tracking Implementation

I have implemented a **Global Event Tracking System** that automatically tags and tracks button clicks across your entire website.

## How it Works

A new script in `main.js` listens for clicks on any:
- Link (`<a>`)
- Button (`<button>`, `.btn`)
- Input Button (`<input type="submit">`)

### 1. Automatic "Smart" Identification
If you do nothing, the system automatically identifies the button using:
1. The **Text** of the button (e.g., "Book Demo")
2. The **ID** (if text is missing)
3. The **Link URL** (fallback)

This means **every button is now tracked instantly** without you needing to edit every file!

### 2. Manual "Pro" Tagging (Optional)
For specific tracking control (e.g., distinguishing between two "Learn More" buttons), you can add `data-ga-*` attributes to your HTML elements.

**Example from `index.html` (Hero Section):**
```html
<a href="#contact" d
   class="btn-primary" 
   data-ga-category="Hero Section" 
   data-ga-label="Book Demo CTA">
   Book Demo
</a>
```

## Data Sent to Google Analytics

When a user clicks a button, the following event is sent to GA4:

| Parameter | Value | Example |
|-----------|-------|---------|
| **Event Name** | `click` | `click` |
| **Category** | `data-ga-category` OR "Button/Link Click" | "Hero Section" |
| **Label** | `data-ga-label` OR Button Text | "Book Demo CTA" |
| **link_url** | The `href` of the link | `#contact` |
| **link_text** | The visible text | "Book Demo" |

## Changes Made
- **`main.js`**: Added the global tracking event listener at the bottom of the file.
- **`index.html`**: Tagged the main Hero buttons ("Book Demo" & "Explore Features") as a live example.

## Verification
- **Scenario 1**: Click "Book Demo" -> Sends `Category: Hero Section`, `Label: Book Demo CTA`.
- **Scenario 2**: Click "About" (Menu) -> Sends `Category: Button/Link Click`, `Label: About`.


## Performance Optimization (Popup Speed)

To make the CTA popup forms load instantly, I implemented two key optimizations in `v1.0.16`:

### 1. Show/Hide Toggle (Logic Change)
**Problem:** Previously, the code destroyed and re-created the iframe every time the popup closed/opened to "reset" the form. This caused a 1-2 second loading delay on every click.
**Solution:** I updated `main.js` to keep the iframe alive in the background.
- **First Click:** Loads the iframe (normal speed).
- **Subsequent Clicks:** Simply unhides the existing iframe (Instant/0ms delay).
- **Trade-off:** If a user submits a form, the "Thank You" message persists if they open it again. This is an acceptable trade-off for the massive speed gain.

### 2. Pre-connection (Network Hint)
**Problem:** The browser waits until the user clicks to look up the form server (`link.essenceautomations.com`).
**Solution:** Added `<link rel="preconnect">` to `index.html`.
- This tells the browser to perform the DNS lookup and SSL handshake immediately on page load, shaving ~300ms off the initial form load time.
