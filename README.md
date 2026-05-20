
I wrote the code, AI wrote this readme, because ain't no one got time for documentation



# SCAD Airflow Meter

An OpenSCAD parametric model for designing a custom airflow meter joining two cylinders together. This project provides a flexible design with multiple configuration options for 3D printing.

## Overview

This model creates a joining collar that connects:
- A **box part** with a flat surface for mounting
- A **cylinder part** for airflow measurement
- A **joining ring** for modular assembly (optional)

The design features threaded inserts for secure assembly and can be configured as a single piece or modular two-piece design.

## Configuration Options

The model supports three different part types:

1. **Single Piece** - Fully integrated design in one print
2. **Two Piece Base** - Main housing component
3. **Two Piece Ring** - Modular joining collar

### Key Parameters

- **Box dimensions**: 250mm × 250mm × 50mm (adjustable)
- **Cylinder diameter**: 190mm (adjustable)
- **Internal tube diameter**: 195mm box / 170mm cylinder (customizable)
- **Join length**: 10mm (tunable)
- **Fasteners**: M6 threaded heat inserts with grub screws

## Design Variations

### Single Piece
A unified design suitable for smaller prints or less demanding applications.

![Single Piece](single%20piece.png)

### Two Piece with Joining Collar
A modular design with a separate ring collar for bolted assembly, allowing easier maintenance and adjustments.

![Two Piece with Joining Collar](two%20piece%20with%20joining%20collar.png)

### Two Piece Joining Collar Only
The standalone collar component for tube-side installation.

![Two Piece Joining Collar](2%20piece%20just%20the%20joining%20collar%20for%20tube%20side.png)

## Requirements

- **OpenSCAD** - Download from [openscad.org](https://openscad.org/)
- 3D printer capable of printing the model at desired scale
- M6 threaded heat inserts (for grub screw fastening)
- M6 grub screws (for assembly)

## Usage

1. Open `airflow_meter_join.scad` in OpenSCAD
2. Adjust parameters in the "Customizer" panel:
   - Select desired `part_type` configuration
   - Modify internal/external dimensions as needed
   - Adjust the internal cylinder diameters to fit your tube size
3. Preview the model with `F5` or render with `F6`
4. Export to STL format: `Design > Export as STL...`
5. Prepare for 3D printing using your preferred slicer software

## Customization

Key parameters to modify for your specific needs:

```scad
// Box dimensions
box_x = 250;     // Width in mm
box_y = 250;     // Depth in mm
box_z = 50;      // Height in mm

// Cylinder dimensions
cylinder_dia = 190;      // Diameter in mm
cylinder_z = 50;         // Height in mm

// Internal diameters (for tube fitting)
box_int_cyl_dia = 195;   // Box internal cylinder diameter
cyl_int_cyl_dia = 170;   // Cylinder internal diameter

// Join dimensions
box_to_cyl_join_z = 10;  // Join length in mm
```

## Assembly

For the two-piece design:

1. 3D print both components
2. Install M6 threaded heat inserts in the mounting holes
3. Align the base and collar
4. Secure with M6 grub screws
5. Tighten evenly for proper alignment

## Advanced Features

- **Model sectioning**: Preview internal features with `cut_model_in_half`
- **Print testing**: Use `cut_model_top_ring` and `cut_model_bottom_ring` for test prints
- **High precision**: Set resolution to `$fn = 1024` for smooth renders
- **Bolt configuration**: Modular ring features 4 bolt positions at 90° intervals

## License

Please specify your chosen license here (e.g., MIT, GPL, CC-BY).

## Contributing

Contributions are welcome! Please submit pull requests or open issues for suggestions and improvements.

## Author

Created for custom airflow measurement applications.
