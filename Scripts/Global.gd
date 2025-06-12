### Global.gd

extends Node

var player: Node = null

#Kasvatamine
var planterDirtRatio: int = 0

var inv_ui
var camera
var inventory

var last_teleport_scene: String = ""

var last_loss_reason: String = ""
