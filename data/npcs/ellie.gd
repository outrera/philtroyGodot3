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
	if global.itemInHand == false:
		var cursor = load("res://data/graphics/cursor_talk.png")
		Input.set_custom_mouse_cursor(cursor)
	if global.itemInHand == false:
		emit_signal("highlight", identity)
	else:
		emit_signal("highlight", "Give to " + identity + "?")

func _on_npc_trigger_mouse_exit():
	if global.itemInHand == false:
		var cursor = load("res://data/graphics/cursor_default.png")
		Input.set_custom_mouse_cursor(cursor)
	emit_signal("highlight", "")
	emit_signal("look_at", "")

func _on_npc_trigger_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			emit_signal("dialogue", identity, self.get_transform().origin)
			
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if event.is_pressed():
			emit_signal("look_at", "That´s Ellie. She´s cute!")
