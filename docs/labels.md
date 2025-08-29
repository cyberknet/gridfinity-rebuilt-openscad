# Gridfinity Labels

This document describes the new labeling functionality added to the Gridfinity Rebuilt OpenSCAD project.

## Overview

The labeling system allows you to add text labels to gridfinity bins in three ways:

1. **Separate Printable Labels** - Print labels separately and insert them into tab slots
2. **Embossed Labels** - Text raised from the surface, integrated during bin printing
3. **Debossed Labels** - Text recessed into the surface, integrated during bin printing

## Quick Start

### Using the Main Bins Module

The main `gridfinity-rebuilt-bins.scad` now includes label parameters:

```openscad
// Enable labels
enable_labels = true;
// Set label text (semicolon separated for multiple compartments) 
label_text = "Screws;Nuts;Bolts;Parts";
// Choose label style: 1=embossed, 2=debossed
label_style = 1;
// Set text size
label_text_size = 3;
```

### Using Individual Compartment Labels

```openscad
gridfinityInit(2, 2, height(4), 0) {
    cut_with_label(0, 0, 1, 1, 1, 1, label_text="M3", label_style=1);
    cut_with_label(1, 0, 1, 1, 1, 1, label_text="M4", label_style=1);
    cut_with_label(0, 1, 1, 1, 1, 1, label_text="M5", label_style=1);
    cut_with_label(1, 1, 1, 1, 1, 1, label_text="MISC", label_style=1);
}
gridfinityBase([2, 2]);
```

### Creating Separate Printable Labels

```openscad
// Include the labels module
include <gridfinity-labels.scad>

// Create individual labels
gridfinity_label(text="SCREWS", width=40, height=10, style=0);
```

## Parameters

### Main Bins Module Parameters

| Parameter | Range | Description |
|-----------|-------|-------------|
| `enable_labels` | boolean | Enable the label system |
| `label_text` | string | Text for labels (semicolon separated for multiple) |
| `label_style` | {1,2} | 1=embossed, 2=debossed |
| `label_font` | string | Font family and style |
| `label_text_size` | n>0 | Height of label text in mm |
| `label_text_depth` | n>0 | Depth of label text in mm |

### Cut with Label Function

**`cut_with_label(x, y, w, h, t, s, tab_width, tab_height, label_text, label_style, label_font, label_text_size, label_text_depth)`**

| Parameter | Description |
|-----------|-------------|
| `x,y,w,h,t,s` | Same as standard `cut()` function |
| `tab_width`, `tab_height` | Tab dimensions |
| `label_text` | Text to display on the label |
| `label_style` | 1=embossed, 2=debossed |
| `label_font` | Font for the text |
| `label_text_size` | Text height in mm |
| `label_text_depth` | Text depth in mm |

### Gridfinity Label Function

**`gridfinity_label(text, font, text_height, text_depth, width, height, thickness, corner_radius, style)`**

| Parameter | Default | Description |
|-----------|---------|-------------|
| `text` | "Label" | Text to display |
| `font` | "Liberation Sans:style=Bold" | Font family |
| `text_height` | 3 | Text size in mm |
| `text_depth` | 0.6 | Text depth/emboss in mm |
| `width` | 0 | Label width (auto if 0) |
| `height` | 10 | Label height in mm |
| `thickness` | 1.2 | Label thickness in mm |
| `corner_radius` | 1 | Corner rounding radius |
| `style` | 0 | 0=printable, 1=embossed, 2=debossed |

## Examples

See `gridfinity-labels-example.scad` for complete working examples.

### Example 1: Basic Compartment Labeling

```openscad
gridfinityInit(2, 1, height(3), 0) {
    cutEqual(n_divx = 2, n_divy = 1, style_tab = 1, 
             label_texts = "TOOLS;PARTS", 
             label_style = 1);
}
gridfinityBase([2, 1]);
```

### Example 2: Mixed Label Sizes

```openscad
gridfinityInit(3, 2, height(4), 0) {
    // Small compartments with smaller text
    cut_with_label(0, 0, 1, 1, 1, 1, label_text="M3", label_text_size=2);
    cut_with_label(1, 0, 1, 1, 1, 1, label_text="M4", label_text_size=2);
    
    // Larger compartment with larger text
    cut_with_label(0, 1, 3, 1, 1, 1, label_text="LONG TOOLS", label_text_size=3);
}
gridfinityBase([3, 2]);
```

### Example 3: Printable Label Sheet

```openscad
labels = ["M3", "M4", "M5", "M6", "M8", "M10"];
for (i = [0:len(labels)-1]) {
    translate([0, i * 15, 0])
    gridfinity_label(text=labels[i], width=30, height=12, style=0);
}
```

## Design Considerations

### Text Sizing
- Default text size is 3mm, suitable for most applications
- For narrow bins, use smaller text (2-2.5mm) to fit properly
- Text depth of 0.6mm provides good visibility without weak features

### Font Selection
- Default font "Liberation Sans:style=Bold" is widely available
- Other system fonts can be used: "Arial", "Times New Roman", etc.
- Bold fonts are recommended for better printability

### Label Positioning
- Labels are positioned on the front face of tabs
- Text is centered horizontally and vertically
- Automatic positioning works with all tab styles (0-4)

### Printing Tips
- **Embossed labels**: Ensure your printer can handle small raised features
- **Debossed labels**: May collect dust/debris over time  
- **Separate labels**: Print with 0.2mm layer height for smooth text
- **Separate labels**: Consider printing in contrasting colors

## Compatibility

- Works with all existing gridfinity tab styles (0-4)
- Compatible with all compartment types (equal divisions, custom cuts)
- Does not affect existing functionality when labels are disabled
- Tab geometry remains unchanged - existing label tape still fits

## Limitations

- Text positioning is simplified and may not be perfect for all tab orientations
- Very long text may exceed tab boundaries
- Complex fonts may not print well at small sizes
- Requires OpenSCAD with text rendering support