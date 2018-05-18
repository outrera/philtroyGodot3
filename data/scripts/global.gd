extends Node

var gameType

var day
var gameday
var weekday
var timeofday
var month

var tempData = {}
var sceneData = {}
var gameData = {}
var eventData = {}
var charData = {}
var gameVars = {}
var inventoryData = {}
var contactData = {
	"c1" : "Ellie - 894 569 235",
	"c2" : "Bobby - 867 465 876",
	"c3" : "Mom - 657 689 576"
}
var archiveData = {
	"img01" : "res://data/graphics/img01.png",
	"img02" : "res://data/graphics/img02.png",
	"img03" : "res://data/graphics/img03.png",
	"img04" : "res://data/graphics/img04.png",
	"img05" : "res://data/graphics/img05.png",
	"img06" : "res://data/graphics/img06.png",
}

var dialogue_running
var blocking_ui = false
var phone_app_running = false
var is_moving = false
var itemInHand = false

var scene
var locations = []
var currentLocation
var eventOverride = {}
	
var playerScript = preload("res://data/scripts/player.gd")

onready var sceneCol = get_tree().get_root().get_node("world").get_node("scene").get_node("col")

func _ready():
	set_process(true)
	
	dialogue_running = false
	
	inventoryData = load_json("res://data/global/inventory_data.json")
	eventData = load_json("res://data/events/gameEvents.json")
	gameData = load_json("res://data/global/game_data.json")
	charData = load_json("res://data/global/character_data.json")
	locations = load_json("res://data/global/location_data.json")
	
	for location in locations:
		sceneData[location] = load_json("res://data/locations/location_" + location + ".json")
	
	gameday = 1
	day= 1
	weekday = "wednesday"
	timeofday = "morning"
	month=7
	
	eventOverride = null

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

func goto_scene(scene):
    get_tree().change_scene("res://"+scene)

func load_scene(sceneLocation): #change this first, see if any conflicts
	currentLocation = sceneLocation
	var location = sceneData[sceneLocation][weekday][timeofday]
	
	var gameRoot = get_tree().get_root().get_node("world")

#if today has event - override
	if eventData["date"].has(str(gameday)) and eventData["date"][str(gameday)][0].has(timeofday):
		if eventData["type"] == "persistent":
			pass
			#loop through actors and objects in eventOverride, remove and add from location specified

		elif eventData["type"] == "oneoff":
			eventOverride = load_json("events/" + eventData["date"][str(gameday)][0][timeofday]["name"] + ".json")
	else:
		pass
	
	gameRoot.get_node("player").queue_free()
	gameRoot.get_node("player").set_name("DELETED")

	for child in gameRoot.get_node("scene").get_children():
		#check that we delete everything but the collision node
		if child.name != "col":
			child.set_name("DELETED")
			child.queue_free()
			
	var scene = load("res://data/locations/" + sceneLocation + ".tscn")
	scene = scene.instance()
	gameRoot.get_node("scene").add_child(scene)
	
#	Determine if we´re doing a 3d adventure game or Visual Novel-style game, by checking for type of fisrt node in scene (Area/Area2D)
#	This is just the first preparation. Still TODO: code currently assumes 3d meshes when placing NPCs and Objects (Using a Vector3) - need to
#	allow for Vector2 position

	if scene.is_class("Area"):
		gameType = "Adventure Game"
		var player = load("res://data/asset scenes/player.tscn")
		player = player.instance()
		player.set_translation(Vector3(0,1,0))
		player.set_rotation(Vector3(-0,0,-0))
		player.set_name("player")
		player.set_script(playerScript)
		gameRoot.get_node("scene").connect("input_event", player,"_on_scene_input_event")
		gameRoot.add_child(player)
	else:
		gameType = "Visual Novel"

	for child in gameRoot.get_node("npcs").get_children():
		child.set_name("DELETED")
		child.queue_free()
		
#	if eventOverride == null: 
#		print("null")

#   OLD CODE - keeping around until I´m sure the below code does not cause unforseen issues :P 
#	if location.has("actors"):
#		for name in location["actors"].keys():
#			var pos = location["actors"][name]["pos"]
#			var rot = location["actors"][name]["rot"]
#			#TODO: think I might need to add a default dialogue to charData as well
#			if location["actors"][name]["dialogue"] != "default":
#				global.charData[name]["dialogue"] = location["actors"][name]["dialogue"]
#			var actor = load("res://data/npcs/" + name + ".tscn")
#			#TODO: pose > animation? For now use base animation.
#			actor = actor.instance()
#			actor.set_translation(Vector3(pos.x,pos.y,pos.z))
#			actor.set_rotation(Vector3(rot.x,rot.y, rot.z))
#			actor.set_name(name)
#			gameRoot.get_node("npcs").add_child(actor)
	if location.has("actors"):
		for name in location["actors"].keys():
			var actor
			var pos
			var rot
			if eventOverride != null and eventOverride["add"]["actor"].has(name):
				pos = eventOverride["add"]["actor"][name]["pos"]
				rot = eventOverride["add"]["actor"][name]["rot"]
				global.charData[name]["dialogue"] = eventOverride["add"]["actor"][name]["dialogue"]
				actor = load("res://data/npcs/" + eventOverride["add"]["actor"][name]["animation"] + ".tscn")

			else:
				pos = location["actors"][name]["pos"]
				rot = location["actors"][name]["rot"]
				#TODO: think I might need to add a default dialogue to charData as well
				if location["actors"][name]["dialogue"] != "default":
					global.charData[name]["dialogue"] = location["actors"][name]["dialogue"]
				actor = load("res://data/npcs/" + name + ".tscn")

			#TODO: pose > animation? For now use base animation.
			actor = actor.instance()
			actor.set_translation(Vector3(pos.x,pos.y,pos.z))
			actor.set_rotation(Vector3(rot.x,rot.y, rot.z))
			actor.set_name(name)
			gameRoot.get_node("npcs").add_child(actor)

#   OLD CODE - keeping around until I´m sure the below code does not cause unforseen issues :P 
#	if location.has("objects"):
#		for name in location["objects"].keys():
#			var pos = location["objects"][name]["pos"]
#			var rot = location["actors"][name]["rot"]
#			var object = load("res://data/objects/" + name + ".tscn")
#			object.set_position(Vector3(pos.x, pos.y, pos.z))
#			object.set_rotation(Vector3(rot.x,rot.y, rot.z))
#			object.set_name(name)
#			get_node("objects").add_child(object)

#	TODO: replace the above conditional block with (might need some refactoring to fit new code):
	
	if location.has("objects"):
		var object
		var pos
		var rot
		for name in location["object"].keys():
			if eventOverride != null and eventOverride["add"]["object"].has(name):
				pos = eventOverride["add"]["object"][name]["pos"]
				rot = eventOverride["add"]["object"][name]["rot"]
				global.charData[name]["dialogue"] = eventOverride["add"]["object"][name]["dialogue"]
				object = load("res://data/npcs/" + eventOverride["add"]["object"][name]["animation"] + ".tscn")

			else:
				pos = location["objects"][name]["pos"]
				rot = location["actors"][name]["rot"]
				object = load("res://data/objects/" + name + ".tscn")

			object.set_position(Vector3(pos.x, pos.y, pos.z))
			object.set_rotation(Vector3(rot.x,rot.y, rot.z))
			object.set_name(name)
			get_node("objects").add_child(object)

	#set eventOverride back to null, as it´s only needed and updated when calling load_scene()
	eventOverride = null
		
#	TODO: animate scene transition somehow(time label swapped with animation?)
#	TODO: how to handle scene specific cameras?

func event_notifier():
	pass
