extends Area2D

var current_month = []
onready var calendar_node = load("res://data/asset scenes/calendar_node.tscn")
onready var header_node = load("res://data/asset scenes/header_node.tscn")

func _ready():
	$lbl_month.set_text(global.gameData.month[global.month])
	print("start day is: " + str(global.month*30-30+1))
	var offsetY = 0
	var offsetX = 0
	var offsetDay = int(global.gameData["daycount"][global.weekday])
	var new_week = 0
	var event_label

	for i in range(7):
		offsetX = i*165
		var node = header_node.instance()
		node.set_name(global.gameData["weekday"][i])
		node.set_position(Vector2(100 + offsetX,30 + offsetY))
		self.add_child(node)
		get_node(global.gameData["weekday"][i] +"/label").set_text(global.gameData["weekday"][i])
		print(get_node(global.gameData["weekday"][i]).name)
		
	for i in range(35):
		event_label = ""
		if i > offsetDay-2 and i<35-offsetDay:
			if global.eventData["date"].has(str(i-(offsetDay-2))):
				current_month.push_back("event")
				event_label = global.eventData["date"][str(i-(offsetDay-2))][0]["evening"]["event"]
#				current_month[i-1] = "event"
			else:
				current_month.push_back("blank")
				event_label = "blank"
#				current_month[i-1] = "blank"
		offsetX = i*165 - new_week
		var node = calendar_node.instance()
		node.set_name(str(i))
		node.set_position(Vector2(100 + offsetX,130 + offsetY))
		self.add_child(node)
		get_node(str(i)+"/label").set_text(event_label)
		
		if i==6 or i==13 or i==20 or i==27:
			offsetY += 155
			new_week += 1155
		
	print(current_month)
	print(self.get_children())

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
