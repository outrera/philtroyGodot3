extends Node

var clickPos

#flags/states
var isMoving = false
var isRotating = false
var noMoveOnClick = false
var dialogueRunning = false
var isLookingAt = false

var day = 2
var time = 0
var month = 6
var dayOfMonth = 1

var sceneData = {}

onready var descriptionLabel = $"ui/descriptionLabel"
onready var lookatLabel = $"ui/lookatLabel"

onready var screenBlur = $"effects/blurfx"

onready var viewsize = get_viewport().get_visible_rect().size

func _ready():
	var cursor = load("res://data/graphics/cursor_default.png")
	Input.set_custom_mouse_cursor(cursor)
	
	set_process(true)
	set_process_input(true)
	print($player.translation)
	print($Camera.unproject_position($player.translation))
		
	$"ui/dateLabel".set_text(global.gameData.time[time] + ", " + global.gameData.weekday[day])	
	
	global.scene = "schoolyard"
	#Why? WHY does the below affect rotation of the NPC if I remove it?!
#	sceneData = global.load_json("res://data/locations/location_schoolyard.json")
	global.load_scene("schoolyard")

	connect()
	
func connect():
	for object in get_node("objects").get_children():
		object.connect("look_at", self, "_look_at")
	for object in get_node("npcs").get_children():
		object.connect("look_at", self, "_look_at")
	for object in get_node("npcs").get_children():
		object.connect("dialogue", get_node("dialogue"), "_talk_to")
	for object in get_node("npcs").get_children():
		object.connect("highlight", self, "_highlight")

func _process(delta):
		if global.gameType == "Adventure Game":
			lookatLabel.set_position($Camera.unproject_position((get_node("player").translation) + Vector3(0,4.6,0)) - Vector2(30,0))

func change_location(location):
	global.scene = location
	global.load_scene(location)
	connect()
	#issue with map scene changing is in ui_exit, sets global.blocking_ui = false
	#find alternative solution

func _input(event):
	pass

func _look_at(text):
	if text != "":
		lookatLabel.get_node("bubble").show()
		isLookingAt = false
	else:
		lookatLabel.get_node("bubble").hide()
		isLookingAt = true
	lookatLabel.add_color_override("font_color", Color(0,0,0,1))
	lookatLabel.set_text(text)
	
func _highlight(text):
#	descriptionLabel.set_position($Camera.unproject_position($player.translation) - Vector2(60,230))
	descriptionLabel.set_text(text)







