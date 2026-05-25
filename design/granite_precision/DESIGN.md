---
name: Granite Precision
colors:
  surface: '#131314'
  surface-dim: '#131314'
  surface-bright: '#393939'
  surface-container-lowest: '#0e0e0f'
  surface-container-low: '#1b1b1c'
  surface-container: '#201f20'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353535'
  on-surface: '#e5e2e2'
  on-surface-variant: '#c5c6cb'
  inverse-surface: '#e5e2e2'
  inverse-on-surface: '#313031'
  outline: '#8e9195'
  outline-variant: '#44474a'
  surface-tint: '#c1c7cf'
  primary: '#ffffff'
  on-primary: '#2b3137'
  primary-container: '#dde3eb'
  on-primary-container: '#5f656c'
  inverse-primary: '#595f66'
  secondary: '#b7c8e1'
  on-secondary: '#213145'
  secondary-container: '#3a4a5f'
  on-secondary-container: '#a9bad3'
  tertiary: '#ffffff'
  on-tertiary: '#3a2e24'
  tertiary-container: '#f3dfd0'
  on-tertiary-container: '#706256'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#dde3eb'
  primary-fixed-dim: '#c1c7cf'
  on-primary-fixed: '#161c22'
  on-primary-fixed-variant: '#41474e'
  secondary-fixed: '#d3e4fe'
  secondary-fixed-dim: '#b7c8e1'
  on-secondary-fixed: '#0b1c30'
  on-secondary-fixed-variant: '#38485d'
  tertiary-fixed: '#f3dfd0'
  tertiary-fixed-dim: '#d6c3b5'
  on-tertiary-fixed: '#241a11'
  on-tertiary-fixed-variant: '#51443a'
  background: '#131314'
  on-background: '#e5e2e2'
  surface-variant: '#353535'
typography:
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '700'
    lineHeight: '1.2'
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '700'
    lineHeight: '1.2'
  headline-md:
    fontFamily: Hanken Grotesk
    fontSize: 20px
    fontWeight: '600'
    lineHeight: '1.4'
  body-lg:
    fontFamily: Hanken Grotesk
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: Hanken Grotesk
    fontSize: 14px
    fontWeight: '400'
    lineHeight: '1.5'
  label-sm:
    fontFamily: Hanken Grotesk
    fontSize: 12px
    fontWeight: '600'
    lineHeight: '1'
    letterSpacing: 0.05em
  mono-data:
    fontFamily: JetBrains Mono
    fontSize: 13px
    fontWeight: '400'
    lineHeight: '1.4'
spacing:
  base: 4px
  gutter: 1.5rem
  margin-mobile: 1rem
  margin-desktop: 2rem
  container-max: 1280px
---

## Brand & Style

This design system is inspired by high-end industrial engineering and modular hardware. The personality is professional, utilitarian, and uncompromisingly precise. It targets a technical audience that values structural integrity, performance, and clarity over decorative flair.

The aesthetic follows a **Modern Industrial** movement:
- **Flat UI:** Depth is conveyed through tonal layering rather than shadows or gradients.
- **High-Precision:** Every element is aligned to a rigid grid, reflecting the tight tolerances of a well-engineered machine.
- **Monochromatic Sophistication:** The UI relies on a restricted palette of grays and silvers to maintain focus on content and data.

## Colors

The color strategy mimics the physical materials of a professional workstation. 

- **Primary Surface (#1A1A1A):** The foundation, representing deep granite or anodized magnesium.
- **Secondary Surface (#2D2D2D):** Used for elevated containers, sidebars, or toolbars to provide subtle structural contrast.
- **Primary Accent (#E2E8F0):** A cool silver used for interactive states and high-emphasis elements.
- **Cool Slate Blue (#94A3B8):** Reserved for information-dense indicators and secondary actions.
- **Borders (#404040):** Precision "seams" that define the boundaries of the modular layout without adding visual weight.

## Typography

This design system utilizes **Hanken Grotesk** for all primary interfaces. Its clean, sharp geometry complements the industrial aesthetic. 

- **Headlines:** Set with tight letter-spacing and heavy weights to create a sense of structural permanence.
- **Labels:** Small caps or uppercase labels are used for technical metadata and UI controls to mimic etched equipment labels.
- **Technical Data:** While Hanken Grotesk is the primary face, **JetBrains Mono** may be used for specific technical readouts or code blocks to reinforce the precision theme.

## Layout & Spacing

The layout follows a **Fixed-Fluid Hybrid Grid** model based on a 4px baseline.

- **Grid:** A 12-column system is used for desktop. Components should align strictly to column boundaries.
- **Gutters:** Standardized at 24px (1.5rem) to ensure clear separation of modular panels.
- **Modular Panels:** Content should be grouped into distinct, border-defined modules. Avoid "open" layouts; use the `surface_secondary` color to box out functional areas.
- **Breakpoints:**
  - Mobile: <768px (Single column, 16px margins).
  - Tablet: 768px - 1024px (Reduced gutters, 8-column grid).
  - Desktop: >1024px (Full 12-column grid, 1280px max width).

## Elevation & Depth

In accordance with the flat industrial style, this design system **eschews all shadows and blurs.** Depth is created through a "Step-Up" tonal system:

1.  **Level 0 (Base):** `surface_primary` (#1A1A1A). The main background.
2.  **Level 1 (Panels):** `surface_secondary` (#2D2D2D). Used for cards, sidebars, and main content areas.
3.  **Level 2 (Interaction):** `surface_tertiary` (#3D3D3D). Used for hover states and active inputs.

All elements are separated by 1px solid borders using the `border_color`. This "schematic" approach ensures that even without shadows, the hierarchy remains distinct and legible.

## Shapes

The shape language is strictly **Sharp (0px radius)**. There are no exceptions for buttons, cards, inputs, or tooltips. This zero-radius approach reinforces the "milled from a single block" industrial feel and ensures maximum pixel-perfect alignment across the grid.

## Components

### Buttons
- **Primary:** Background `primary_color_hex` (Silver), text `surface_primary`. Sharp edges.
- **Secondary:** Transparent background, 1px border of `primary_color_hex`, text `primary_color_hex`.
- **Ghost:** No background or border, text `secondary_color_hex`.

### Input Fields
- **Default:** Background `surface_primary`, 1px border `border_color`, text `white`.
- **Focus:** 1px border `primary_color_hex` (Silver). No "glow" or shadow.
- **Labels:** Use `label-sm` typography, positioned strictly above the input.

### Cards & Containers
- Containers must use `surface_secondary` and a 1px border. 
- Headers within cards should be separated by a 1px horizontal rule.

### Chips & Status Indicators
- **Technical Chips:** Rectangular, `surface_tertiary` background, `label-sm` text.
- **Status:** Uses small 8x8px square indicators (non-rounded) instead of circular dots.

### Data Tables
- Header row: `surface_tertiary` background, uppercase `label-sm` text.
- Row separators: 1px solid `border_color`. No zebra striping; use hover highlight `surface_tertiary` instead.