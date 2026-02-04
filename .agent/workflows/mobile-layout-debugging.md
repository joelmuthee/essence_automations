---
description: Guidelines for fixing mobile layout issues efficiently
---
# Mobile Layout Debugging Protocol

## Context
Mobile layout issues are often caused by a combination of:
1.  **Browser Caching**: The device holds onto old styles.
2.  **Viewport Height Ambiguity**: `100vh` behaves differently on mobile due to URL bars.
3.  **Flexbox Centering**: `justify-content: center` can cause content to overlap fixed headers when height is constrained.
4.  **Implicit Sizing**: Elements with `height: auto` or `width: 100%` can behave unexpectedly when parent containers change.

## Protocol for "Element Too Big/Small"
1.  **Check Explicit Dimensions**: Do not rely on `auto`. Set explicit `max-width` and `max-height`.
2.  **Check Parent Constraints**: Ensure the container isn't forcing the child to expand (e.g., flex-stretch).
3.  **Assume Caching Issue**: Always bump the CSS version (see `cache-busting-protocol.md`).

## Protocol for "Content Disappearing/Overlapping"
1.  **Disable Centering**: Switch `justify-content` from `center` to `flex-start` on mobile. Centering + Fixed Header = Overlap.
2.  **Force Top Padding**: Use explicit `padding-top` to clear fixed headers. Do not rely on margins or relative positioning.
    *   *Calculation*: `Header Height` + `20px Safety` = `Padding Top`.
3.  **Use `min-height`**: Replace `height: 100vh` with `min-height: 100vh` to allow scrolling if content overflows.

## Step-by-Step Fix Loop
1.  **Analyze**: Is it a size issue or a position issue?
2.  **Nuclear Fix**: Apply `!important` and explicit pixel values first to confirm control. Refine later.
3.  **Cache Bust**: Increment `?v=XX`.
4.  **Verify**: Ask user to check *after* confirming the version bump.
