// ===== INFORMATION ===== //
/*
 GRIDFINITY LABELS
 
 This module provides functionality for creating labels that can be:
 1. Printed separately and inserted into existing tabs
 2. Embossed directly into bin tabs during printing
 3. Customized with different fonts, sizes, and styles
 
 Labels are designed to fit the existing gridfinity tab system.
 Default tab dimensions: 15.85mm height, up to 42mm width, 36° angle
 
 https://github.com/kennetek/gridfinity-rebuilt-openscad
*/

include <src/core/standard.scad>
use <src/core/gridfinity-rebuilt-utility.scad>

// ===== PARAMETERS ===== //

/* [Label Settings] */
// Text to display on the label
label_text = "Sample";
// Font to use for the label text
label_font = "Liberation Sans:style=Bold";
// Height of the text in mm
text_height = 3; // .1
// Depth of embossed/debossed text in mm
text_depth = 0.6; // .1
// Label style
label_style = 0; // [0:Separate Printable Label, 1:Embossed (raised text), 2:Debossed (recessed text)]

/* [Label Dimensions] */
// Width of the label in mm (auto-calculated if 0)
label_width = 0; // .1  
// Height of the label in mm
label_height = 10; // .1
// Thickness of printable label in mm
label_thickness = 1.2; // .1
// Corner radius for label
label_corner_radius = 1; // .1

/* [Tab Integration] */
// Tab style this label is designed for
target_tab_style = 1; // [0:Full,1:Auto,2:Left,3:Center,4:Right,5:None]
// Width of the target tab this label fits
target_tab_width = 42; // .1

// ===== IMPLEMENTATION ===== //

/**
 * @brief Creates a printable label that fits into gridfinity tabs
 * @param text Text to display on the label
 * @param font Font family and style
 * @param text_height Height of the text in mm
 * @param text_depth Depth of the text (for raised/recessed effects)
 * @param width Width of label (auto-calculated if 0)
 * @param height Height of label
 * @param thickness Thickness of label
 * @param corner_radius Radius for rounded corners
 * @param style 0=separate printable, 1=embossed, 2=debossed
 */
module gridfinity_label(
    text = "Label",
    font = "Liberation Sans:style=Bold", 
    text_height = 3,
    text_depth = 0.6,
    width = 0,
    height = 10,
    thickness = 1.2,
    corner_radius = 1,
    style = 0
) {
    
    // Calculate text dimensions
    text_size = textmetrics(text, size=text_height, font=font);
    calculated_width = max(text_size[0] + 4, 10); // Add 4mm padding, minimum 10mm
    actual_width = width > 0 ? width : calculated_width;
    
    if (style == 0) {
        // Separate printable label
        create_printable_label(text, font, text_height, text_depth, actual_width, height, thickness, corner_radius);
    } else if (style == 1) {
        // Embossed text (raised)
        create_embossed_text(text, font, text_height, text_depth, actual_width, height);
    } else if (style == 2) {
        // Debossed text (recessed)
        create_debossed_text(text, font, text_height, text_depth, actual_width, height);
    }
}

/**
 * @brief Creates a printable label with text
 */
module create_printable_label(text, font, text_height, text_depth, width, height, thickness, corner_radius) {
    difference() {
        // Label base
        linear_extrude(height = thickness)
        offset(r = corner_radius)
        offset(r = -corner_radius)
        square([width, height], center = true);
        
        // Text cutout/emboss
        translate([0, 0, thickness - text_depth])
        linear_extrude(height = text_depth + 0.1)
        text(text, size = text_height, font = font, halign = "center", valign = "center");
    }
}

/**
 * @brief Creates embossed (raised) text for direct integration
 */
module create_embossed_text(text, font, text_height, text_depth, width, height) {
    linear_extrude(height = text_depth)
    text(text, size = text_height, font = font, halign = "center", valign = "center");
}

/**
 * @brief Creates debossed (recessed) text for direct integration
 */  
