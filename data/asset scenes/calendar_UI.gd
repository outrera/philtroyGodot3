extends Area2D

var current_month = []
onready var calendar_node = load("res://data/asset scenes/calendar_node.tscn")
onready var header_node = load("res://data/asset scenes/header_node.tscn")

func _ready():
	$lbl_month.set_text(global.gameData.month[global.month])
#	print("start day is: " + str(global.month*30-30+1))
	var offsetY = 0
	var offsetX = 0
	var offsetDay = int(global.gameData["daycount"][global.weekday])
	var new_week = 0
	var event_label

	#setup the calendar header (monday, tuesday....)
	for i in range(7):
		offsetX = i*165
		var node = header_node.instance()
		node.set_name(global.gameData["weekday"][i])
		node.set_position(Vector2(125 + offsetX,85 + offsetY))
		$nodes.add_child(node)
		get_node("nodes/" + global.gameData["weekday"][i] +"/label").set_text(global.gameData["weekday"][i])
#		print(get_node(global.gameData["weekday"][i]).name)
	
	#setup the calendar cells (where days and events are displayed)
	for i in range(35):
		event_label = ""
		offsetX = i*165 - new_week
		
		var node = calendar_node.instance()
		node.set_name(str(i))
		node.set_position(Vector2(125 + offsetX,130 + offsetY))
		$nodes.add_child(node)
		
		if i > offsetDay-2 and i<30 + offsetDay - 1:
			if global.eventData["date"].has(str(i-(offsetDay-2))):
				var date = global.eventData["date"][str(i-(offsetDay-2))][0]["evening"]
				current_month.push_back("event")
				event_label = date["event"]
#				current_month[i-1] = "event"
				var icon = Sprite.new()
				var texture = load("res://data/graphics/" + date.icon)
				icon.set_position(Vector2(200 + offsetX,200 + offsetY))
				icon.set_scale(Vector2(0.5, 0.5))
				icon. set_texture(texture)
				$nodes.add_child(icon)
			else:
				current_month.push_back("blank")
				event_label = ""
#				current_month[i-1] = "blank"
		
		if (i - (offsetDay-2)) > 0 and (i - (offsetDay-2)) < 31:
			get_node("nodes/"+str(i)+"/label_day").set_text(str(i - (offsetDay-2)))
#			get_node("nodes/"+str(i)+"/label_event").set_text(event_label)
		#this is just to test the color override. TODO: need to figure out how to check if calendar day is the same as global.gameDay
		if global.day == i - (offsetDay-2):
			get_node("nodes/"+str(i)+"/label_day").add_color_override("font_color", Color(1,0,0,1))
#		print(global.day)
#		print(i - (offsetDay-2))
		if i==6 or i==13 or i==20 or i==27:
			offsetY += 155
			new_week += 1155
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
