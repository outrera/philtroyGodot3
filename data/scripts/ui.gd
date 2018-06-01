extends Control

onready var viewsize = get_viewport().get_visible_rect().size

onready var screenBlur = $"../effects/blurfx"

var clickPos
var hoverNode = null
var blockingUI = false
var dialogueRunning = false
var noMoveOnClick = false
var itemInHand = ""

var day = 2
var time = 0
var month = 6
var dayOfMonth = 1

onready var effectHoverUI = $"../effects/tween"
onready var effectToggleUI = $"../effects/tween"
onready var effectBlurUI = $"../effects/tween"
onready var fade_in = $"../effects/fade_in"
onready var fade_out = $"../effects/fade_out"
onready var descriptionLabel = $descriptionLabel
onready var sceneCol = $"../scene/col"
onready var transFX = $"../effects/scene_transition"

var phoneOpen = false
var schoolbagOpen = false
var mapOpen = false
var calendarOpen = false
var gameSettingsOpen

onready var phoneHidePos
onready var phoneShowPos
onready var schoolbagHidePos = $"schoolbag_ui".position
onready var schoolbagShowPos
onready var mapHidePos
onready var mapShowPos
onready var calendarHidePos
onready var calendarShowPos

onready var uiIconsShowPos = $map.position.y
onready var uiIconsHidePos = uiIconsShowPos + 200

var trans_capture
var trans_tex

onready var gameSettingsUI = load("res://data/asset scenes/game_settings.tscn")

func _ready():
	schoolbagShowPos = schoolbagHidePos - Vector2(0, 1000)
	phoneHidePos = $phone_ui.position
	phoneShowPos = phoneHidePos - Vector2(0, 1310)	
	mapHidePos = $map_ui.position
	mapShowPos = mapHidePos - Vector2(0, 1000)
	calendarHidePos = $calendar_ui.position
	calendarShowPos =  calendarHidePos - Vector2(0, 1000)
	
	screenBlur.modulate = Color(1, 1, 1, 0)
	
	$map_ui.connect("location_chosen", self, "load_map_location")

func _process(delta):
	#if dialogue is running and we press ui_exit, exit dialogue and delete dialogue nodes
	if Input.is_action_just_pressed("ui_exit"):
		ui_exit()			

func item_in_hand(a,b):			
	var tempTex = load(b)
	Input.set_custom_mouse_cursor(tempTex)
#	$item_in_hand.set_texture(tempTex)
	ui_exit()
	
