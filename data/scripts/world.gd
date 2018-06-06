extends Node

signal timer_end

var timer

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

var thoughts_showing = false

var sceneData = {}

onready var descriptionLabel = $"ui/descriptionLabel"
onready var thought_bubble = $"ui/thoughtBubble"

onready var screenBlur = $"effects/blurfx"
onready var materialize =$"ui/thoughtBubble/materialize"
onready var dissolve =$"ui/thoughtBubble/dissolve"

onready var viewsize = get_viewport().get_visible_rect().size

func _ready():
	var cursor = load("res://data/graphics/cursor_default.png")
	Input.set_custom_mouse_cursor(cursor)
	
	set_process(true)
	set_process_input(true)
		
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
		if global.gameType == "3D Point n Click":
			thought_bubble.set_position($Camera.unproject_position((get_node("player").translation) + Vector3(0,4.6,0)) - Vector2(30,0))

func change_location(location):
	global.scene = location
	global.load_scene(location)
	connect()
	#issue with map scene changing is in ui_exit, sets global.blocking_ui = false
	#find alternative solution

func _input(event):
	pass

func thought_bubble(text):
	if text != "" and isLookingAt == false:
		thought_bubble.show()
		materialize.interpolate_property(thought_bubble, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		materialize.start()
		isLookingAt = true

	thought_bubble.add_color_override("font_color", Color(0,0,0,1))
	thought_bubble.set_text(text)
	
func _highlight(text):
#	descriptionLabel.set_position($Camera.unproject_position($player.translation) - Vector2(60,230))
	descriptionLabel.set_text(text)

func _on_tween_tween_completed(object, key):
	pass # replace with function body


func _on_materialize_tween_completed(object, key):
	_wait(2)

func _wait( seconds ):
    self._create_timer(self, seconds, true, "dissolve")
    yield(self,"timer_end")

func dissolve():
	dissolve.interpolate_property(thought_bubble, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	dissolve.start()
	isLookingAt = false

func _create_timer(object_target, float_wait_time, bool_is_oneshot, string_function):
	# KidsCanCode suggested yield(get_tree().create_timer(2.0), 'timeout')
	# will try that version later, but for now this works great
    timer = Timer.new()
    timer.set_one_shot(bool_is_oneshot)
    timer.set_timer_process_mode(0)
    timer.set_wait_time(float_wait_time)
    timer.connect("timeout", object_target, string_function)
    self.add_child(timer)
    timer.start()