module create_debossed_text(text, font, text_height, text_depth, width, height) {
    translate([0, 0, -text_depth])
    linear_extrude(height = text_depth + 0.1)
    text(text, size = text_height, font = font, halign = "center", valign = "center");
}

/**
 * @brief Enhanced cut module with integrated labeling
 * @param x X position of compartment
 * @param y Y position of compartment  
 * @param w Width of compartment
 * @param h Height of compartment
 * @param t Tab style
 * @param s Scoop toggle
 * @param tab_width Tab width
 * @param tab_height Tab height
 * @param label_text Text for the label (empty = no label)
 * @param label_style 0=none, 1=embossed, 2=debossed
 */
module cut_with_label(x=0, y=0, w=1, h=1, t=1, s=1, tab_width=d_tabw, tab_height=d_tabh, 
                      label_text="", label_style=0, label_font="Liberation Sans:style=Bold", 
                      label_text_height=3, label_text_depth=0.6) {
    
    // Create the normal compartment cut
    cut(x, y, w, h, t, s, tab_width, tab_height);
    
    // Add label if text is provided and style is not 0
    if (label_text != "" && label_style > 0) {
        // Position the label on the tab
        // This is a simplified positioning - would need more complex geometry for perfect placement
        translate([x*42 + w*42/2, y*42 + h*42, $dh + BASE_HEIGHT + h_bot - label_text_depth])
        gridfinity_label(
            text = label_text,
            font = label_font,
            text_height = label_text_height, 
            text_depth = label_text_depth,
            width = min(tab_width, w*42-4),
            height = 8,
            style = label_style
        );
    }
}

/**
 * @brief Create a sheet of labels for printing
 * @param labels Array of label texts
 * @param cols Number of columns
 * @param spacing Spacing between labels
 */
module label_sheet(labels=["Label1", "Label2", "Label3"], cols=3, spacing=45) {
    for (i = [0:len(labels)-1]) {
        translate([(i % cols) * spacing, floor(i / cols) * spacing, 0])
        gridfinity_label(
            text = labels[i],
            style = 0
        );
    }
}

// ===== MAIN EXECUTION ===== //

// Generate based on current parameters
if (label_style == 0) {
    gridfinity_label(
        text = label_text,
        font = label_font,
        text_height = text_height,
        text_depth = text_depth, 
        width = label_width,
        height = label_height,
        thickness = label_thickness,
        corner_radius = label_corner_radius,
        style = label_style
    );
} else {
    // For embossed/debossed, show with a sample bin
    gridfinityInit(2, 1, height(3), 0) {
        cut_with_label(
            x=0, y=0, w=1, h=1, t=target_tab_style, s=1,
            label_text = label_text,
            label_style = label_style,
            label_font = label_font,
            label_text_height = text_height,
            label_text_depth = text_depth
        );
        cut_with_label(
            x=1, y=0, w=1, h=1, t=target_tab_style, s=1,
            label_text = "Test2",
            label_style = label_style, 
            label_font = label_font,
            label_text_height = text_height,
            label_text_depth = text_depth
        );
    }
    gridfinityBase([2, 1]);
}

// ===== EXAMPLES ===== //

// Example 1: Create a sheet of printable labels
/*
label_sheet([
    "Screws",
    "Bolts", 
    "Nuts",
    "Washers",
    "Tools",
    "Parts"
], cols=3, spacing=50);
*/

// Example 2: Bin with embossed labels
/*
gridfinityInit(3, 2, height(4), 0) {
    cut_with_label(0, 0, 1, 1, 1, 1, label_text="Screws", label_style=1);
    cut_with_label(1, 0, 1, 1, 1, 1, label_text="Nuts", label_style=1);
    cut_with_label(2, 0, 1, 1, 1, 1, label_text="Bolts", label_style=1);
    cut_with_label(0, 1, 2, 1, 1, 1, label_text="Long Tools", label_style=1);
    cut_with_label(2, 1, 1, 1, 1, 1, label_text="Parts", label_style=1);
}
gridfinityBase([3, 2]);
*/