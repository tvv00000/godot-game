extends CanvasLayer

@onready var pickup_label = $PickupLabel
var camera: Camera3D

#popup, mis ilmub itemi ylesvotmisel
func item_pickup(position_3d: Vector3, message: String):
	var screen_pos = Global.player.get_node("Pivot_Camera/Camera3D").unproject_position(position_3d)
	pickup_label.text = message
	pickup_label.global_position = screen_pos + Vector2(0, -30)
	pickup_label.visible = true	
	pickup_label.modulate.a = 1.0
	var tween := create_tween()
	tween.tween_property(pickup_label, "modulate:a", 0.0, 2.0)
	tween.tween_callback(Callable(pickup_label, "hide"))
	print("item pickup")
