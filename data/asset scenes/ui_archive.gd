extends Panel

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func icon_fx(photo, scale):
	$fx.interpolate_property (photo, "scale", photo.scale, scale, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$fx.start()

func _on_sprite1_mouse_entered():
	icon_fx($Sprite1, Vector2(1.2, 1.2))

func _on_sprite1_mouse_exited():
	icon_fx($Sprite1, Vector2(1, 1))

func _on_sprite1_input_event():
	pass # replace with function body


func _on_sprite2_mouse_entered():
	icon_fx($Sprite2, Vector2(1.2, 1.2))

func _on_sprite2_mouse_exited():
	icon_fx($Sprite2, Vector2(1, 1))

func _on_sprite2_input_event():
	pass # replace with function body


func _on_sprite3_mouse_entered():
	icon_fx($Sprite3, Vector2(1.2, 1.2))

func _on_sprite3_mouse_exited():
	icon_fx($Sprite3, Vector2(1, 1))

func _on_sprite3_input_event():
	pass # replace with function body


func _on_sprite4_mouse_entered():
	icon_fx($Sprite4, Vector2(1.2, 1.2))

func _on_sprite4_mouse_exited():
	icon_fx($Sprite4, Vector2(1, 1))

func _on_sprite4_input_event():
	pass # replace with function body


func _on_sprite5_mouse_entered():
	icon_fx($Sprite5, Vector2(1.2, 1.2))

func _on_sprite5_mouse_exited():
	icon_fx($Sprite5, Vector2(1, 1))

func _on_sprite5_input_event():
	pass # replace with function body


func _on_sprite6_mouse_entered():
	icon_fx($Sprite6, Vector2(1.2, 1.2))

func _on_sprite6_mouse_exited():
	icon_fx($Sprite6, Vector2(1, 1))

func _on_sprite6_input_event():
	pass # replace with function body
