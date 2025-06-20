extends Control
#TODO ADD CLOSE BTN = EASY
@onready var plant_list = $PlantList
@onready var icon = $DetailPanel/Icon
@onready var name_label = $DetailPanel/NameLabel
@onready var desc_label = $DetailPanel/DescriptionLabel
@onready var detail_panel = $DetailPanel

#Connect and hide
func _ready():
	refresh_list()
	plant_list.item_selected.connect(_on_plant_selected)
	detail_panel.hide()

# Update and set info
func refresh_list():
	plant_list.clear()
	#testing
	print("Refreshing list. Number of plants: ", CollectionManager.plants.size())
	for plant in CollectionManager.plants:
		var entry = plant.name
		if plant.is_collected:
			entry += " (OLEMAS)"
		elif plant.is_discovered:
			entry += " (AVASTATUD)"
		else:
			entry = "???"
		plant_list.add_item(entry)

# Plant select
func _on_plant_selected(index):
	var plant = CollectionManager.plants[index]

	if plant.is_discovered:
		detail_panel.show()
		icon.texture = plant.icon
		name_label.text = plant.name
		desc_label.text = plant.description
	else:
		detail_panel.show()
		icon.texture = null
		name_label.text = "???"
		desc_label.clear()
		desc_label.append_text("Sa pole seda taime veel avastanud.")
