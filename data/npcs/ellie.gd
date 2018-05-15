extends StaticBody

signal look_at(a)
signal highlight(a)
signal dialogue(a,b)

#will just carry character name, all other data will be moved to charData in global.gd
var identity = "ellie"
var branch = "a"

func _ready():
	pass
		
func _on_npc_trigger_mouse_enter():
	if global.itemInHand == false and global.blocking_ui!=true:
		var cursor = load("res://data/graphics/cursor_talk.png")
		Input.set_custom_mouse_cursor(cursor)
	if global.itemInHand == false:
		emit_signal("highlight", identity)
	else:
		emit_signal("highlight", "Give to " + identity + "?")

func _on_npc_trigger_mouse_exit():
	if global.itemInHand == false and global.blocking_ui!=true:
		var cursor = load("res://data/graphics/cursor_default.png")
		Input.set_custom_mouse_cursor(cursor)
	emit_signal("highlight", "")
	emit_signal("look_at", "")

func _on_npc_trigger_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		print(global.itemInHand)
		if event.is_pressed():
			if global.itemInHand == false:	
				emit_signal("dialogue", identity, self.get_transform().origin)
			else:
				var keys = global.inventoryData.keys()
				var cursor = load("res://data/graphics/cursor_default.png")
				Input.set_custom_mouse_cursor(cursor)
				global.inventoryData["junk"].remove(0)
				global.itemInHand = false
# TODO: This turned into a mess... too make my life easier, assign a number to every item for simpler iteration of items. Will need to change 
# other code calling items oc...
#				for key in keys:
#					var keySize = global.inventoryData[key].size()
#					for size in range(keySize):
#						print(size)
#						if global.inventoryData[key][size]["id"] == "shoe":
#							global.inventoryData[key].remove(size)
#							print(key)
#							print("shoe")
#						else:
#							print("no shoe")
		
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if event.is_pressed():
			emit_signal("look_at", "That´s Ellie. She´s cute!")
