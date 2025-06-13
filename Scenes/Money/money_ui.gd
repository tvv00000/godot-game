extends Control

func _ready():
	var player = get_node("/root/Root/Player")
	if player:
		player.connect("money_collected", Callable(self, "_on_money_collected"))
	else:
		print("Player node not found!")

func _on_money_collected(amount_added, new_total):
	var label = get_node("MoneyPanel/MoneyLabel")
	if label:
		label.text = "%d" % new_total
	else:
		print("MoneyLabel node not found!")
