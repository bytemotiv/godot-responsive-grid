extends Container

class_name CSSGridContainer

# Rows, Cols and Areas in CSS Syntax
# Valid Units: 200px, 1fr, 25%
export(Array, int) var minWidths

export(Array, PoolStringArray) var rows
export(Array, PoolStringArray) var cols
export(Array, PoolStringArray) var areas

# Arrays of right-/bottommost region borders in pixesl 
var rowPixels:PoolIntArray
var colPixels:PoolIntArray

# Amount in pixels for 1 fraction unit of a row/column
var rowFraction
var colFraction

var areaRects = {}
var subgrid:int = 0

func getBreakpoint():
	var width = get_viewport_rect().size.x
	var counter:int = 0
	for w in minWidths:
		if w <= width:
			subgrid = counter
			counter += 1
		else:
			break	
	print(subgrid)	
	
	
# Calculate the size of a fr-unit for width and height
func calculateFractions():
	var width = get_viewport_rect().size.x
	var height = get_viewport_rect().size.y

	var fraction = RegEx.new()
	fraction.compile("(\\d+)fr")

	var rowFractions:int = 0
	var colFractions:int = 0

	for row in rows[subgrid]:
		var result = fraction.search(row)
		if result:
			rowFractions += int(result.get_string(1))
	
	for col in cols[subgrid]:
		var result = fraction.search(col)
		if result:
			colFractions += int(result.get_string(1))
	
	rowFraction = height / rowFractions
	colFraction = width / colFractions


# Calculates pixel offsets for the regions
func calculatePixels():
	rowPixels.resize(0)
	colPixels.resize(0)
	
	rowPixels.append(0)
	colPixels.append(0)
	
	var fraction = RegEx.new()
	fraction.compile("(\\d+)fr")
	
	var currentRowPixel = 0
	for row in rows[subgrid]:
		var result = fraction.search(row)
		if result:
			var units = int(result.get_string(1))
			currentRowPixel += units*rowFraction
			rowPixels.append(currentRowPixel)

	var currentColPixel = 0
	for col in cols[subgrid]:
		var result = fraction.search(col)
		if result:
			var units = int(result.get_string(1))
			currentColPixel += units*colFraction
			colPixels.append(currentColPixel)
	

func calculateAreas():
	areaRects.clear()
	
	var areaCount = len(rows[subgrid]) * len(cols[subgrid])
	if areaCount != len(areas[subgrid]):
		print("ERROR: Area count does not match!")

	var col = 0
	var row = 0
	for area in areas[subgrid]:		
		var x = colPixels[col]
		var y = rowPixels[row]
		var width = colPixels[col+1] - x 
		var height = rowPixels[row+1] - y
		var rect = Rect2(x, y, width, height)		
		
		if area in areaRects:
			var existingRect = areaRects[area]
			var rectX = existingRect.position.x
			var rectY = existingRect.position.y
			var rectW = existingRect.size.x
			var rectH = existingRect.size.y
			
			rectW += rect.size.x
			# FIX: calculation doesn't seem to be correct yet
			#if rect.size.x == existingRect.size.x:		
			#	rectH += rect.size.y
			#else:				
			#	rectW += rect.size.x
				
			var updatedRect = Rect2(rectX, rectY, rectW, rectH)

			rect = updatedRect
		areaRects[area] = rect

		col += 1		
		
		if col >= len(cols[subgrid]):
			col = 0
			row += 1
		
			
func calculateGrid():
	getBreakpoint()
	calculateFractions()
	calculatePixels()
	calculateAreas()
	
	for child in get_children():
		if child.area in areas[subgrid]:	
			child.visible = true
			var area = areaRects[child.area]
			if child.area == "bottom":
				print(area)
			fit_child_in_rect(child, area)
		else:
			child.visible = false
	
func _ready():
	calculateGrid()
	get_tree().get_root().connect("size_changed", self, "calculateGrid")

	# https://docs.godotengine.org/en/3.1/tutorials/gui/gui_containers.html	
func _notification(what):
	if (what==NOTIFICATION_SORT_CHILDREN):
		calculateGrid()

func set_some_setting():
	queue_sort()			
