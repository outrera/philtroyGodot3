extends Node

var gameday
var weekday
var timeofday
var scene

var tempData = {}
var sceneData = {}
var eventOverride = {}
var gameVars = {}
#ex:
#var gameVars = {
#	"event": "non",
#	"eventDay": 23,
#	"eventTOD": "evening"
#}

var blocking_ui = false
var is_moving = false

#let´s make this a json loaded at ready, so as to not clutter the script
var gameData = {
	"month": [
		"january",
		"february",
		"march",
		"april",
		"may",
		"june",
		"july",
		"august",
		"september",
		"oktober",
		"november",
		"december",
	],
	"weekday": [
		"monday",
		"tuesday",
		"wednesday",
		"thursday",
		"friday",
		"saturday",
		"sunday"], 
	"time": [
		"morning",
		"noon",
		"evening",
		"night"
	], 
}

var eventData = {}

var charData = {
	"ellie": {
	"dialogue": "res://data/dialogue/ellie.json", 
	"branch": "a",
	"relationship": "2"},
	"bobby": {
	"dialogue": "res://data/dialogue/bobby.json", 
	"branch": "a",
	"relationship": "2"},
	"sam": {
	"dialogue": "res://data/dialogue/sam.json", 
	"branch": "a",
	"relationship": "2"}
	}

var locations = [
	"schoolyard",
	"schoolhall",
	"myroom"]
	
var playerScript = preload("res://data/scripts/player.gd")

func _ready():
	set_process(true)
	
	eventData = load_json("res://data/events/gameEvents.json")
	
	for location in locations:
		sceneData[location] = load_json("res://data/locations/location_" + location + ".json")
	
	gameday = 1
	weekday = "monday"
	timeofday = "morning"

func _process(delta):
	if Input.is_action_pressed("ui_reload"):
		get_tree().reload_current_scene()
	if Input.is_action_pressed("ui_quit"):
		get_tree().quit()

func load_json(json):
	var file = File.new()
	file.open(json, File.READ)
	tempData = parse_json(file.get_as_text())
	return tempData
	tempData = null
	file.close()
	#for Godot 3.0
#	var file = File.new()
#	file.open(json, File.READ)
#	tempData = parse_json(file.get_as_text())

func goto_scene(scene):
    get_tree().change_scene("res://"+scene)

func load_scene(sceneLocation): #change this first, see if any conflicts
	var gameRoot = get_tree().get_root().get_node("Node")
#	
	gameRoot.get_node("player").queue_free()
	gameRoot.get_node("player").set_name("DELETED")

	var player = load("res://data/asset scenes/player.tscn")
	player = player.instance()
	player.set_translation(Vector3(0,0.46,0))
	player.set_rotation(Vector3(-0,0,-0))
	player.set_name("player")
	player.set_script(playerScript)
	gameRoot.get_node("scene").connect("input_event", player,"_on_scene_input_event")
	gameRoot.add_child(player)

	for child in gameRoot.get_node("scene").get_children():
		#check that we delete everything but the collision node
		if child.name != "col":
			child.set_name("DELETED")
			child.queue_free()
	for child in gameRoot.get_node("npcs").get_children():
		child.set_name("DELETED")
		child.queue_free()

	var scene = load("res://data/locations/" + sceneLocation + ".tscn")
	scene = scene.instance()
	gameRoot.get_node("scene").add_child(scene)

	var location = sceneData[sceneLocation][weekday][timeofday]

	if location.has("actors"):
		for name in location["actors"].keys():
			var pos = location["actors"][name]["pos"]
			var rot = location["actors"][name]["rot"]
			#TODO: think I might need to add a default dialogue to charData as well
			if location["actors"][name]["dialogue"] != "default":
				global.charData[name]["dialogue"] = location["actors"][name]["dialogue"]
			var actor = load("res://data/npcs/" + name + ".tscn")
			#TODO: pose > animation? For now use base animation.
			actor = actor.instance()
			actor.set_translation(Vector3(pos.x,pos.y,pos.z))
			actor.set_rotation(Vector3(rot.x,rot.y, rot.z))
			actor.set_name(name)
			gameRoot.get_node("npcs").add_child(actor)

	if location.has("objects"):
		for name in location["objects"].keys():
			var pos = location["objects"][name]["pos"]
			var rot = location["actors"][name]["rot"]
			var object = load("res://data/objects/" + name + ".tscn")
			object.set_position(Vector3(pos.x, pos.y, pos.z))
			object.set_rotation(Vector3(rot.x,rot.y, rot.z))
			object.set_name(name)
			get_node("objects").add_child(object)

	#if today has event - override
	if eventData["date"].has(str(gameday)) and eventData["date"][str(gameday)][0].has(timeofday):
		eventOverride = load_json("events/" + eventData["date"][str(gameday)][0][timeofday]["name"] + ".json")
	else:
		pass

	#TODO: animate scene transition somehow(time label swapped with animation?)
	#TODO: how to handle scene specific cameras?
