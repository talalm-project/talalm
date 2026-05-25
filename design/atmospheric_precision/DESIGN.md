---
name: Atmospheric Precision
colors:
  surface: '#131317'
  surface-dim: '#131317'
  surface-bright: '#39393d'
  surface-container-lowest: '#0e0e12'
  surface-container-low: '#1b1b1f'
  surface-container: '#201f23'
  surface-container-high: '#2a292e'
  surface-container-highest: '#353439'
  on-surface: '#e5e1e7'
  on-surface-variant: '#c7c5d1'
  inverse-surface: '#e5e1e7'
  inverse-on-surface: '#303034'
  outline: '#918f9a'
  outline-variant: '#46464f'
  surface-tint: '#c0c1ff'
  primary: '#c0c1ff'
  on-primary: '#282a61'
  primary-container: '#9395d3'
  on-primary-container: '#2a2c63'
  inverse-primary: '#575993'
  secondary: '#c1c2f5'
  on-secondary: '#2a2c56'
  secondary-container: '#434570'
  on-secondary-container: '#b3b4e7'
  tertiary: '#dfc56c'
  on-tertiary: '#3b2f00'
  tertiary-container: '#c2aa54'
  on-tertiary-container: '#4d3e00'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#e1e0ff'
  primary-fixed-dim: '#c0c1ff'
  on-primary-fixed: '#12144b'
  on-primary-fixed-variant: '#3f4179'
  secondary-fixed: '#e1e0ff'
  secondary-fixed-dim: '#c1c2f5'
  on-secondary-fixed: '#151740'
  on-secondary-fixed-variant: '#41436e'
  tertiary-fixed: '#fce185'
  tertiary-fixed-dim: '#dfc56c'
  on-tertiary-fixed: '#221b00'
  on-tertiary-fixed-variant: '#554500'
  background: '#131317'
  on-background: '#e5e1e7'
  surface-variant: '#353439'
typography:
  headline-xl:
    fontFamily: Hanken Grotesk
    fontSize: 48px
    fontWeight: '700'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Hanken Grotesk
    fontSize: 28px
    fontWeight: '600'
    lineHeight: '1.2'
  body-md:
    fontFamily: Geist
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
  body-sm:
    fontFamily: Geist
    fontSize: 14px
    fontWeight: '400'
    lineHeight: '1.5'
  label-caps:
    fontFamily: Geist
    fontSize: 12px
    fontWeight: '600'
    lineHeight: '1.0'
    letterSpacing: 0.05em
spacing:
  unit: 4px
  gutter: 24px
  margin-mobile: 16px
  margin-desktop: 64px
  container-max: 1440px
---

## Brand & Style
The design system is defined by a philosophy of **Atmospheric Precision**. It targets a professional audience seeking a focused, high-performance environment that avoids the visual fatigue of high-vibrancy interfaces. 

The aesthetic is a hybrid of **Minimalism** and **Modern Flat UI**. It prioritizes clarity through a "Zinc-tinted" palette that replaces harsh blacks and pure whites with sophisticated, desaturated tones. By utilizing sharp edges and a lack of ornamental depth, the system creates a digital workspace that feels architectural, intentional, and calm. The emotional response should be one of quiet confidence and effortless focus.

## Colors
The color palette shifts away from high-saturation aubergines toward a "Slate-Purple" spectrum. This ensures the UI remains colorful enough to be distinctive but muted enough for long-term use.

- **Primary:** A desaturated Lavender-Slate (#9395D3). It acts as the functional accent for active states and primary actions.
- **Backgrounds:** Instead of pure black, surfaces use a "Zinc" foundation (#18181B), providing a softer, paper-like quality to the dark mode.
- **Typography:** Pure white (#FFFFFF) is strictly avoided to reduce eye strain. All "white" text uses an off-white Zinc (#F4F4F5), while secondary text uses a muted Slate-Grey (#A1A1AA).
- **Functionals:** Success, Warning, and Error states should be desaturated by 15% compared to standard palettes to maintain harmony with the Slate-Purple theme.

## Typography
The typography system balances the "sharpness" of the UI with highly legible, modern grotesques. 

**Hanken Grotesk** is used for headlines to provide a clean, geometric authority. **Geist** is utilized for body text and UI labels, offering a monospaced-adjacent precision that complements the technical, flat aesthetic. 

Line heights are intentionally generous (1.6 for body text) to increase readability against the dark, low-saturation backgrounds. Letter spacing is slightly tightened on large headlines to maintain visual density and loosened on small labels for clarity.

## Layout & Spacing
The layout follows a **Fixed Grid** philosophy to reinforce the architectural feel of the design system. 

- **Grid:** A 12-column grid is used for desktop (1440px max width).
- **Rhythm:** A 4px baseline grid governs all vertical and horizontal rhythm, ensuring that every element aligns to a strict mathematical scale.
- **Density:** Elements are given ample "breathing room" (24px gutters) to counteract the lack of shadows and prevent the flat UI from feeling cluttered. 
- **Reflow:** On mobile, the 12-column grid collapses to a single-column layout with 16px side margins. Tablets utilize a 6-column grid with 24px margins.

## Elevation & Depth
This design system eschews shadows entirely in favor of **Tonal Layering** and **Line-based Hierarchy**. 

Depth is communicated through "Zinc tiers":
- **Level 0 (Base):** The darkest Slate-Zinc (#18181B).
- **Level 1 (Surface):** A slightly lighter tint (#27272A) used for cards and main containers.
- **Level 2 (Inlay):** An even lighter tint (#3F3F46) used for nested elements or hover states.

Visual separation is achieved through **1px solid borders** using a low-opacity Slate (#3F3F46). This "Ghost Border" technique defines objects without the need for heavy drop shadows, maintaining the flat, minimalist character.

## Shapes
The shape language is strictly **Sharp**. 

All buttons, cards, input fields, and containers utilize a 0px border radius. This geometric rigidity reinforces the professional, "no-nonsense" aesthetic and aligns with the flat UI style. The only exception to this rule is for iconography that requires organic shapes for recognition (e.g., a "user" icon), though even these should favor straight lines and 45/90-degree angles where possible.

## Components
Consistent styling across components is vital to maintaining the system's structural integrity.

- **Buttons:** Primary buttons use a solid Slate-Purple fill with off-white text. Secondary buttons use a 1px border with no fill. All buttons are rectangular with 0px radius.
- **Input Fields:** Backgrounds should be 1-step darker than their parent container to create an "inset" feel. Borders should be visible on all four sides, using the Secondary color for the "Focus" state.
- **Cards:** Cards do not use shadows. They are defined by a 1px border (#3F3F46) or a subtle tonal shift from the background.
- **Chips/Labels:** Use a background color that is only 5% different from the surface to keep them "quiet." Use `label-caps` typography for high-density information.
- **Checkboxes/Radios:** Square-only. Use the primary Slate-Purple for checked states to provide a clear, high-contrast visual cue against the Zinc background.