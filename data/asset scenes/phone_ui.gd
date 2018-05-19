extends Area2D

func _ready():
	pass

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_Q:
			if global.phone_app_running == true:
				if event.is_pressed():
					for app in $apps.get_children():
						app.hide()			
					global.phone_app_running = false

func icon_fx(node, scale):
	$fx.interpolate_property (node, "scale", node.scale, scale, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$fx.start()

func start_phone_app(app, event):
	if app == "phone":
		for contact in range(global.contactData.size()):
			var node = "apps/ui_phone/Label"
			get_node(node + str(contact+1)).set_text(global.contactData["c" + str(contact+1)])
			
	if app == "archive":
		for contact in range(global.archiveData.size()):
			var node = "apps/ui_archive/Sprite"
			var image = load("res://data/graphics/gallery/img0" + str(contact+1) + ".png")
			get_node(node + str(contact+1)).set_texture(image)
		
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				get_node("apps/ui_" + app).show()
				global.phone_app_running = true
				
func _on_phone_mouse_entered():
	icon_fx($homescreen/phone, Vector2(0.9, 0.9))

func _on_phone_mouse_exited():
	icon_fx($homescreen/phone, Vector2(1, 1))

func _on_phone_input_event(viewport, event, shape_idx):
	if event : start_phone_app("phone", event)


func _on_mail_mouse_entered():
	icon_fx($homescreen/mail, Vector2(0.9, 0.9))

func _on_mail_mouse_exited():
	icon_fx($homescreen/mail, Vector2(1, 1))

func _on_mail_input_event(viewport, event, shape_idx):
	if event : start_phone_app("mail", event)


func _on_internet_mouse_entered():
	icon_fx($homescreen/internet, Vector2(0.9, 0.9))

func _on_internet_mouse_exited():
	icon_fx($homescreen/internet, Vector2(1, 1))

func _on_internet_input_event(viewport, event, shape_idx):
	if event : start_phone_app("internet", event)


func _on_archive_mouse_entered():
	print("internet in")
	icon_fx($homescreen/archive, Vector2(0.9, 0.9))

func _on_archive_mouse_exited():
	print("internet out")
	icon_fx($homescreen/archive, Vector2(1, 1))

func _on_archive_input_event(viewport, event, shape_idx):
	if event : start_phone_app("archive", event)


func _on_calendar_mouse_entered():
	icon_fx($homescreen/calendar, Vector2(0.9, 0.9))

func _on_calendar_mouse_exited():
	icon_fx($homescreen/calendar, Vector2(1, 1))

func _on_calendar_input_event(viewport, event, shape_idx):
	if event : start_phone_app("calendar", event)


func _on_games_mouse_entered():
	icon_fx($homescreen/games, Vector2(0.9, 0.9))

func _on_games_mouse_exited():
	icon_fx($homescreen/games, Vector2(1, 1))

func _on_games_input_event(viewport, event, shape_idx):
	if event : start_phone_app("games", event)
