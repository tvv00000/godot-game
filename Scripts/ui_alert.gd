extends Node

var alert_label: Label = null
func show_alert(text: String):
	if alert_label:
		alert_label.text = text
		alert_label.visible = true
		alert_label.modulate.a = 1.0
		var tween = create_tween()
		tween.tween_property(alert_label, "modulate:a", 0.0, 2.0)
		tween.tween_callback(Callable(alert_label, "hide"))
