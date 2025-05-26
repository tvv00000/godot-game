extends Control

@onready var inventory_menu = $"../PauseMenu"
@onready var Settings = $"../SettingsMenu"


func _ready() -> void:
	hide()


func _on_resume_pressed() -> void:
	hide()
	inventory_menu.resume()


func _on_inventory_pressed() -> void:
	hide()
	inventory_menu.show()


func _on_options_menu_pressed() -> void:
	hide()
	Settings.show()
