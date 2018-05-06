extends Area2D

onready var map01 = get_node("map01/Sprite")
onready var map02 = get_node("map02/Sprite")
onready var map03 = get_node("map03/Sprite")

onready var label = get_node("label")

signal exit_ui(a)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_map01_mouse_entered():
	map01.show()
	label.set_text("School yard")
	label.set_position(get_node("map01").get_position() + Vector2(-30, 45))
	global.blocking_ui = true

func _on_map01_mouse_exited():
	map01.hide()
	label.set_text("")
	
func _on_map01_gui_input( viewport, event, shape_idx ):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		emit_signal("exit_ui", "schoolyard")

func _on_map02_mouse_entered():
	map02.show()
	label.set_text("School hall")
	label.set_position(get_node("map02").get_position() + Vector2(-30, 45))
	global.blocking_ui = true

func _on_map02_mouse_exited():
	map02.hide()
	label.set_text("")

func _on_map02_gui_input( viewport, event, shape_idx ):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		emit_signal("exit_ui", "schoolhall")

func _on_map03_mouse_entered():
	map03.show()
	label.set_text("My room")
	label.set_position(get_node("map03").get_position() + Vector2(-30, 45))
	global.blocking_ui = true

func _on_map03_mouse_exited():
	map03.hide()
	label.set_text("")

func _on_map03_gui_input( viewport, event, shape_idx ):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		emit_signal("exit_ui", "myroom")













