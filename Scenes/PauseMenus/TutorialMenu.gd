extends Control

@onready var tutorialText = $TextureRect/VBoxContainer/TutorialText

func _ready():
	hide()

func show_tutorial(msg: String):
	tutorialText.text = msg
	show()

func _on_tutorial_exit_btn_pressed() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("Move_Jump"):
		hide()
