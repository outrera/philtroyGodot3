extends Node2D

#TODO: selecting reply on single reply dialogue, doesnt select replies. Set so if dialogue text and replies are displayed
#enter automatically choses first reply?

var npcDialogue = {}
var talkData = {}

var dialogue = {}
var branch = {}
var replies = {}

onready var dialogPanel = load("res://data/asset scenes/dialogue_window.tscn")
onready var replyButton = load("res://data/asset scenes/reply.tscn")

onready var VIEWSIZE = get_viewport_rect().size
var dialogBox = {"width": 1000, "height": 60, "posx": 500, "posy": 370}

var npcName
var talkAnim = null
var npc

var numDialogueText = 0
var numReplies = 0
var pageIndex = 0
var replyContainer = []
var replyMouseover = "FALSE"
var replyCurrent = -1

var charData = {}

var mousePos = Vector3()

onready var screenBlur = $"../effects/blurfx"
onready var effectBlurUI = $"../effects/tween"

var talkAnimFrame

func _ready():
	set_process_input(true)
	
	#we use a temp cache to be able to override charData without actually overwriting it
	charData = global.charData
	
	for object in get_parent().get_node("npcs").get_children():
		object.connect("dialogue", self, "_talk_to")
		
func event_handler():
	if global.gameData.event.name == "Milk and cookies":
		if global.gameData.event.stage == 1:
			pass

