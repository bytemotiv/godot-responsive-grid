# godot-responsive-grid
A responsive grid for the Godot engine, based on CSS Grid

For the moment the grid only takes fr-units (fractions of the whole screen) as units.
The plan is to implement px and % units as well.

## Example

![Grid Demo](https://github.com/bytemotiv/godot-responsive-grid/blob/master/grid-demo.gif)

**Breakpoints / Min. Widths:**
- 480
- 1024
- 1280

**Rows:**
- 1fr | 1fr | 1fr
- 1fr | 1fr
- 2fr | 1fr

**Columns:**
- 1fr
- 1fr | 1fr | 1fr
- 2fr | 1fr | 2fr

**Areas**
- left | center | bottom
- left | center | right | bottom | bottom | bottom
- left | center | right | bottom | bottom | bottom
