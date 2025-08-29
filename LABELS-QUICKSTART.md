# Quick Label Setup Guide

## Using Labels in 3 Steps

### Step 1: Enable Labels
In `gridfinity-rebuilt-bins.scad`, change:
```openscad
enable_labels = true;
```

### Step 2: Add Your Text  
Set your label text (semicolon-separated for multiple compartments):
```openscad
label_text = "Screws;Nuts;Bolts;Parts";
```

### Step 3: Choose Style
Pick embossed (raised) or debossed (recessed) text:
```openscad
label_style = 1; // 1=embossed, 2=debossed
```

## That's It!
Your bin will now have labels on each compartment. The text size and font can be adjusted with additional parameters if needed.

## Advanced Usage
See `docs/labels.md` for complete documentation and `gridfinity-labels-example.scad` for more examples.

## Printable Labels
To create separate labels that can be printed and inserted:
1. Open `gridfinity-labels.scad`
2. Set `label_style = 0`
3. Customize text and dimensions
4. Print with thin layers (0.2mm recommended)