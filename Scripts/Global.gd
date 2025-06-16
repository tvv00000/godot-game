### Global.gd

extends Node

var player: Node = null

#Kasvatamine
var planterDirtRatio: int = 0

var inv_ui
var camera
var inventory
var inv_item
var last_teleport_scene: String = ""

var quest_ui

var last_loss_reason: String = ""
