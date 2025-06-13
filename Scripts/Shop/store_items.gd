extends PanelContainer

signal item_but_pressed(id)

@onready var img = $HBoxContainer/MarginContainer/TextureRect
@onready var heading1 = $HBoxContainer/MarginContainer2/VBoxContainer/Label
@onready var heading2 = $HBoxContainer/MarginContainer2/VBoxContainer/Label2
@onready var button = $HBoxContainer/MarginContainer2/VBoxContainer/Button


var id : int

func _on_button_tree_exited() -> void:
	pass # Replace with function body.
	

func _on_button_pressed() -> void:
	pass # Replace with function body.
