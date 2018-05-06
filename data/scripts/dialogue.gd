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
	if replyMouseover == "FALSE":
		if event.is_action_pressed("ui_down") and replyCurrent != numReplies-1:
			replyCurrent += 1
			for reply in replyContainer:
				get_node(reply).add_color_override("font_color", Color(1,1,1))
			get_node(replyContainer[replyCurrent]).add_color_override("font_color", Color(1,0,1))
		if event.is_action_pressed("ui_up") and replyCurrent != 0:
			replyCurrent -= 1
			for reply in replyContainer:
				get_node(reply).add_color_override("font_color", Color(1,1,1))
			get_node(replyContainer[replyCurrent]).add_color_override("font_color", Color(1,0,1))
		if event.is_action_pressed("ui_exit"):
			if replyCurrent != -1:
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
	if pageIndex == numDialogueText-1 and numReplies == 0:
		kill_dialogue()

func _talk_to(identity, clickPos):
	mousePos = clickPos
	npc = identity
	global.blocking_ui = true
	get_parent().get_node("effects/blurfx").show()
	get_parent().toggle_ui_icons("hide")
	#we use a temp cache to be able to override charData without actually overwriting it
	#TODO_ put the override here, uncomment conditional code
#	if global.eventOverride != npc:
	charData = global.charData
#	else:
#		charData = global.eventOverride[npc]
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
		#what´s today(weekday)?
		#what´s the day(weekday) of the event?
		#how many days until that day(weekday)?
		#add that number to global.gameData["day"]
		#add:
		var weekDayNum = {"monday": 1, "tuesday": 2, "wednesday": 3, "thursday": 4, "friday": 5, "saturday": 6, "sunday": 7}
		
		var currentDay = weekDayNum[global.gameData["weekday"][global.weekday]]
		var eventDay = weekDayNum[replies[n]["event"]["eventDay"]]
		
		var daysToAdd = currentDay - 7 + eventDay
		
		eventDay = global.gameday + daysToAdd

		global.eventData["date"][eventDay]["weekday"] = replies[n]["event"]["eventDay"]
		global.eventData["date"][eventDay]["time"] = replies[n]["event"]["eventTOD"]
		global.eventData["date"][eventDay]["name"] = replies[n]["event"]["name"]
		global.eventData["date"][eventDay]["fail"]["noshow"] = replies[n]["event"]["noshow"]
		global.eventData["date"][eventDay]["fail"]["cancel"] = replies[n]["event"]["cancel"]
		
	#if there is a progression array in json, update game progression variables
	if replies[n].has("progress"):
		for item in range(0, replies[n]["progress"].size()):
			var affected = replies[n]["progress"][item]["name"]
			if replies[n]["progress"][item]["next"].ends_with("json"):
				global.charData[affected]["dialogue"] = replies[n]["progress"][item]["next"]
			else:
				global.charData[affected]["branch"] = replies[n]["progress"][item]["next"]
	
	#if "exit" is "false" take value from "next" and start next dialogue
	if replies[n]["exit"] != "true":
		charData[npc]["branch"] = replies[n]["next"]
		pageIndex = 0
		start_dialogue(charData[npc]["dialogue"])
	
	#if "exit" is "true", kill dialogue
	else:
		pageIndex = 0
		charData[npc]["branch"] = replies[n]["next"]
		get_parent().get_node("effects/blurfx").hide()
		kill_dialogue()
		get_parent().toggle_ui_icons("show")

func _reply_mouseover(mouseover, reply):
	if mouseover == "TRUE":
		replyMouseover = "TRUE"
		replyCurrent = reply
	elif mouseover == "FALSE":
		replyMouseover = "FALSE"
		replyCurrent = -1

func start_dialogue(json):
	talkData = global.load_json(json)
	
	branch = talkData["dialogue"][charData[npc]["branch"]]
	replies = talkData["dialogue"][charData[npc]["branch"]]["replies"]
	
	npcName = talkData["name"]
	
	if branch.has("animation"):
		talkAnim = load(branch["animation"])
	else:
		talkAnim = null

	numDialogueText = branch["text"].size()
	
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
	get_node("ui_dialogue/dialogue/name").set_text(npcName)
	
	#preparing for dialogue paging, the 0 will be replaced by ´n´, ´n´ being order of item in text array
	get_node("ui_dialogue/dialogue").set_text(branch["text"][pageIndex])
	
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
	
	get_node("ui_dialogue/panel").set_size(Vector2(dialogBox.width, dialogBox.height + numReplies*30))
	get_node("ui_dialogue/panel").set_position(Vector2(VIEWSIZE.x/2 - dialogBox.width/2, VIEWSIZE.y - dialogBox.posy))
	get_node("ui_dialogue/panel").modulate.a = 0.5
	
	get_node("ui_dialogue/dialogue").set_size(Vector2(dialogBox.width -20, dialogBox.height + numReplies*30))
	get_node("ui_dialogue/dialogue").set_position(Vector2(VIEWSIZE.x/2 + 100 - dialogBox.width/2, VIEWSIZE.y - dialogBox.posy + 20))
	
	if pageIndex == numDialogueText-1 and numReplies > 0:
		for n in range(numReplies):
			get_node("ui_dialogue/reply" + str(n+1)).set_size(Vector2(400, 50))
			get_node("ui_dialogue/reply" + str(n+1)).set_position(Vector2(VIEWSIZE.x/2 +100 - dialogBox.width/2, VIEWSIZE.y - 300 + reply_offset))
			get_node("ui_dialogue/reply" + str(n+1)).num_reply = n
			reply_offset += 30
	
	#TODO: this should be set dynamically by the json dialogue file
	if talkAnim != null:
		talkAnim = talkAnim.instance()
		talkAnim.set_scale(Vector2(1.5,1.5))
		talkAnim.set_position(Vector2(VIEWSIZE.x/2 + 40 - dialogBox.width/2, VIEWSIZE.y - dialogBox.posy + 20))
		get_node("ui_dialogue").add_child(talkAnim)

	reply_offset = 0
 
func create_labels(labels):
	kill_dialogue()
	for lbl in labels:
		if lbl == "panel":
			var node = Panel.new()
			node.set_name(lbl)
			get_node("ui_dialogue").add_child(node)
		if lbl == "dialogue":
			var node = dialogPanel.instance()
			node.set_name(lbl)
			node.connect("dialogueClicked", self, "_dialogue_clicked")
			get_node("ui_dialogue").add_child(node)
		if pageIndex == numDialogueText-1:
			if "reply" in lbl:
				var node = replyButton.instance()
				node.set_name(lbl)
				node.connect("reply_selected",self,"_pick_reply",[], CONNECT_ONESHOT)
				node.connect("reply_mouseover",self,"_reply_mouseover")
				get_node("ui_dialogue").add_child(node)

func kill_dialogue():
	for x in get_node("ui_dialogue/").get_children():
		x.set_name("DELETED") #to make sure node doesn´t cause issues before being deleted
		x.queue_free()
	replyContainer = []
	global.blocking_ui = false
