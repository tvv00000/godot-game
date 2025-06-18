extends Control

func _ready():
	var player = $"../.."
	if player:
		player.connect("money_collected", Callable(self, "_on_money_collected"))
	else:
		print("Player node not found!")

func _on_money_collected(_amount_added, new_total):
	var label = get_node("Panel2/MoneyLabel2")
	if label:
		label.text = "%d" % new_total
	else:
		print("MoneyLabel node not found!")
