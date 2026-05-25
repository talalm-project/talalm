---
name: Talalm Design System
colors:
  surface: '#29051e'
  surface-dim: '#29051e'
  surface-bright: '#562b45'
  surface-container-lowest: '#220118'
  surface-container-low: '#330d27'
  surface-container: '#38112b'
  surface-container-high: '#441b36'
  surface-container-highest: '#512641'
  on-surface: '#ffd8eb'
  on-surface-variant: '#d7c1c8'
  inverse-surface: '#ffd8eb'
  inverse-on-surface: '#4c223c'
  outline: '#9f8c92'
  outline-variant: '#524249'
  surface-tint: '#ffafd2'
  primary: '#ffafd2'
  on-primary: '#5b113c'
  primary-container: '#772953'
  on-primary-container: '#f995c4'
  inverse-primary: '#95416c'
  secondary: '#ffb59e'
  on-secondary: '#5e1700'
  secondary-container: '#c33900'
  on-secondary-container: '#ffe7e0'
  tertiary: '#cdc5bd'
  on-tertiary: '#34302a'
  tertiary-container: '#4a453f'
  on-tertiary-container: '#bab3aa'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffd8e7'
  primary-fixed-dim: '#ffafd2'
  on-primary-fixed: '#3d0025'
  on-primary-fixed-variant: '#782a54'
  secondary-fixed: '#ffdbd0'
  secondary-fixed-dim: '#ffb59e'
  on-secondary-fixed: '#3a0b00'
  on-secondary-fixed-variant: '#852400'
  tertiary-fixed: '#e9e1d8'
  tertiary-fixed-dim: '#cdc5bd'
  on-tertiary-fixed: '#1e1b16'
  on-tertiary-fixed-variant: '#4b4640'
  background: '#29051e'
  on-background: '#ffd8eb'
  surface-variant: '#512641'
typography:
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '700'
    lineHeight: '1.2'
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: '1.3'
  body-lg:
    fontFamily: Geist
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: Geist
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.5'
  label-md:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '500'
    lineHeight: '1.2'
    letterSpacing: 0.05em
  label-sm:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: '1.2'
spacing:
  unit: 8px
  gutter: 1.5rem
  container-max-width: 1440px
  sidebar-width: 280px
---

## Brand & Style

The design system for this AI notebook application is rooted in a philosophy of **Functional Brutalism**. It prioritizes extreme clarity, density of information, and a "terminal-plus" aesthetic that appeals to power users, researchers, and developers. By stripping away the visual "fluff" of the modern web—such as soft shadows, rounded corners, and depth-simulating gradients—the UI creates a high-concentration environment where the user's data and the AI's insights are the sole focus.

The emotional response should be one of **intellectual rigor and efficiency**. The interface doesn't hold the user's hand with soft affordances; instead, it provides a precise, high-contrast toolset. The "Ubuntu-inspired" aesthetic brings a sense of open-source heritage and technical reliability to the AI space.

## Colors

The palette is a sophisticated, high-contrast dark mode centered on deep aubergines and vibrant oranges. 

- **Primary (#772953):** Used for primary actions, active navigation states, and branding elements.
- **Secondary (#E95420):** Reserved for high-attention alerts, AI-generated highlights, and "New" indicators. 
- **Background (#300A24):** The foundational canvas. It provides a warm, low-fatigue dark base that is less harsh than pure black.
- **Surface (#5E2750):** Used for cards, sidebars, and input backgrounds to create visual separation without needing shadows.
- **Text:** High-emphasis white (#FFFFFF) is used for all primary content and headings, while the medium-emphasis warm grey (#AEA79F) is used for metadata, labels, and secondary UI elements.

## Typography

This design system utilizes a trio of typefaces to balance character with technical precision. 

**Hanken Grotesk** is used for headlines, providing a sharp, contemporary feel that matches the flat UI's geometry. **Geist** serves as the primary body font, optimized for readability in long-form AI notebooks and technical documentation. **JetBrains Mono** is utilized for UI labels, metadata, and code snippets, reinforcing the application's utility-first, developer-friendly nature.

All type scales are strictly adhered to, ensuring that the hierarchy remains clear even in data-dense notebook views.

## Layout & Spacing

The layout follows a **structured fluid grid** model inspired by technical workstations. 

- **Grid System:** A 12-column grid is used for the main content area. Components should snap to the grid with 0px margin between adjacent surface blocks to create a "tiled" look where appropriate.
- **Spacing Scale:** An 8px linear scale (8, 16, 24, 32, 48, 64) governs all padding and margins. 
- **Notebook View:** The central editor uses a fixed-width "reading-focused" column (max 800px) centered within the fluid container to maintain line-length legibility, while sidebars for AI tools and file navigation remain docked.
- **Breakpoints:** 
  - Desktop: 1200px+ (full sidebar visibility)
  - Tablet: 768px - 1199px (collapsed sidebars, increased margins)
  - Mobile: <767px (stacked panels, 16px horizontal safe-area padding)

## Elevation & Depth

This design system explicitly rejects the use of Z-axis simulation through shadows or blurs. Instead, depth is communicated through **Tonal Layering** and **High-Contrast Borders**.

- **Level 0 (Background):** #300A24. The lowest layer.
- **Level 1 (Surface):** #5E2750. Used for the primary container or "panels" that sit on the background.
- **Level 2 (Inlay):** Darker shades (or 10% black overlays) are used to indicate recessed areas like text inputs or code blocks.
- **Active State:** Rather than rising (shadow), an active element is highlighted with a 2px solid border of the Secondary color (#E95420) or a solid fill change.

Interactive elements use "flat lifting"—a change in background color (e.g., from Surface to Primary) on hover—rather than any change in physical elevation.

## Shapes

The shape language is **strictly orthogonal**. All corners are 0px (sharp). 

This applies to:
- Buttons
- Cards and Panels
- Input fields
- Selection indicators
- Modals

The only exception is for circular avatars or specific status pips where a 50% radius is required for immediate recognition. Otherwise, the "squareness" of the UI is a core brand identifier, echoing the block-based nature of AI data processing.

## Components

### Buttons
- **Primary:** Solid #772953 background, #FFFFFF text. Sharp corners. On hover, background shifts to a 10% lighter shade.
- **Secondary:** Solid #E95420 background, #FFFFFF text. Used for critical AI actions.
- **Outline:** 1px solid #AEA79F border, no fill. Text #FFFFFF. 

### Input Fields
- **Default:** Background is a darker version of the Surface color. No border. Sharp corners.
- **Focus:** 2px solid #E95420 border. No glow or shadow. Text is high-emphasis white.

### Cards & Panels
- Flat blocks of #5E2750. No border-radius. Separation between cards is achieved via 8px or 16px gutters showing the #300A24 background.

### Chips & Tags
- Rectangular blocks with #300A24 background and 1px solid #772953 borders. Font is JetBrains Mono.

### Notebook Cells
- **Input Cell:** Distinct from the background with a 1px left-border of #772953.
- **AI Response Cell:** Background fill of #5E2750 with a subtle 2px left-border of #E95420 to signify AI-generated content.

### Checkboxes & Radios
- Square (0px radius) even for radio buttons. Selection is indicated by a solid #E95420 fill.