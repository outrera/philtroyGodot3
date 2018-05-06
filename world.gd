extends Node

var clickPos
var hoverNode = null

#flags/states
var isMoving = false
var isRotating = false
var noMoveOnClick = false
var blockingUI = false
var dialogueRunning = false

var day = 0
var time = 0
var month = 6
var dayOfMonth = 1

var sceneData = {}

onready var effectHoverUI = $"effects/tween"
onready var effectToggleUI = $"effects/tween"
onready var descriptionLabel = $"ui/descriptionLabel"
onready var sceneCol = $"scene/col"

onready var screenBlur = $"effects/blurfx"

onready var viewsize = get_viewport().get_visible_rect().size

var phoneOpen = false
var schoolbagOpen = false
var mapOpen = false
var calendarOpen = false

onready var phoneHidePos
onready var phoneShowPos
onready var schoolbagHidePos = $"ui/schoolbag_ui".position
onready var schoolbagShowPos
onready var mapHidePos
onready var mapShowPos
onready var calendarHidePos
onready var calendarShowPos

onready var uiIconsShowPos = $"ui/map".position.y
onready var uiIconsHidePos = uiIconsShowPos + 200

func _ready():

	schoolbagShowPos = schoolbagHidePos - Vector2(0, 1000)
	phoneHidePos = $"ui/phone_ui".position
	phoneShowPos = phoneHidePos - Vector2(0, 1310)	
	mapHidePos = $"ui/map_ui".position
	mapShowPos = mapHidePos - Vector2(0, 1000)
	calendarHidePos = $"ui/calendar_ui".position
	calendarShowPos =  calendarHidePos - Vector2(0, 1000)
	
	set_process(true)
	set_process_input(true)
		
	$"ui/dateLabel".set_text(global.gameData.time[time] + ", " + global.gameData.weekday[day])
	
	global.scene = "schoolyard"
	#Why? WHY does the below affect rotation of the NPC if I remove it?!
#	sceneData = global.load_json("res://data/locations/location_schoolyard.json")
	global.load_scene("schoolyard")

	$"ui/map_ui".connect("exit_ui", self, "map_location")
	connect()
	
func connect():
	for object in get_node("objects").get_children():
		object.connect("look_at", self, "_look_at")
	for object in get_node("npcs").get_children():
		object.connect("look_at", self, "_look_at")
	for object in get_node("npcs").get_children():
		object.connect("dialogue", get_node("dialogue"), "_talk_to")

func _process(delta):
	#if dialogue is running and we press ui_exit, exit dialogue and delete dialogue nodes
	if Input.is_action_pressed("ui_exit"):
		ui_exit()

func map_location(location):
	global.scene = location
	global.load_scene(location)
	
	connect()
	#issue with map scene changing is in ui_exit, sets global.blocking_ui = false
	#find alternative solution
	ui_exit()

func ui_exit():
	if dialogueRunning == true:
		kill_dialogue()
	if phoneOpen == true:	
		global.blocking_ui = false
		phoneOpen = false
		screenBlur.hide()
		var positionDelta = phoneHidePos - get_node("ui/phone_ui").position
		ui_hide_show(get_node("ui/phone_ui"), Vector2(0,positionDelta.y), Tween.TRANS_QUAD, Tween.EASE_OUT)
		toggle_ui_icons("show")
	if schoolbagOpen == true:	
		global.blocking_ui = false
		schoolbagOpen = false
		screenBlur.hide()
		var positionDelta = schoolbagHidePos - get_node("ui/schoolbag_ui").position
		ui_hide_show(get_node("ui/schoolbag_ui"), Vector2(0,positionDelta.y), Tween.TRANS_QUAD, Tween.EASE_OUT)
		toggle_ui_icons("show")
	if mapOpen == true:	
		global.blocking_ui = false
		mapOpen = false
		screenBlur.hide()
		var positionDelta = mapHidePos - get_node("ui/map_ui").position
		ui_hide_show(get_node("ui/map_ui"), Vector2(0,positionDelta.y), Tween.TRANS_QUAD, Tween.EASE_OUT)
		toggle_ui_icons("show")
	if calendarOpen == true:	
		global.blocking_ui = false
		calendarOpen = false
		screenBlur.hide()
		var positionDelta = calendarHidePos - get_node("ui/calendar_ui").get_position()
		ui_hide_show(get_node("ui/calendar_ui"), Vector2(0,positionDelta.y), Tween.TRANS_QUAD, Tween.EASE_OUT)
		toggle_ui_icons("show")

