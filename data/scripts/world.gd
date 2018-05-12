extends Node

var clickPos

#flags/states
var isMoving = false
var isRotating = false
var noMoveOnClick = false
var dialogueRunning = false

var day = 0
var time = 0
var month = 6
var dayOfMonth = 1

var sceneData = {}

onready var descriptionLabel = $"ui/descriptionLabel"

onready var screenBlur = $"effects/blurfx"

onready var viewsize = get_viewport().get_visible_rect().size

func _ready():
	var cursor = load("res://data/graphics/cursor_default.png")
	Input.set_custom_mouse_cursor(cursor)
	
	set_process(true)
	set_process_input(true)
		
	$"ui/dateLabel".set_text(global.gameData.time[time] + ", " + global.gameData.weekday[day] + ", " + global.gameData.month[month])	
	
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

func _process(delta):
	pass

func change_location(location):
	global.scene = location
	global.load_scene(location)
	connect()
	#issue with map scene changing is in ui_exit, sets global.blocking_ui = false
	#find alternative solution

func _input(event):
	pass

func _look_at(text):
	descriptionLabel.set_text(text)







