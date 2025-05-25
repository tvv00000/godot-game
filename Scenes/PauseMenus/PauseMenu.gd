extends Control

@onready var plant_index_menu = $"../PlantIndexMenu"
@onready var Settings = $"../SettingsMenu"

func resume():
	get_tree().paused = false
	hide()

func pause():
	get_tree().paused = true
	show()

func testTab():
	if Input.is_action_just_pressed('OpenInv') and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed('OpenInv') and get_tree().paused == true:
		resume()

func _on_resume_pressed() -> void:
	resume()

func _on_plant_index_pressed() -> void:
	hide()
	plant_index_menu.show()

func _on_options_menu_pressed() -> void:
	hide()
	Settings.show()

func _process(delta: float) -> void:
	testTab()

func _ready() -> void:
	hide()
	resume()