func _input(event):
	if hoverNode:
		if hoverNode.get_name() == "phone":	
			if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
				global.blocking_ui = true
				phoneOpen = true
				#screenBlur.show()
				toggle_ui_icons("hide")
				var positionDelta = get_node("ui/phone_ui").position - phoneShowPos
				ui_hide_show(get_node("ui/phone_ui"), Vector2(-positionDelta), Tween.TRANS_QUAD, Tween.EASE_OUT)
		elif hoverNode.get_name() == "schoolbag":	
			if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
				global.blocking_ui = true
				schoolbagOpen = true
				#screenBlur.show()
				toggle_ui_icons("hide")
				var positionDelta = get_node("ui/phone_ui").position - schoolbagShowPos
				ui_hide_show(get_node("ui/schoolbag_ui"), Vector2(0,-1000), Tween.TRANS_QUAD, Tween.EASE_OUT)
		elif hoverNode.get_name() == "map":	
			if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
				global.blocking_ui = true
				mapOpen = true
				#screenBlur.show()
				toggle_ui_icons("hide")
				var positionDelta = get_node("ui/phone_ui").position - mapShowPos
				ui_hide_show(get_node("ui/map_ui"), Vector2(0,-1000), Tween.TRANS_QUAD, Tween.EASE_OUT)
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
						global.gameday += 1 # replace the above with this, remove day from global.gameData
						global.weekday = global.gameData["weekday"][day]
						global.timeofday = global.gameData["time"][time]
						global.load_scene(global.scene)

						connect()

						get_node("ui/dateLabel").set_text(global.gameData.time[time] + ", " + global.gameData.weekday[day])		

			if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.is_pressed():
				global.blocking_ui = true
				calendarOpen = true
				#screenBlur.show()
				toggle_ui_icons("hide")
				var positionDelta = get_node("ui/phone_ui").position - calendarShowPos
				ui_hide_show(get_node("ui/calendar_ui"), Vector2(0,-1000), Tween.TRANS_QUAD, Tween.EASE_OUT)

#the below functions handle hover animations for UI icons. This could probably be handled more efficiently in one generic function, not sure how
func _on_phone_mouse_entered():
	ui_hover("phone", get_node("ui/phone/Sprite"), Vector2(1.1, 1.1), true)
	hoverNode = get_node("ui/phone")
	sceneCol.disabled = true

func _on_phone_mouse_exited():
	ui_hover("", get_node("ui/phone/Sprite"), Vector2(1.0, 1.0), false)
	hoverNode = null
	sceneCol.disabled = false

func _on_schoolbag_mouse_entered():
	ui_hover("school bag", get_node("ui/schoolbag/Sprite"), Vector2(1.1, 1.1), true)
	hoverNode = get_node("ui/schoolbag")
	sceneCol.disabled = true

func _on_schoolbag_mouse_exited():
	ui_hover("", get_node("ui/schoolbag/Sprite"), Vector2(1.0, 1.0), false)
	hoverNode = null
	sceneCol.disabled = false

func _on_map_mouse_entered():
	ui_hover("map", get_node("ui/map/Sprite"), Vector2(1.1, 1.1), true)
	hoverNode = get_node("ui/map")
	sceneCol.disabled = true

func _on_map_mouse_exited():
	ui_hover("", get_node("ui/map/Sprite"), Vector2(1.0, 1.0), false)
	hoverNode = null
	sceneCol.disabled = false

func _on_calendar_mouse_entered():
	ui_hover("calendar", get_node("ui/calendar/Sprite"), Vector2(1.1, 1.1), true)
	hoverNode = get_node("ui/calendar")
#	global.blocking_ui = true
	sceneCol.disabled = true

func _on_calendar_mouse_exited():
	ui_hover("", get_node("ui/calendar/Sprite"), Vector2(1.0, 1.0), false)
	hoverNode = null
#	global.blocking_ui = false
	sceneCol.disabled = false

#play effects when hovering over UI icons
func ui_hover(name, gui_node, scale, move):
	descriptionLabel.set_text(name)
	noMoveOnClick = move
	effectHoverUI.interpolate_property (gui_node, "scale", gui_node.scale, scale, 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	effectHoverUI.start()

#hide or show UI icons when calling blocking UI elements, like phone, map or schoolbag
func ui_hide_show(gui_node, move_delta, method1, method2):
	effectToggleUI.interpolate_property (gui_node, "position", gui_node.position, gui_node.position + move_delta, 0.5, method1, method2)
	effectToggleUI.start()

func toggle_ui_icons(toggle):
	var startPos = get_node("ui/map").position.y
	var positionDelta
	if toggle == "show":
		positionDelta = uiIconsShowPos - startPos
	if toggle == "hide":
		positionDelta = uiIconsHidePos - startPos
	for ui_node in get_tree().get_nodes_in_group("UI_icons"):
		ui_hide_show(ui_node, Vector2(0, positionDelta), Tween.TRANS_ELASTIC, Tween.EASE_OUT)

func _look_at(text):
	descriptionLabel.set_text(text)