func load_map_location(location):

	var trans_tex = ImageTexture.new()

	trans_tex.create_from_image(trans_capture)

	$transition.set_texture(trans_tex)

	$transition.show()
	transFX.interpolate_property($transition, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	transFX.start()
	get_parent().change_location(location)
	ui_exit()
		
func exit_map():
	get_parent().mapOpen = true
	get_parent().map_location()

func ui_exit():
	if phoneOpen == true:	
		global.phone_app_running = false
		toggle_ui_overlay("phone_ui", "hide", phoneHidePos)
	if schoolbagOpen == true:	
		toggle_ui_overlay("schoolbag_ui", "hide", schoolbagHidePos)
	if calendarOpen == true:	
		toggle_ui_overlay("calendar_ui", "hide", calendarHidePos)
	if mapOpen == true:	
		toggle_ui_overlay("map_ui", "hide", mapHidePos)
#	if gameSettingsOpen == true:
#		hide_game_settings()

func change_cursor(id):
	if global.itemInHand != "" and global.blocking_ui!=true:
		var cursor = load("res://data/graphics/cursor_" + id + ".png")
		Input.set_custom_mouse_cursor(cursor)
		global.itemInHand = ""

func advance_time():
	time += 1
	if time == 4:
		time = 0
		day +=1
		dayOfMonth += 1
		if day == 7:
			day = 0
		if dayOfMonth == 30:
			dayOfMonth = 1
			month += 1
			if month == 12:
				month = 0
	global.day = day
	global.gameday += 1 # replace the above with this, remove day from global.gameData
	global.month = global.gameData["month"][month]
	global.weekday = global.gameData["weekday"][day]
	global.timeofday = global.gameData["time"][time]

#	TODO: the below code for some reason returns NIL the first time, but captures and assigns a texture the second time
#	and then reuses that same screenshot, even if I run the code again. WHY?!

	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	trans_capture = get_viewport().get_texture().get_data()
	
	trans_capture.flip_y()
	trans_capture.convert(5)

	var trans_tex = ImageTexture.new()

	trans_tex.create_from_image(trans_capture)

	$transition.set_texture(trans_tex)

	$transition.show()
	transFX.interpolate_property($transition, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	transFX.start()
	
#	keep track of day, week and month
	
	global.load_scene(global.scene)
	get_parent().connect()
	get_node("dateLabel").set_text(global.gameData.time[time] + ", " + global.gameData.weekday[day])		
		
func _input(event):
	#these need checks so you can´t press the same key twice, or the overlays will continue upwards
	#pressing a second time should hide the overlays again 
	if event.is_action_pressed("ui_exit"):
		if !mapOpen and !schoolbagOpen and !phoneOpen and !calendarOpen and !global.dialogue_running:
			toggle_game_settings()
	if event.is_action_pressed("ui_inventory") and !mapOpen and !phoneOpen and !calendarOpen and !gameSettingsOpen and !global.dialogue_running:
		if schoolbagOpen!=true:
			toggle_ui_overlay("schoolbag_ui", "show", schoolbagShowPos)
		else:
			toggle_ui_overlay("schoolbag_ui", "hide", schoolbagHidePos)
	if event.is_action_pressed("ui_mobile") and !schoolbagOpen and !mapOpen and !calendarOpen and !gameSettingsOpen and !global.dialogue_running:
		if phoneOpen!=true:
			toggle_ui_overlay("phone_ui", "show", phoneShowPos)
			for app in $phone_ui/apps.get_children():
				app.hide()			
		else:
			toggle_ui_overlay("phone_ui", "hide", phoneHidePos)
	if event.is_action_pressed("ui_map") and !schoolbagOpen and !phoneOpen and !calendarOpen and !gameSettingsOpen and !global.dialogue_running:
		if mapOpen!=true:
			toggle_ui_overlay("map_ui", "show", mapShowPos)
		else:
			toggle_ui_overlay("map_ui", "hide", mapHidePos)
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			if event.pressed:
				print("RMB clicked")
				if global.itemInHand != "":
					print("I have something in my hand")
					change_cursor("default")
	if hoverNode:
		if hoverNode.get_name() == "phone":	
			if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
				toggle_ui_overlay("phone_ui", "show", phoneShowPos)
				for app in $phone_ui/apps.get_children():
					app.hide()	
		elif hoverNode.get_name() == "schoolbag":	
			if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
				toggle_ui_overlay("schoolbag_ui", "show", schoolbagShowPos)
		elif hoverNode.get_name() == "map":	
			if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
				# TODO: investigate ho wo prevent map_ui transition running until screenshot is captured
				# TEST: run screenshot code after transitioning out of map ui, and only then run scene change?
				get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
				
				# so far, tests have shown no reason to use the below, and they make transition to map ui a bit choppy, so..
				yield(get_tree(), "idle_frame")
				yield(get_tree(), "idle_frame")
				yield(get_tree(), "idle_frame")
				
				trans_capture = get_viewport().get_texture().get_data()
				
				trans_capture.flip_y()
				trans_capture.convert(5)
				
				toggle_ui_overlay("map_ui", "show", mapShowPos)
		elif hoverNode.get_name() == "calendar":	
			if event is InputEventMouseButton:
				if event.button_index == BUTTON_LEFT:
					if event.is_pressed():
						advance_time()	
			if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.is_pressed():
				toggle_ui_overlay("calendar_ui", "show", calendarShowPos)

#the below functions handle hover animations for UI icons. This could probably be handled more efficiently in one generic function, not sure how
func _on_phone_mouse_entered():
	if global.itemInHand == "":
		var cursor = load("res://data/graphics/cursor_look.png")
		Input.set_custom_mouse_cursor(cursor)
	ui_hover("phone", get_node("phone/Sprite"), Vector2(1.1, 1.1), true, get_node("phone"))

func _on_phone_mouse_exited():
	if global.itemInHand == "":
		var cursor = load("res://data/graphics/cursor_default.png")
		Input.set_custom_mouse_cursor(cursor)
	ui_hover("", get_node("phone/Sprite"), Vector2(1.0, 1.0), false, null)

func _on_schoolbag_mouse_entered():
	if global.itemInHand == "":
		var cursor = load("res://data/graphics/cursor_look.png")
		Input.set_custom_mouse_cursor(cursor)
	ui_hover("school bag", get_node("schoolbag/Sprite"), Vector2(1.1, 1.1), true, get_node("schoolbag"))

func _on_schoolbag_mouse_exited():
	if global.itemInHand == "":
		var cursor = load("res://data/graphics/cursor_default.png")
		Input.set_custom_mouse_cursor(cursor)
	ui_hover("", get_node("schoolbag/Sprite"), Vector2(1.0, 1.0), false, null)

func _on_map_mouse_entered():
	if global.itemInHand == "":
		var cursor = load("res://data/graphics/cursor_look.png")
		Input.set_custom_mouse_cursor(cursor)
	ui_hover("map", get_node("map/Sprite"), Vector2(1.1, 1.1), true, get_node("map"))

func _on_map_mouse_exited():
	if global.itemInHand == "":
		var cursor = load("res://data/graphics/cursor_default.png")
		Input.set_custom_mouse_cursor(cursor)
	ui_hover("", get_node("map/Sprite"), Vector2(1.0, 1.0), false, null)

func _on_calendar_mouse_entered():
	if global.itemInHand == "":
		var cursor = load("res://data/graphics/cursor_look.png")
		Input.set_custom_mouse_cursor(cursor)
	ui_hover("calendar", get_node("calendar/Sprite"), Vector2(1.1, 1.1), true, get_node("calendar"))

func _on_calendar_mouse_exited():
	if global.itemInHand == "":
		var cursor = load("res://data/graphics/cursor_default.png")
		Input.set_custom_mouse_cursor(cursor)
	ui_hover("", get_node("calendar/Sprite"), Vector2(1.0, 1.0), false, null)

#play effects when hovering over UI icons
func ui_hover(name, gui_node, scale, move, node):
	descriptionLabel.set_text(name)
	noMoveOnClick = move
	effectHoverUI.interpolate_property (gui_node, "scale", gui_node.scale, scale, 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	effectHoverUI.start()
	hoverNode = node
	#if mouse over a UI icon, disable the scene collision shape, preventing player move
	sceneCol.disabled = move

func toggle_ui_icons(toggle):
	var startPos = get_node("map").position.y
	var positionDelta
	if toggle == "show":
		positionDelta = uiIconsShowPos - startPos
	if toggle == "hide":
		positionDelta = uiIconsHidePos - startPos
	for ui_node in get_tree().get_nodes_in_group("UI_icons"):
		ui_hide_show(ui_node, Vector2(0, positionDelta), Tween.TRANS_ELASTIC, Tween.EASE_OUT)

func toggle_ui_overlay(id, mode, deltaPos):
	var positionDelta
	var ui_node = get_node(id)
	if mode == "show":
		global.blocking_ui = true
		global.sceneCol.disabled = true
		toggle_ui_icons("hide")
		effectBlurUI.interpolate_property(screenBlur, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		positionDelta = ui_node.position - deltaPos
	else:
		$dummy_node/dummy_tween.interpolate_property ($dummy_node, "position", $dummy_node.position, $dummy_node.position + Vector2(1,0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$dummy_node/dummy_tween.start()
		toggle_ui_icons("show")
		if global.itemInHand == "":
			change_cursor("default")
		effectBlurUI.interpolate_property(screenBlur, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		positionDelta = deltaPos - ui_node.position
	if id == "schoolbag_ui":
		if mode == "show":
			schoolbagOpen = true
			ui_hide_show(get_node(id), Vector2(0,-1000), Tween.TRANS_QUAD, Tween.EASE_OUT)
		else:
			schoolbagOpen = false
			ui_hide_show(get_node(id), Vector2(0,positionDelta.y), Tween.TRANS_QUAD, Tween.EASE_OUT)
	if id == "phone_ui":
		if mode == "show":
			phoneOpen = true
			ui_hide_show(get_node(id), Vector2(-positionDelta), Tween.TRANS_QUAD, Tween.EASE_OUT)
			fade_in.interpolate_property(get_node(id + "/homescreen"), "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			fade_in.start()
		else:
			phoneOpen = false
			ui_hide_show(get_node(id), Vector2(0,positionDelta.y), Tween.TRANS_QUAD, Tween.EASE_OUT)
			fade_out.interpolate_property(get_node(id + "/homescreen"), "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			fade_out.start()
	if id == "map_ui":
		if mode == "show":
			mapOpen = true
			ui_hide_show(get_node("map_ui"), Vector2(0,-1000), Tween.TRANS_QUAD, Tween.EASE_OUT)
		else:
			mapOpen = false
			ui_hide_show(get_node("map_ui"), Vector2(0,positionDelta.y), Tween.TRANS_QUAD, Tween.EASE_OUT)
	if id == "calendar_ui":
		if mode == "show":
			calendarOpen = true
			ui_hide_show(get_node("calendar_ui"), Vector2(0,-1000), Tween.TRANS_QUAD, Tween.EASE_OUT)
		else:
			calendarOpen = false
			ui_hide_show(get_node("calendar_ui"), Vector2(0,positionDelta.y), Tween.TRANS_QUAD, Tween.EASE_OUT)

#hide or show UI icons when calling blocking UI elements, like phone, map or schoolbag
func ui_hide_show(gui_node, move_delta, method1, method2):
	effectToggleUI.interpolate_property (gui_node, "position", gui_node.position, gui_node.position + move_delta, 0.5, method1, method2)
	effectToggleUI.start()
	
func toggle_game_settings():
	if !global.blocking_ui and !gameSettingsOpen:
		sceneCol.disabled = true
		global.grab_screen()
		$game_settings.show()
		global.blocking_ui = true
		gameSettingsOpen = true
		fade_in.interpolate_property($game_settings, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		fade_in.start()
#		toggle_ui_icons("hide")

	else:
		sceneCol.disabled = false
		global.blocking_ui = false
		gameSettingsOpen = false
		fade_out.interpolate_property($game_settings, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		fade_out.start()
#		toggle_ui_icons("show")

func _on_fade_out_tween_completed(object, key):
	#hide game settings from game after faded out, since it will interfere with other UI overlays even when not visible
	$game_settings.hide()


func _on_tween_in_tween_completed(object, key):
	$location/tween_out.interpolate_property($location, "modulate", Color(1,1,1,1), Color(1,1,1,0), 4, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$location/tween_out.start()


func _on_tween_out_tween_completed(object, key):
	$location.rect_position = Vector2(875, -23)
	$location.hide()

#use to delay blocking_ui = false flag
func _on_dummy_tween_tween_completed(object, key):
	global.blocking_ui = false
	sceneCol.disabled = false
