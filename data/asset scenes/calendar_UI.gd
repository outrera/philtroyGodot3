extends Area2D

var current_month = []
onready var calendar_node = load("res://data/asset scenes/calendar_node.tscn")

func _ready():
	$lbl_month.set_text(global.gameData.month[global.month])
	print("start day is: " + str(global.month*30-30+1))
	var offsetY = 0
	var offsetX = 0
	var new_week = 0
	var event_label

	for i in range(30):
		if global.eventData["date"].has(str(i+1)):
			current_month.push_back("event")
			event_label = "event"
#			current_month[i-1] = "event"
		else:
			current_month.push_back("blank")
			event_label = "blank"
#			current_month[i-1] = "blank"
		if i==7 or i==14 or i==21 or i==28:
			offsetY += 155
			new_week += 1155
		offsetX = i*165 - new_week
		var node = calendar_node.instance()
		node.set_name(str(i))
		node.set_position(Vector2(100 + offsetX,130 + offsetY))
		self.add_child(node)
		get_node(str(i)+"/label").set_text(event_label)
	print(current_month)
	print(self.get_children())

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
