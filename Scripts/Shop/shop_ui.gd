extends Control

@onready var grid: GridContainer = $ScrollContainer/GridContainer
@export var store_item: PackedScene

var store_item_id: int = 0
var store_data: Array = [
	{
		'item_tres': "res://Scenes/Inventory/items/aug.tres",
		'icon_path': "res://Art/Sprites/Items/aug.png",
		'heading_1': 'Aug',
		'heading_2': 'Kala',
		'custom_button_text': '2'
	},{
		'item_tres': "res://Scenes/Inventory/items/item_Soil.tres",
		'icon_path': "res://Art/Sprites/Items/mullahunnik.png",
		'heading_1': 'Muld',
		'heading_2': 'Seda läheb vaja',
		'custom_button_text': '1'
	},{
		'item_tres': "res://Scenes/Inventory/items/seemned.tres",
		'icon_path': "res://Art/Sprites/Items/seemned.png",
		'heading_1': 'Seemned',
		'heading_2': 'Seda läheb vaja',
		'custom_button_text': '1'
	}
]

func _ready() -> void:
	hide()
	store_setup()

func store_setup() -> void:
	for data in store_data:
		var temp = store_item.instantiate()
		temp.item_buy_pressed.connect(on_item_buy_pressed)
		grid.add_child(temp)
		temp.setup(data, store_item_id)
		store_item_id += 1

func on_item_buy_pressed(id: int) -> void:
	print(store_data[id].get('heading_1') + ' ostis')

	# Get the path to the .tres file from store_data
	var item_tres_path = store_data[id].get('item_tres')

	# Load the InvItem resource using the path
	var item_tres = load(item_tres_path)  # Load the InvItem resource from the path

	# Check if the loaded resource is a valid InvItem
	if item_tres is InvItem:
		# Create an instance of the InvItem by duplicating the resource
		var inv_item = item_tres

		# Add the item to the player's inventory
		Global.player.inventory.insert(item_tres, 1)
		print("Item added to inventory: ", inv_item.name)
	else:
		print("Failed to load the item resource: ", item_tres_path)

signal shop_ui_open
signal shop_ui_closed

func open():
	show()
	emit_signal("shop_ui_open")

func close():
	hide()
	emit_signal("shop_ui_closed")
	Global.isInteracting = false



func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		close()


func _on_button_pressed() -> void:
	close()
