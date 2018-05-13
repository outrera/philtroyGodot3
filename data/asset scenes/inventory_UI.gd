extends Area2D

var tab = null

var inventoryData

var tabTexTools = preload("res://data/graphics/inventory_tab_tools.png")
var tabTexGifts = preload("res://data/graphics/inventory_tab_gifts.png")
var tabTexMisc = preload("res://data/graphics/inventory_tab_misc.png")
var tabTexJunk = preload("res://data/graphics/inventory_tab_junk.png")

func _ready():
	inventoryData = global.inventoryData.tools

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input(event):
	if tab != null:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
			if tab == "tools":
				$container/panel/tabs/tex_tab.set_texture(tabTexTools)
				inventoryData = global.inventoryData.tools
			if tab == "gifts":
				$container/panel/tabs/tex_tab.set_texture(tabTexGifts)
				inventoryData = global.inventoryData.gifts
			if tab == "misc":
				$container/panel/tabs/tex_tab.set_texture(tabTexMisc)
				inventoryData = global.inventoryData.misc
			if tab == "junk":
				$container/panel/tabs/tex_tab.set_texture(tabTexJunk)
				inventoryData = global.inventoryData.junk

func _on_tools_mouse_entered():
	$container/panel/debug.set_text("tools")
	tab = "tools"
	
func _on_tools_mouse_exited():
	tab = null

func _on_tools_input_event(body):
	pass # replace with function body

func _on_gifts_mouse_entered():
	$container/panel/debug.set_text("gifts")
	tab = "gifts"

func _on_gifts_mouse_exited():
	$container/panel/debug.set_text("")
	tab = null

func _on_gifts_input_event(camera, event, click_position, click_normal, shape_idx):
	print("gifts clicked")

func _on_misc_mouse_entered():
	$container/panel/debug.set_text("misc")
	tab = "misc"

func _on_misc_mouse_exited():
	$container/panel/debug.set_text("")
	tab = null

func _on_junk_mouse_entered():
	$container/panel/debug.set_text("junk")
	tab = "junk"

func _on_junk_mouse_exited(area):
	$container/panel/debug.set_text("")
	tab = null

func _on_junk_input_event():
	pass # replace with function body
