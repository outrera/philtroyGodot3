extends StaticBody

signal look_at(a)
signal dialogue(a,b)

#will just carry character name, all other data will be moved to charData in global.gd
var identity = "ellie"
var branch = "a"

func _ready():
	pass
	
func _on_npc_trigger_mouse_enter():
	#debug function to make sure this function runs
	var debug_root = get_tree().get_root().get_node("Node")
	debug_root.get_node("ui/debug").set_text("on ellie")
	
	emit_signal("look_at", identity)

func _on_npc_trigger_mouse_exit():
	#debug function to make sure this function runs
	var debug_root = get_tree().get_root().get_node("Node")
	debug_root.get_node("ui/debug").set_text("off ellie")
	
	emit_signal("look_at", "")

func _on_npc_trigger_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.is_pressed():
			#debug function to make sure this function runs
			var debug_root = get_tree().get_root().get_node("Node")
			debug_root.get_node("ui/debug2").set_text("talk to ellie")
			
			emit_signal("dialogue", identity, self.get_transform().origin)
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT:
		if event.is_pressed():
			#debug function to make sure this function runs
			var debug_root = get_tree().get_root().get_node("Node")
			debug_root.get_node("ui/debug2").set_text("look at ellie")
			
			emit_signal("look_at", "This is Ellie")
