extends Control
@onready var inventory_menu = $"../PauseMenu"
@onready var settingsSettings = $"../SettingsSettings"
func _ready() -> void:
	hide()


func _on_resume_pressed() -> void:
	hide()
	inventory_menu.show()

func _on_heli_pressed() -> void:
	hide()
	settingsSettings.show()


func _on_quit_pressed() -> void:
	get_tree().quit()
