extends Control

onready var viewsize = get_viewport().get_visible_rect().size

onready var screenBlur = $"../effects/blurfx"

var clickPos
var hoverNode = null
var blockingUI = false
var dialogueRunning = false
var noMoveOnClick = false
var itemInHand = false

var day = 2
var time = 0
var month = 6
var dayOfMonth = 1

onready var effectHoverUI = $"../effects/tween"
onready var effectToggleUI = $"../effects/tween"
onready var effectBlurUI = $"../effects/tween"
onready var descriptionLabel = $descriptionLabel
onready var sceneCol = $"../scene/col"

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

onready var gameSettingsUI = load("res://data/asset scenes/game_settings.tscn")

func _ready():
	schoolbagShowPos = schoolbagHidePos - Vector2(0, 1000)
	phoneHidePos = $phone_ui.position
	phoneShowPos = phoneHidePos - Vector2(0, 1310)	
	mapHidePos = $map_ui.position
	mapShowPos = mapHidePos - Vector2(0, 1000)
	calendarHidePos = $calendar_ui.position
	calendarShowPos =  calendarHidePos - Vector2(0, 1000)
	
	print (schoolbagShowPos)
	
	screenBlur.modulate = Color(1, 1, 1, 0)
	
	$map_ui.connect("location_chosen", self, "load_map_location")

func _process(delta):
	#if dialogue is running and we press ui_exit, exit dialogue and delete dialogue nodes
	if Input.is_action_pressed("ui_exit"):
		ui_exit()

func item_in_hand(a,b):			
	var tempTex = load(b)
	Input.set_custom_mouse_cursor(tempTex)
#	$item_in_hand.set_texture(tempTex)
	global.itemInHand = true
	ui_exit()
	
func load_map_location(location):
	get_parent().change_location(location)
	ui_exit()
		
func exit_map():
	get_parent().mapOpen = true
	get_parent().map_location()

func ui_exit():
	if phoneOpen == true:	
		toggle_ui_overlay("phone_ui", "hide", phoneHidePos)
	if schoolbagOpen == true:	
		toggle_ui_overlay("schoolbag_ui", "hide", schoolbagHidePos)
	if calendarOpen == true:	
		toggle_ui_overlay("calendar_ui", "hide", calendarHidePos)
	if mapOpen == true:	
		toggle_ui_overlay("map_ui", "hide", mapHidePos)
	if gameSettingsOpen == true:
		hide_game_settings()

func change_cursor(id):
	var cursor = load("res://data/graphics/cursor_" + id + ".png")
	Input.set_custom_mouse_cursor(cursor)
		
func _input(event):
	#these need checks so you can´t press the same key twice, or the overlays will continue upwards
	#pressing a second time should hide the overlays again 
	if event.is_action_pressed("ui_exit"):
		if global.blocking_ui!=true:
			if global.dialogue_running!=true:
				if gameSettingsOpen!=true:
					toggle_game_settings()
	if event.is_action_pressed("ui_inventory"):
		if schoolbagOpen!=true:
			toggle_ui_overlay("schoolbag_ui", "show", schoolbagShowPos)
		else:
			toggle_ui_overlay("schoolbag_ui", "hide", schoolbagHidePos)
	if event.is_action_pressed("ui_mobile"):
		if phoneOpen!=true:
			toggle_ui_overlay("phone_ui", "show", phoneShowPos)
		else:
			toggle_ui_overlay("phone_ui", "hide", phoneHidePos)
	if event.is_action_pressed("ui_map"):
		if mapOpen!=true:
			toggle_ui_overlay("map_ui", "show", mapShowPos)
		else:
			toggle_ui_overlay("map_ui", "hide", mapHidePos)
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			if event.pressed:
				if global.itemInHand == true:
					global.itemInHand = false
					change_cursor("default")
	if hoverNode:
		if hoverNode.get_name() == "phone":	
			if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
				toggle_ui_overlay("phone_ui", "show", phoneShowPos)
		elif hoverNode.get_name() == "schoolbag":	
			if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
				toggle_ui_overlay("schoolbag_ui", "show", schoolbagShowPos)
		elif hoverNode.get_name() == "map":	
			if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
				toggle_ui_overlay("map_ui", "show", mapShowPos)
		elif hoverNode.get_name() == "calendar":	
			if event is InputEventMouseButton:
				if event.button_index == BUTTON_LEFT:
					if event.is_pressed():
						#keep track of day, week and month
						time += 1
						if time == 4:
							time = 0
							day +=1
							dayOfMonth += 1
							if day == 7:
								day = 0
							if dayOfMonth > 30:
								dayOfMonth = 1
								month += 1
								if month > 12:
									month = 0
						global.day = day
						global.gameday += 1 # replace the above with this, remove day from global.gameData
						global.month = global.gameData["month"][month]
						global.weekday = global.gameData["weekday"][day]
						global.timeofday = global.gameData["time"][time]
						global.load_scene(global.scene)

						get_parent().connect()

						get_node("dateLabel").set_text(global.gameData.time[time] + ", " + global.gameData.weekday[day] + ", " + global.gameData.month[month])		

			if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.is_pressed():
				toggle_ui_overlay("calendar_ui", "show", calendarShowPos)

