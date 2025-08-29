// ===== GRIDFINITY LABELS DEMONSTRATION ===== //
/*
 This demonstrates the new label functionality added to gridfinity bins.
 
 To see different modes:
 - Change `demo_mode` to switch between examples
 - Mode 1: Embossed labels on compartments
 - Mode 2: Separate printable labels
 - Mode 3: Mixed compartment sizes with labels
*/

include <src/core/standard.scad>
use <src/core/gridfinity-rebuilt-utility.scad>
use <src/core/gridfinity-rebuilt-holes.scad>

demo_mode = 1; // [1:Embossed Bin Labels, 2:Printable Labels, 3:Mixed Compartments]

if (demo_mode == 1) {
    // Demo 1: Simple bin with embossed labels
    echo("Rendering bin with embossed labels...");
    
    gridfinityInit(2, 2, height(3), 0) {
        cut_with_label(0, 0, 1, 1, 1, 1, label_text="M3", label_style=1, label_text_size=2.5);
        cut_with_label(1, 0, 1, 1, 1, 1, label_text="M4", label_style=1, label_text_size=2.5);
        cut_with_label(0, 1, 1, 1, 1, 1, label_text="M5", label_style=1, label_text_size=2.5);
        cut_with_label(1, 1, 1, 1, 1, 1, label_text="NUTS", label_style=1, label_text_size=2);
    }
    gridfinityBase([2, 2]);

} else if (demo_mode == 2) {
    // Demo 2: Printable labels only
    echo("Rendering printable labels...");
    
    // Create a set of labels for printing
    labels = ["SCREWS", "NUTS", "BOLTS", "WASHERS"];
    
    for (i = [0:len(labels)-1]) {
        translate([i * 45, 0, 0])
        gridfinity_label(
            text = labels[i],
            width = 40,
            height = 12,
            thickness = 1.2,
            style = 0
        );
    }

} else if (demo_mode == 3) {
    // Demo 3: Mixed compartment sizes  
    echo("Rendering mixed compartment bin...");
    
    gridfinityInit(3, 2, height(4), 0) {
        // Top row - small compartments
        cut_with_label(0, 1, 1, 1, 1, 1, label_text="M3", label_style=1, label_text_size=2);
        cut_with_label(1, 1, 1, 1, 1, 1, label_text="M4", label_style=1, label_text_size=2);
        cut_with_label(2, 1, 1, 1, 1, 1, label_text="M5", label_style=1, label_text_size=2);
        
        // Bottom row - mixed sizes
        cut_with_label(0, 0, 2, 1, 1, 1, label_text="TOOLS", label_style=1, label_text_size=3);
        cut_with_label(2, 0, 1, 1, 1, 1, label_text="MISC", label_style=1, label_text_size=2.5);
    }
    gridfinityBase([3, 2]);
}

echo("=== Label Demo Complete ===");
echo(str("Demo mode: ", demo_mode));
echo("The label system adds text directly to gridfinity bins!");
echo("- Style 1 = Embossed (raised) text");  
echo("- Style 2 = Debossed (recessed) text");
echo("- Style 0 = Separate printable labels");