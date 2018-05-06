extends Label

signal dialogueClicked

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _on_dialogue_clicked():
#	print("clicked")
#	emit_signal("clicked")

func _on_dialogue_gui_input(ev):
	#debug function to make sure this function runs
	#self.set_text("clicking the dialogue window")
	
	if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT:
		#if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT and ev.is_pressed():
		emit_signal("dialogueClicked")


func _on_dialogue_mouse_entered():
	var debug_root = get_tree().get_root().get_node("Node")
	debug_root.get_node("ui/debug2").set_text("this is the dialogue window")


func _on_name_mouse_entered():
	var debug_root = get_tree().get_root().get_node("Node")
	debug_root.get_node("ui/debug2").set_text("this is the name label")
