extends Control

@onready var tutorialText = $TextureRect/VBoxContainer/TutorialText

func _ready():
	hide()

func show_tutorial(msg: String):
	tutorialText.text = msg
	show()

func _on_tutorial_exit_btn_pressed() -> void:
	hide()
