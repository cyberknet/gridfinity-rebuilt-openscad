// ===== GRIDFINITY LABELS EXAMPLE ===== //
/*
 Example file showing how to use the new label functionality
 This demonstrates various ways to add labels to gridfinity bins.
*/

include <src/core/standard.scad>
use <src/core/gridfinity-rebuilt-utility.scad>
use <src/core/gridfinity-rebuilt-holes.scad>

// Example 1: Simple 2x2 bin with embossed labels
// Render this by uncommenting:
/*
gridfinityInit(2, 2, height(3), 0) {
    cutEqual(n_divx = 2, n_divy = 2, style_tab = 1, 
             label_texts = "Screws;Nuts;Bolts;Parts", 
             label_style = 1,  // Embossed
             label_text_size = 2.5);
}
gridfinityBase([2, 2]);
*/

// Example 2: Using individual compartments with custom labels
gridfinityInit(3, 2, height(4), 0) {
    // Top row
    cut_with_label(0, 1, 1, 1, 1, 1, label_text="M3", label_style=1, label_text_size=3);
    cut_with_label(1, 1, 1, 1, 1, 1, label_text="M4", label_style=1, label_text_size=3);
    cut_with_label(2, 1, 1, 1, 1, 1, label_text="M5", label_style=1, label_text_size=3);
    
    // Bottom row - longer compartments
    cut_with_label(0, 0, 2, 1, 1, 1, label_text="TOOLS", label_style=1, label_text_size=2.5);
    cut_with_label(2, 0, 1, 1, 1, 1, label_text="MISC", label_style=1, label_text_size=2.5);
}
gridfinityBase([3, 2]);

// Example 3: Create printable labels (uncomment to render)
/*
// This creates separate label strips that can be printed and inserted
translate([100, 0, 0]) {
    gridfinity_label(text="M3 SCREWS", width=40, height=10, style=0);
    translate([0, 15, 0])
    gridfinity_label(text="M4 SCREWS", width=40, height=10, style=0); 
    translate([0, 30, 0])
    gridfinity_label(text="M5 SCREWS", width=40, height=10, style=0);
    translate([0, 45, 0])
    gridfinity_label(text="TOOLS", width=40, height=10, style=0);
}
*/