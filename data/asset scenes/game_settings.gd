extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pop_game_settings()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func save_fx(save, opacity):
	$fx.interpolate_property(save, "modulate", save.modulate, opacity, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$fx.start()
	
func pop_game_settings():
	for save in range(global.saveData.size()):
		var image = load("res://data/graphics/saves/save" + str(save+1) + ".png")
		get_node("savegames/save" + str(save+1)).set_texture(image)

func _on_save1_mouse_entered():
	save_fx($savegames/save1, Color(1,1,1,1))

func _on_save1_mouse_exited():
	save_fx($savegames/save1, Color(1,1,1,0.5))


func _on_save1_input_event():
	pass # replace with function body


func _on_save2_mouse_entered():
	save_fx($savegames/save2, Color(1,1,1,1))

func _on_save2_mouse_exited():
	save_fx($savegames/save2, Color(1,1,1,0.5))
	
func _on_save2_input_event():
	pass # replace with function body


func _on_save3_mouse_entered():
	save_fx($savegames/save3, Color(1,1,1,1))

func _on_save3_mouse_exited(area):
	save_fx($savegames/save3, Color(1,1,1,0.5))

func _on_save3_input_event(area):
	pass # replace with function body


func _on_save4_mouse_entered():
	save_fx($savegames/save4, Color(1,1,1,1))
	
func _on_save4_mouse_exited():
	save_fx($savegames/save4, Color(1,1,1,0.5))

func _on_save4_input_event():
	pass # replace with function body


func _on_save5_mouse_entered():
	save_fx($savegames/save5, Color(1,1,1,1))

func _on_save5_mouse_exited():
	save_fx($savegames/save5, Color(1,1,1,0.5))

func _on_save5_input_event():
	pass # replace with function body


func _on_save6_mouse_entered():
	save_fx($savegames/save6, Color(1,1,1,1))

func _on_save6_mouse_exited():
	save_fx($savegames/save6, Color(1,1,1,0.5))

func _on_save6_input_event():
	pass # replace with function body


func _on_load_mouse_entered():
	pass # replace with function body

func _on_load_mouse_exited():
	pass # replace with function body

func _on_load_input_event():
	pass # replace with function body


func _on_save_mouse_entered():
	pass # replace with function body

func _on_save_mouse_exited():
	pass # replace with function body

func _on_save_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				global.capture.resize(640,400,1)
				global.capture.save_png("res://data/graphics/saves/screenshot - thumb.png")


func _on_exit_mouse_entered():
	pass # replace with function body

func _on_exit_mouse_exited():
	pass # replace with function body

func _on_exit_input_event():
	pass # replace with function body


func _on_patreon_mouse_entered():
	pass # replace with function body

func _on_patreon_mouse_exited():
	pass # replace with function body

func _on_patreon_input_event():
	pass # replace with function body
