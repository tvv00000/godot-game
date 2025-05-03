extends Control

@export var inventory_menu : Node

func resume():
	hide()
	get_tree().paused = false

func pause():
	get_tree().paused = true

func back_to_inventory():
	hide()
	inventory_menu.show()

func testTab():
	if Input.is_action_just_pressed('OpenInv'):
		if not get_tree().paused == false:
			pause()
		else:
			resume()

func _on_resume_pressed() -> void:
	resume()

func _on_inventory_pressed() -> void:
	back_to_inventory()

func _on_options_menu_pressed() -> void:
	pass

func _process(delta: float) -> void:
	testTab()

func _ready() -> void:
	hide()
