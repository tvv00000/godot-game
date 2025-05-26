extends Control

@onready var inventory_menu = $"../PauseMenu"
@onready var Settings = $"../SettingsMenu"


func _ready() -> void:
	hide()


func _on_resume_pressed() -> void:
	hide()
	inventory_menu.resume()

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_graafika_pressed() -> void:
	OS.alert('Pole veel', 'alert')


func _on_heli_pressed() -> void:
	OS.alert('Pole veel', 'alert')