func _input(event):
	if global.dialogue_running == true and replyMouseover == "FALSE":
		#TODO: This cycles through reply choices with W(ui_up) and S(ui_down) butno way of confirming selection yet
		if event.is_action_pressed("ui_down") and replyCurrent != numReplies-1:
			replyCurrent += 1
			for reply in replyContainer:
				var node = get_node(reply)
				node.add_color_override("font_color", Color(1,1,1))
			get_node(replyContainer[replyCurrent]).add_color_override("font_color", Color(1,0,1))
		if event.is_action_pressed("ui_up") and replyCurrent != 0:
			replyCurrent -= 1
			for reply in replyContainer:
				var node = get_node(reply)
				node.add_color_override("font_color", Color(1,1,1))
			get_node(replyContainer[replyCurrent]).add_color_override("font_color", Color(1,0,1))
		#TODO: not working like it should. Look over, old code.
		if event.is_action_pressed("ui_accept"):
			if replyCurrent != -1:
				if get_node(replyContainer[replyCurrent]).text == "exit dialogue":
					effectBlurUI.interpolate_property(screenBlur, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
					kill_dialogue()
				else:
					_pick_reply(replyCurrent)
			if pageIndex < numDialogueText-1:    
				pageIndex += 1
				start_dialogue(charData[npc]["dialogue"])
			if pageIndex < numDialogueText-1:    
				pageIndex += 1
				start_dialogue(charData[npc]["dialogue"])
			if pageIndex == numDialogueText-1 and numReplies == 0:
				kill_dialogue()
			
func _dialogue_clicked():
	if pageIndex < numDialogueText-1:    
		pageIndex += 1
		start_dialogue(charData[npc]["dialogue"])
	#if there are no replies - exit dialogue
	if pageIndex == numDialogueText-1 and numReplies == 0:
		global.dialogue_running = false
		kill_dialogue()

func _talk_to(identity, clickPos):
	mousePos = clickPos
	npc = identity
	global.blocking_ui = true
	effectBlurUI.interpolate_property(screenBlur, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	get_parent().get_node("ui").toggle_ui_icons("hide")
	#we use a temp cache to be able to override charData without actually overwriting it
	#TODO_ put the override here, uncomment conditional code
#	if global.eventOverride != npc:
	charData = global.charData
#	else:
#		charData = global.eventOverride[npc]
	if global.sceneData[global.currentLocation].has(global.weekday):
		if global.sceneData[global.currentLocation]["default"][global.timeofday]["actors"].has(npc):
			start_dialogue(global.sceneData[global.currentLocation][global.weekday][global.timeofday]["actors"][npc]["dialogue"])
	else:
		start_dialogue(charData[npc]["dialogue"])

func _pick_reply(n):
	replyCurrent =-1
	
	#if there is a variables array in json, update game variables
	if replies[n].has("variables"):
		for item in range(0, replies[n]["variables"].size()):
			var name = replies[n]["variables"][item]["name"]
			global.gameData[npc] = replies[n]["variables"][item]["value"]
			#if value is a float or an int, add to existing value
			if (typeof(replies[n]["variables"][item]["value"])) == 2:
				global.gameData[npc] += replies[n]["variables"][item]["value"]
			else:
				global.gameData[npc] = replies[n]["variables"][item]["value"]
			
	if replies[n].has("event"):
		
		var event_cached = global.load_json("res://data/events/" + replies[n]["event"][0]["id"] + ".json")

		var current_gameday = global.gameday
		var current_weekday = global.gameData["daycount"][global.weekday]
		var event_gameday
		var event_weekday
		var daysToAdd
			
		if event_cached["weekday"] != "same":
			event_weekday = global.gameData["daycount"][event_cached["weekday"]]
		else:
			event_weekday = current_gameday

		#what´s the day(weekday) of the event?
		if event_cached["weekday"] != "same":
			event_gameday = global.gameday + global.gameData["daycount"][event_cached["weekday"]] - current_weekday
		else:
			event_gameday = global.gameday
			
		#how many days until that day(weekday)?
		if event_gameday > current_gameday:
			daysToAdd = event_weekday - current_gameday
		elif event_gameday < current_gameday:
			daysToAdd = 7 - (current_gameday - event_weekday)

		var event_class = {"event": event_cached["event"], "type": event_cached["type"], "icon": event_cached["calendar"]["icon"]}

		global.eventData["date"][str(event_gameday)] = {"evening": ""}		
		global.eventData["date"][str(event_gameday)][event_cached["timeofday"]] = event_class

		print(global.eventData)
		
	#if there is a progress array in json, update game progression variables
	if replies[n].has("progress"):
		# TODO: if progress has a location - update global.sceneData override instead of charData
		print("we have progress!")
		for item in range(0, replies[n]["progress"].size()):
			var affected = replies[n]["progress"][item]["name"]
			
			# TODO: create function that goes though every scene affected is in and update dialogue. Or, can I make this simpler
			# use default dialogue more? For now, this works, so revisit at a later time, make better.
			if replies[n]["progress"][item].has("dialogue"):
				global.charData[affected]["dialogue"] = replies[n]["progress"][item]["dialogue"]
				global.sceneData[global.currentLocation]["default"][global.timeofday]["actors"][affected]["dialogue"] = replies[n]["progress"][item]["dialogue"]
				if global.sceneData[global.currentLocation].has(global.weekday):
					if global.sceneData[global.currentLocation][global.weekday][global.timeofday]["actors"].has(affected):
						global.sceneData[global.currentLocation][global.weekday][global.timeofday]["actors"][affected]["dialogue"] = replies[n]["progress"][item]["dialogue"]

			global.charData[affected]["branch"] = replies[n]["progress"][item]["branch"]
			
			print(global.charData[affected])
			print(global.sceneData[global.currentLocation]["default"][global.timeofday]["actors"][affected]["dialogue"])
				
	#if "exit" is "false" take value from "next" and start next dialogue
	if replies[n]["exit"] != "true":
		if replies[n]["next"].ends_with(".json"):
			if global.sceneData[global.currentLocation].has(global.weekday):
				if global.sceneData[global.currentLocation][global.weekday][global.timeofday]["actors"].has(npc):
					global.sceneData[global.currentLocation][global.weekday][global.timeofday]["actors"][npc]["dialogue"] = replies[n]["next"]
				else:
					global.charData[npc]["dialogue"] = replies[n]["next"]
			else:
				if global.sceneData[global.currentLocation]["default"][global.timeofday]["actors"].has(npc):
					global.sceneData[global.currentLocation]["default"][global.timeofday]["actors"][npc]["dialogue"] = replies[n]["next"]				
				else:
					global.charData[npc]["dialogue"] = replies[n]["next"]
			charData[npc]["dialogue"] = replies[n]["next"]
			pageIndex = 0
			start_dialogue("res://data/dialogue/" + charData[npc]["dialogue"]) + charData[npc]["relationship"] + (".json")
		else:
			# this might cause issues if location does not have current day. Need to account for "default"
			if global.sceneData[global.currentLocation].has(global.weekday):
				if global.sceneData[global.currentLocation][global.weekday][global.timeofday]["actors"].has(npc):
					global.sceneData[global.currentLocation][global.weekday][global.timeofday]["actors"][npc]["branch"] = replies[n]["next"]
				else:
					global.charData[npc]["branch"] = replies[n]["next"]
			else:
				if global.sceneData[global.currentLocation]["default"][global.timeofday]["actors"].has(npc):
					global.sceneData[global.currentLocation]["default"][global.timeofday]["actors"][npc]["branch"] = replies[n]["next"]
				else:
					global.charData[npc]["branch"] = replies[n]["next"]
					
			charData[npc]["branch"] = replies[n]["next"]
			pageIndex = 0
			start_dialogue(charData[npc]["dialogue"])
		
	
	#if "exit" is "true", kill dialogue
	else:
		pageIndex = 0
		
		if replies[n]["next"].ends_with(".json"):
			charData[npc]["dialogue"] = replies[n]["next"]
		else:
			charData[npc]["branch"] = replies[n]["next"]
			
		effectBlurUI.interpolate_property(screenBlur, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		global.dialogue_running = false
		kill_dialogue()
		global.blocking_ui = false
		global.sceneCol.disabled = false
		get_parent().get_node("ui").toggle_ui_icons("show")
		if replies[n].has("bubble"):
			get_parent().thought_bubble(replies[n]["bubble"])

func _reply_mouseover(mouseover, reply):
	if mouseover == "TRUE":
		replyMouseover = "TRUE"
		replyCurrent = reply
	elif mouseover == "FALSE":
		replyMouseover = "FALSE"
		replyCurrent = -1

func start_dialogue(json):

#	TODO: when calling a dialogue, call start_dialogue("ellie_date_0" + str(global.chardata["relationship"]) + ".json")
	global.dialogue_running = true
	talkData = global.load_json(json)
	
	branch = talkData["dialogue"][charData[npc]["branch"]]
	replies = talkData["dialogue"][charData[npc]["branch"]]["replies"]
	
	npcName = talkData["name"]
	
	if branch.has("avatar"):
		talkAnim = load(branch["avatar"])
		talkAnimFrame = branch["frame"]
	else:
		talkAnim = null

	numDialogueText = branch["speech"].size()
	
	#if branch has responses, check how many. If no responses, numReplies is 0
	if branch.has("replies"):
		numReplies = replies.size()
	else:
		#needed to add this otherwise paging didn´t work like it should
		replyMouseover = "FALSE"
		numReplies = 0
	
	#TODO: This condition decides if to open dialogue in window, or display dialogue over character heads. Low priority..
	if branch.has("window"):
		pass
		
	#TODO: This condition currently only handles exact values, needs to evaluate if value is above another value too (ex money)
	#0 is variable to check for
	#1 is value of variable, and if that variable corresponds to gameVars, set 2 as current dialogue
	#2 is target conversation (dialogue or branch)
	#this block of code check if a condition in gameVars is met, and changes dialogue accordingly if it is
	if branch.has("condition"):
		for item in branch["condition"]:
			if global.gameVars.has(branch["condition"][item][0]):
				if global.gameVars[branch["condition"][item][0]] == branch["condition"][item][1]:
					if branch["condition"][item][2].ends_with("json"):
						global.charData[talkData["name"]]["dialogue"] = branch["condition"][item][2]
					else:
						global.charData[talkData["name"]]["branch"] = branch["condition"][item][2]
	
	#setup dialog window
	setup_dialogue_window()
	
	#set text and reply in dialogue panel
	$"ui_dialogue/dialogue/name".set_text(npcName)
	
	#preparing for dialogue paging, the 0 will be replaced by ´n´, ´n´ being order of item in text array
	$"ui_dialogue/dialogue".set_text(branch["speech"][pageIndex])
	
	if pageIndex == numDialogueText-1 and numReplies > 0:
		for n in range(0,numReplies):
			replyContainer.push_back("ui_dialogue/reply" + str(n+1))
			get_node("ui_dialogue/reply" + str(n+1)).set_text(replies[n]["reply"])
		
func setup_dialogue_window():
		
	var reply_offset = 0
	var labels = ["panel","dialogue"]
	
	#add one element "reply" per number of replies in talkData
	for n in range(numReplies):
		labels.push_back("reply" + str(n+1))
	
	create_labels(labels)
	
	$"ui_dialogue/panel".set_size(Vector2(dialogBox.width, dialogBox.height + numReplies*30))
	$"ui_dialogue/panel".set_position(Vector2(VIEWSIZE.x/2 - dialogBox.width/2, VIEWSIZE.y - dialogBox.posy))
	$"ui_dialogue/panel".modulate.a = 0.5
	
	$"ui_dialogue/dialogue".set_size(Vector2(dialogBox.width -20, dialogBox.height + numReplies*30))
	$"ui_dialogue/dialogue".set_position(Vector2(VIEWSIZE.x/2 + 100 - dialogBox.width/2, VIEWSIZE.y - dialogBox.posy + 20))
	
	if pageIndex == numDialogueText-1 and numReplies > 0:
		for n in range(numReplies):
			get_node("ui_dialogue/reply" + str(n+1)).set_size(Vector2(400, 50))
			get_node("ui_dialogue/reply" + str(n+1)).set_position(Vector2(VIEWSIZE.x/2 +100 - dialogBox.width/2, VIEWSIZE.y - 300 + reply_offset))
			get_node("ui_dialogue/reply" + str(n+1)).num_reply = n
			reply_offset += 30
	
	#TODO: this should be set dynamically by the json dialogue file
	if talkAnim != null:
		talkAnim = talkAnim.instance()
		talkAnim.frame = talkAnimFrame
		talkAnim.set_scale(Vector2(0.7,0.7))
		talkAnim.set_position(Vector2(VIEWSIZE.x/2 - dialogBox.width/2, VIEWSIZE.y - dialogBox.posy + 10))
		$"ui_dialogue".add_child(talkAnim)

	reply_offset = 0
 
func create_labels(labels):
	kill_dialogue()
	for lbl in labels:
		if lbl == "panel":
			var node = Panel.new()
			node.set_name(lbl)
			$"ui_dialogue".add_child(node)
		if lbl == "dialogue":
			var node = dialogPanel.instance()
			node.set_name(lbl)
			node.connect("dialogueClicked", self, "_dialogue_clicked")
			$"ui_dialogue".add_child(node)
		if pageIndex == numDialogueText-1:
			if "reply" in lbl:
				var node = replyButton.instance()
				node.set_name(lbl)
				node.connect("reply_selected",self,"_pick_reply",[], CONNECT_ONESHOT)
				node.connect("reply_mouseover",self,"_reply_mouseover")
				$"ui_dialogue".add_child(node)

func kill_dialogue():
	for x in $"ui_dialogue/".get_children():
		x.set_name("DELETED") #to make sure node doesn´t cause issues before being deleted
		x.queue_free()
	replyContainer = []
	global.blocking_ui = false
