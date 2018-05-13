extends Area2D

var tab = null

var inventoryData
var tab_tab = 1

var tabTexTools = preload("res://data/graphics/inventory_tab_tools.png")
var tabTexGifts = preload("res://data/graphics/inventory_tab_gifts.png")
var tabTexMisc = preload("res://data/graphics/inventory_tab_misc.png")
var tabTexJunk = preload("res://data/graphics/inventory_tab_junk.png")

var inv_rose = preload("res://data/graphics/inv_rose.png")
var inv_shoe = preload("res://data/graphics/inv_shoe.png")
var inv_wrench = preload("res://data/graphics/inv_wrench.png")
var inv_ticket = preload("res://data/graphics/inv_ticket.png")

var inventory_node = preload("res://data/asset scenes/inventory_node.tscn")

func _ready():
#	inventoryData = global.inventoryData.tools
	pop_inventory()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func pop_inventory():
	if !global.inventoryData.junk.empty():
		print("Cool! It´s not empty. I could find " + str(global.inventoryData.junk.size()) + " items here.")
		
		for item in $inventory_items.get_children():
			item.queue_free()
			item.set_name("deleted")
		
		if tab_tab == 1:
			var row = 0
			var rtrn = 0
			for i in range(global.inventoryData.tools.size()):
				if i == 5 or i == 10 or i == 15 or i == 20 or i == 25 or i == 30:
					row += 64
					rtrn += 350
				var node = inventory_node.instance()
				node.set_name(global.inventoryData.tools[i].id)
				node.set_position(Vector2(160 + i*70 - rtrn, 260 + row))
				$inventory_items.add_child(node)
				var image = load("res://data/graphics/inv_" + global.inventoryData.tools[i].id + ".png")
				$inventory_items.get_node(global.inventoryData.tools[i].id).set_texture(image)
		elif tab_tab == 2:
			var row = 0
			var rtrn = 0
			for i in range(global.inventoryData.gifts.size()):
				if i == 5 or i == 10 or i == 15 or i == 20 or i == 25 or i == 30:
					row += 64
					rtrn += 350
				var node = inventory_node.instance()
				node.set_name(global.inventoryData.gifts[i].id)
				node.set_position(Vector2(160 + i*70 - rtrn, 260 + row))
				$inventory_items.add_child(node)
				var image = load("res://data/graphics/inv_" + global.inventoryData.gifts[i].id + ".png")
				$inventory_items.get_node(global.inventoryData.gifts[i].id).set_texture(image)
		elif tab_tab == 3:
			var row = 0
			var rtrn = 0
			for i in range(global.inventoryData.misc.size()):
				if i == 5 or i == 10 or i == 15 or i == 20 or i == 25 or i == 30:
					row += 64
					rtrn += 350		
				var node = inventory_node.instance()
				node.set_name(global.inventoryData.misc[i].id)
				node.set_position(Vector2(160 + i*70 - rtrn, 260 + row))
				$inventory_items.add_child(node)
				var image = load("res://data/graphics/inv_" + global.inventoryData.misc[i].id + ".png")
				$inventory_items.get_node(global.inventoryData.misc[i].id).set_texture(image)
		elif tab_tab == 4:
			var row = 0
			var rtrn = 0
			for i in range(global.inventoryData.junk.size()):
				if i == 5 or i == 10 or i == 15 or i == 20 or i == 25 or i == 30:
					row += 64
					rtrn += 350
				var node = inventory_node.instance()
				node.set_name(global.inventoryData.junk[i].id)
				node.set_position(Vector2(160 + i*70 - rtrn, 260 + row))
				$inventory_items.add_child(node)
				var image = load("res://data/graphics/inv_" + global.inventoryData.junk[i].id + ".png")
				$inventory_items.get_node(global.inventoryData.junk[i].id).set_texture(image)
	else:
		print("Damn! It´s empty..")

func _input(event):
	if tab != null:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
			if tab == "tools":
				$container/panel/tabs/tex_tab.set_texture(tabTexTools)
				tab_tab = 1
				pop_inventory()
			elif tab == "gifts":
				$container/panel/tabs/tex_tab.set_texture(tabTexGifts)
				tab_tab = 2
				pop_inventory()
			elif tab == "misc":
				$container/panel/tabs/tex_tab.set_texture(tabTexMisc)
				tab_tab = 3
				pop_inventory()
			elif tab == "junk":
				$container/panel/tabs/tex_tab.set_texture(tabTexJunk)
				tab_tab = 4
				pop_inventory()

	if event.is_action_pressed("ui_focus_next"):
		if tab_tab != 4:
			tab_tab += 1
		else:
			tab_tab = 1
			
		if tab_tab == 1:
			$container/panel/tabs/tex_tab.set_texture(tabTexTools)
		if tab_tab == 2:
			$container/panel/tabs/tex_tab.set_texture(tabTexGifts)
		if tab_tab == 3:
			$container/panel/tabs/tex_tab.set_texture(tabTexMisc)
		if tab_tab == 4:
			$container/panel/tabs/tex_tab.set_texture(tabTexJunk)
			
		pop_inventory()

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
