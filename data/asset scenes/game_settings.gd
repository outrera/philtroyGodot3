extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pop_game_settings("init")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func save_fx(save, opacity):
	$fx.interpolate_property(save, "modulate", save.modulate, opacity, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$fx.start()
	
func pop_game_settings(key):
	for save in range(global.saveData.size()):
		var save_node = get_node("savegames/save" + str(save+1))

		var tmp = "save" + str(save+1)
		
#		print(global.saveData[tmp][0].thumb)
		
		if global.saveData[tmp][0].thumb == "save_add":
				var image = load("res://data/graphics/saves/save_add.png")
				save_node.set_texture(image)
		elif key == "init":
			var image = load("res://data/graphics/saves/save" + str(save+1) + ".png")
			save_node.set_texture(image)
			
func save_to_slot(id):
	var save_name = "save" + str(id)
	var texture = ImageTexture.new()
	
	if get_node("savegames/save" + str(id)).texture.get_path() == "res://data/graphics/saves/save_add.png":

		var tmpdict = [{			
				"id" : str(id+1),
				"thumb" : "save_add",
				"data" : []
			}]

		global.saveData["save" + str(id+1)] = tmpdict

	global.capture.resize(500,281,1)

	texture.create_from_image(global.capture)
	get_node("savegames/save" + str(id)).set_texture(texture)

	global.capture.save_png("res://data/graphics/saves/" + save_name + ".png")
	global.saveData["save" + str(id)][0].thumb = save_name

	pop_game_settings("refresh")
			
func _on_save1_mouse_entered():
	save_fx($savegames/save1, Color(1,1,1,1))

func _on_save1_mouse_exited():
	save_fx($savegames/save1, Color(1,1,1,0.5))


func _on_save1_input_event(viewport, event, shape_idx):
	if get_node("savegames/save1").texture:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				if event.is_pressed():
					save_to_slot(1)

func _on_save2_mouse_entered():
	save_fx($savegames/save2, Color(1,1,1,1))

func _on_save2_mouse_exited():
	save_fx($savegames/save2, Color(1,1,1,0.5))
	
func _on_save2_input_event(viewport, event, shape_idx):
	if get_node("savegames/save2").texture:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				if event.is_pressed():
					save_to_slot(2)


func _on_save3_mouse_entered():
	save_fx($savegames/save3, Color(1,1,1,1))

func _on_save3_mouse_exited():
	save_fx($savegames/save3, Color(1,1,1,0.5))

func _on_save3_input_event(viewport, event, shape_idx):
	if get_node("savegames/save3").texture:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				if event.is_pressed():
					save_to_slot(3)


func _on_save4_mouse_entered():
	save_fx($savegames/save4, Color(1,1,1,1))
	
func _on_save4_mouse_exited():
	save_fx($savegames/save4, Color(1,1,1,0.5))

func _on_save4_input_event(viewport, event, shape_idx):
	if get_node("savegames/save4").texture:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				if event.is_pressed():
					save_to_slot(4)


func _on_save5_mouse_entered():
	save_fx($savegames/save5, Color(1,1,1,1))

func _on_save5_mouse_exited():
	save_fx($savegames/save5, Color(1,1,1,0.5))

func _on_save5_input_event(viewport, event, shape_idx):
	if get_node("savegames/save5").texture:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				if event.is_pressed():
					save_to_slot(5)


func _on_save6_mouse_entered():
	save_fx($savegames/save6, Color(1,1,1,1))

func _on_save6_mouse_exited():
	save_fx($savegames/save6, Color(1,1,1,0.5))

func _on_save6_input_event(viewport, event, shape_idx):
	if get_node("savegames/save6").texture:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				if event.is_pressed():
					save_to_slot(6)


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


func _on_page1_mouse_entered():
	$savegames/page1/label_background.hide()

func _on_page1_mouse_exited():
	$savegames/page1/label_background.show()

func _on_page1_input_event(viewport, event, shape_idx):
	pass # replace with function body


func _on_page2_mouse_entered():
	$savegames/page2/label_background.hide()

func _on_page2_mouse_exited():
	$savegames/page2/label_background.show()

func _on_page2_input_event(viewport, event, shape_idx):
	pass # replace with function body


func _on_page3_mouse_entered():
	$savegames/page3/label_background.hide()

func _on_page3_mouse_exited():
	$savegames/page3/label_background.show()

func _on_page3_input_event(viewport, event, shape_idx):
	pass # replace with function body


func _on_page4_mouse_entered():
	$savegames/page4/label_background.hide()
	
func _on_page4_mouse_exited():
	$savegames/page4/label_background.show()

func _on_page4_input_event():
	pass # replace with function body


func _on_page5_mouse_entered():
	$savegames/page5/label_background.hide()

func _on_page5_mouse_exited():
	$savegames/page5/label_background.show()

func _on_page5_input_event(viewport, event, shape_idx):
	pass # replace with function body


func _on_page6_mouse_entered():
	$savegames/page6/label_background.hide()

func _on_page6_mouse_exited():
	$savegames/page6/label_background.show()

func _on_page6_input_event(viewport, event, shape_idx):
	pass # replace with function body


func _on_page7_mouse_entered():
	$savegames/page7/label_background.hide()

func _on_page7_mouse_exited():
	$savegames/page7/label_background.show()

func _on_page7_input_event(viewport, event, shape_idx):
	pass # replace with function body


func _on_page8_mouse_entered():
	$savegames/page8/label_background.hide()

func _on_page8_mouse_exited():
	$savegames/page8/label_background.show()

func _on_page8_input_event(viewport, event, shape_idx):
	pass # replace with function body
