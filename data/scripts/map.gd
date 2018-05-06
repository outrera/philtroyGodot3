extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	print("init map")

func _on_map01_mouse_entered():
	print("map01 entered")


func _on_map01_mouse_exited():
	print("map01 exited")
