extends Control

func _ready():
	print_tree()
	var player = get_node("/root/Root/Player")
	if player:
		player.connect("money_collected", Callable(self, "_on_money_collected"))
	else:
		print("Player node not found!")

func _on_money_collected(amount_added, new_total):
	var label = get_node("Panel2/MoneyLabel2")  # If MoneyLabel is directly under MoneyUI node
	if label:
		label.text = "%d" % new_total
	else:
		print("MoneyLabel node not found!")
