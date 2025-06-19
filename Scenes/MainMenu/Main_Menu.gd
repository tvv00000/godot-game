extends Control
@onready var hoverSfx = $HoverSfx
@onready var clickSfx = $ClickSfx

func _on_StartGame_pressed() -> void:
	clickSfx.play()
	get_tree().change_scene_to_file("res://Scenes/Levels/Garden/Garden.tscn")


func _on_Settings_pressed() -> void:
	clickSfx.play()
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainSettings.tscn")
	
func _on_Exit_pressed() -> void:
	clickSfx.play()
	get_tree().quit()



func _on_play_mouse_entered() -> void:
	hoverSfx.play()


func _on_settings_mouse_entered() -> void:
	hoverSfx.play()


func _on_exit_mouse_entered() -> void:
	hoverSfx.play()
