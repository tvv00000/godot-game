extends Control

@onready var grid: GridContainer = $ScrollContainer/GridContainer
@export var store_item: PackedScene

var store_item_id: int = 0

var store_data: Array = [
	{
		'icon_path': 'res://icon.svg',
		'heading_1': 'yo mama',
		'heading_2': 'mingi asi, vist, mdeagi tegelt.',
		'custom_button_text': '10 coins'
	},{
		'icon_path': 'res://icon.svg',
		'heading_1': 'yo papa',
		'heading_2': 'dad?',
		'custom_button_text': '15 coins'
	},{
		'icon_path': 'res://icon.svg',
		'heading_1': 'Oskar',
		'heading_2': 'Sigma',
		'custom_button_text': '999999999999999 coins'
	}
]

func _ready() -> void:
	#hide()
	store_setup()

func store_setup() -> void:
	for data in store_data:
		var temp = store_item.instantiate()
		temp.item_buy_pressed.connect(on_item_buy_pressed)
		grid.add_child(temp)
		temp.setup(data, store_item_id)
		store_item_id += 1

func on_item_buy_pressed(id: int) -> void:
	print(store_data[id].get('heading_1')+' ostis')


#var can_move:bool = true
###delete later?
#signal shop_ui_open
#signal shop_ui_closed
#
#func open():
	#show()
	#can_move = false
	#emit_signal("shop_ui_open")
#
#func close():
	#hide()
	#can_move = true
	#emit_signal("shop_ui_closed")
#
#func _unhandled_input(event):
	#if event.is_action_pressed("ui_cancel"):
		#close()
