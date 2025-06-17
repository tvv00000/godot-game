extends PanelContainer

signal item_buy_pressed(id)

@onready var img = $HBoxContainer/MarginContainer/TextureRect
@onready var heading1 = $HBoxContainer/MarginContainer2/VBoxContainer/Label
@onready var heading2 = $HBoxContainer/MarginContainer2/VBoxContainer/Label2
@onready var button = $HBoxContainer/MarginContainer2/VBoxContainer/Button

var id : int

func _on_button_tree_exited() -> void:
	pass # Replace with function body.
	


func setup(data: Dictionary, p_id: int) -> void:
	img.texture = load(data.get('icon_path'))
	heading1.text = data.get('heading_1', '')
	heading2.text = data.get('heading_2', '')
	id = p_id
	
	if data.get('custom_button_text'):
		button.text = data.get('custom_button_text')

func _on_button_pressed() -> void:
	emit_signal('item_buy_pressed', id)
	
