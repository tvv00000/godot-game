extends Control

@onready var inventory_menu = $"../PauseMenu"
@onready var Settings = $"../SettingsMenu"


func _ready() -> void:
	hide()


func _on_resume_pressed() -> void:
	hide()
	inventory_menu.show()


func _on_options_menu_pressed() -> void:
	hide()
	Settings.show()


func _on_resume_2_pressed() -> void:
	OS.alert('Pole veel', 'alert')


func _on_resume_3_pressed() -> void:
	OS.alert('Pole veel', 'alert')


func _on_resume_4_pressed() -> void:
	get_tree().quit()
