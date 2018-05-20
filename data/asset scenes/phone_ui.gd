extends Area2D

var folder = []
var gallery = []
var gallery_thumbs = []
var gallery_page = 1

func _ready():
	folder = global.list_files_in_directory("res://data/graphics/gallery/")
#	print(gallery)
	for item in folder:
		if "thumb" in item:
			gallery_thumbs.push_back(item)
		else:
			gallery.push_back(item)

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
		var node = "apps/ui_archive/Sprite"
		var i = 1
		var slot = 1
		for thumb in gallery_thumbs:
			#Assign thumb textures corresponding to gallery page. If page is 3, assign textures in gallery_thumbs[13] to[18] 
			if i < gallery_page * 6 +1 and i > gallery_page * 6 - 6:
				var image = load("res://data/graphics/gallery/" + thumb)
				get_node(node + str(slot)).set_texture(image)
				slot += 1
			i = i+1
		
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
	icon_fx($homescreen/archive, Vector2(0.9, 0.9))

func _on_archive_mouse_exited():
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