#the below functions handle hover animations for UI icons. This could probably be handled more efficiently in one generic function, not sure how
func _on_phone_mouse_entered():
	if global.itemInHand == false and global.blocking_ui!=true:
		change_cursor("look")
	ui_hover("phone", get_node("phone/Sprite"), Vector2(1.1, 1.1), true)
	hoverNode = get_node("phone")
	#if mouse over a UI icon, disable the scene collision shape, preventing player move
	sceneCol.disabled = true

func _on_phone_mouse_exited():
	if global.itemInHand == false and global.blocking_ui!=true:
		change_cursor("default")
	ui_hover("", get_node("phone/Sprite"), Vector2(1.0, 1.0), false)
	hoverNode = null
	sceneCol.disabled = false

func _on_schoolbag_mouse_entered():
	if global.itemInHand == false and global.blocking_ui!=true:
		change_cursor("look")
	ui_hover("school bag", get_node("schoolbag/Sprite"), Vector2(1.1, 1.1), true)
	hoverNode = get_node("schoolbag")
	sceneCol.disabled = true

func _on_schoolbag_mouse_exited():
	if global.itemInHand == false and global.blocking_ui!=true:
		change_cursor("default")
	ui_hover("", get_node("schoolbag/Sprite"), Vector2(1.0, 1.0), false)
	hoverNode = null
	sceneCol.disabled = false

func _on_map_mouse_entered():
	if global.itemInHand == false and global.blocking_ui!=true:
		change_cursor("look")
	ui_hover("map", get_node("map/Sprite"), Vector2(1.1, 1.1), true)
	hoverNode = get_node("map")
	sceneCol.disabled = true

func _on_map_mouse_exited():
	if global.itemInHand == false and global.blocking_ui!=true:
		change_cursor("default")
	ui_hover("", get_node("map/Sprite"), Vector2(1.0, 1.0), false)
	hoverNode = null
	sceneCol.disabled = false

func _on_calendar_mouse_entered():
	if global.itemInHand == false and global.blocking_ui!=true:
		change_cursor("look")
	ui_hover("calendar", get_node("calendar/Sprite"), Vector2(1.1, 1.1), true)
	hoverNode = get_node("calendar")
	#global.blocking_ui = true
	sceneCol.disabled = true

func _on_calendar_mouse_exited():
	if global.itemInHand == false and global.blocking_ui!=true:
		change_cursor("default")
	ui_hover("", get_node("calendar/Sprite"), Vector2(1.0, 1.0), false)
	hoverNode = null
	#global.blocking_ui = false
	sceneCol.disabled = false

#play effects when hovering over UI icons
func ui_hover(name, gui_node, scale, move):
	descriptionLabel.set_text(name)
	noMoveOnClick = move
	effectHoverUI.interpolate_property (gui_node, "scale", gui_node.scale, scale, 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	effectHoverUI.start()

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
		toggle_ui_icons("hide")
		effectBlurUI.interpolate_property(screenBlur, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		positionDelta = ui_node.position - deltaPos
	else:
		global.blocking_ui = false
		toggle_ui_icons("show")
		if global.itemInHand == false:
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
		else:
			phoneOpen = false
			ui_hide_show(get_node(id), Vector2(0,positionDelta.y), Tween.TRANS_QUAD, Tween.EASE_OUT)
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
	var mytween = get_parent().get_node("effects/tween")
	global.blocking_ui = true
	gameSettingsOpen = true
	var gameSettings = gameSettingsUI.instance()
	gameSettings.name = "game_settings"
	gameSettings.set_position(Vector2(400,300))
	self.add_child(gameSettings)
	print($game_settings)
	mytween.interpolate_property($game_settings, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	effectBlurUI.interpolate_property(gameSettings, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	toggle_ui_icons("hide")
#	ui_hide_show(gameSettings, Vector2(0,-1000), Tween.TRANS_QUAD, Tween.EASE_OUT)

#func hide_calendar_ui():
#	global.blocking_ui = false
#	calendarOpen = false
#	effectBlurUI.interpolate_property(screenBlur, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
#	var positionDelta = calendarHidePos - get_node("calendar_ui").get_position()
#	ui_hide_show(get_node("calendar_ui"), Vector2(0,positionDelta.y), Tween.TRANS_QUAD, Tween.EASE_OUT)
#	toggle_ui_icons("show")
#	change_cursor("default")

func hide_game_settings():
	global.blocking_ui = false
	gameSettingsOpen = false
	var mytween = get_parent().get_node("effects/tween")
	mytween.interpolate_property($game_settings, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	$settings.queue_free()
#	$settings.name = "deleted"
	toggle_ui_icons("show")
	change_cursor("default")

