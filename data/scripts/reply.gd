extends Label

var num_reply = 0 #this is set to another number in world.gd, when the label is instanced, to identify the reply for when you pick it later
signal reply_selected(a)
signal reply_mouseover(a,b)

var dumb_godot = 0

func _ready():
	pass

func _on_reply_mouse_entered():
	add_color_override("font_color", Color(1,0,1))
	emit_signal("reply_mouseover","TRUE",num_reply)
	#var debug_root = get_tree().get_root().get_node("Node")
	#debug_root.get_node("ui/debug2").set_text("enter reply")


func _on_reply_mouse_exited():
	add_color_override("font_color", Color(1,1,1))
	emit_signal("reply_mouseover","FALSE",num_reply)
	#var debug_root = get_tree().get_root().get_node("Node")
	#debug_root.get_node("ui/debug2").set_text("exit reply")


func _on_reply_gui_input(ev):
	if ev is InputEventMouseButton:
		if ev.button_index == BUTTON_LEFT and ev.is_pressed():
			emit_signal("reply_selected",num_reply)
		else:
			pass
