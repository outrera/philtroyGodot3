extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here.
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func icon_fx(node, scale):
	$fx.interpolate_property (node, "scale", node.scale, scale, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$fx.start()

func _on_phone_mouse_entered():
	icon_fx($homescreen/phone, Vector2(0.9, 0.9))


func _on_phone_mouse_exited():
	icon_fx($homescreen/phone, Vector2(1, 1))

func _on_phone_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				$ui_phone.show()


func _on_mail_mouse_entered():
	icon_fx($homescreen/mail, Vector2(0.9, 0.9))


func _on_mail_mouse_exited():
	icon_fx($homescreen/mail, Vector2(1, 1))


func _on_mail_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				$ui_phone.show()


func _on_internet_mouse_entered():
	icon_fx($homescreen/internet, Vector2(0.9, 0.9))


func _on_internet_mouse_exited():
	icon_fx($homescreen/internet, Vector2(1, 1))


func _on_internet_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				$ui_internet.show()


func _on_archive_mouse_entered():
	icon_fx($homescreen/archive, Vector2(0.9, 0.9))


func _on_archive_mouse_exited():
	icon_fx($homescreen/archive, Vector2(1, 1))


func _on_archive_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				$ui_archive.show()


func _on_calendar_mouse_entered():
	icon_fx($homescreen/calendar, Vector2(0.9, 0.9))


func _on_calendar_mouse_exited():
	icon_fx($homescreen/calendar, Vector2(1, 1))


func _on_calendar_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				$ui_calendar.show()


func _on_games_mouse_entered():
	icon_fx($homescreen/games, Vector2(0.9, 0.9))


func _on_games_mouse_exited():
	icon_fx($homescreen/games, Vector2(1, 1))


func _on_games_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				$ui_games.show()
