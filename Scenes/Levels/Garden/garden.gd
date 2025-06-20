extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Global.firstPlay:
		$Player/HUD/WorldMapUi.load_scene()
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
