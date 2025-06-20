extends Control
#TODO: ühenda muld ka planteriga ja salvesta
#TODO: exit nupud menüüdele

#0 = muld, 1 = istuta, 2 = hoolda. Sama mis garden gamemode. 3 (kui vaja) = ainult hud
var uiState: int = 0
var dirtRatio: int = 0
var fillLevel: int = 0

signal dirtFilled_Signal(dirtLevel: int)
signal plantPlanted(plant: Resource)
signal uprootPlant()
#see signaal annab teada kas 0) taaime kasteti, 1) taime väetati
signal plantCare(careType: int)
signal movementEnabled()

func _ready() -> void:
	setUiState(3)


#see funk laseb sul klikkida ühel või teisel nupul ja sellega määrata ära palju mulda või kruusa soovid
#potti. Kui pott saab täis läheb automaatselt state 2 peale. 
func setDirtratio(pressed):
	fillLevel += 10
	if pressed == "dirt":
		dirtRatio += 10

	#print("täidetud on: ", fillLevel, "% ja ratio on: ", dirtRatio, "%")
	$"DirtUI/ScreenContainer/ButtonContainer/VBoxContainer/GravelLabel".set_text("Kruusa On: {gravel}".format({"gravel": (fillLevel - dirtRatio)}))
	$"DirtUI/ScreenContainer/ButtonContainer/VBoxContainer/DirtLabel".set_text("Mulda On: {dirt}".format({"dirt": dirtRatio}))
	$DirtUI/ScreenContainer/ButtonContainer/VBoxContainer/PotLabel.set_text("Pott on täidetud {fillLevel}%".format({"fillLevel": fillLevel}))
	if fillLevel == 100:
		
		print("muld täis, saadetud signaal to interaction_area: dirtFilled_Signal", dirtRatio)
		Global.planterDirtRatio = dirtRatio
		dirtFilled_Signal.emit(dirtRatio)
		#resetib ui
		dirtRatio = 0
		fillLevel = 0
		setUiState(3)

#0 = muld, 1 = istuta, 2 = hoolda. Sama mis garden gamemode. 3  = ainult hud
func setUiState(inputState):
	if inputState == 0:
	#dirtstate
		uiState = 0
		
		$CareUI.hide()
		$PlantUI.hide()
		$DirtUI.show()
		
		#update dirt labels
		$"DirtUI/ScreenContainer/ButtonContainer/VBoxContainer/GravelLabel".set_text("Kruusa On: {gravel}".format({"gravel": (fillLevel - dirtRatio)}))
		$"DirtUI/ScreenContainer/ButtonContainer/VBoxContainer/DirtLabel".set_text("Mulda On: {dirt}".format({"dirt": dirtRatio}))
		$DirtUI/ScreenContainer/ButtonContainer/VBoxContainer/PotLabel.set_text("Pott on täidetud {fillLevel}%".format({"fillLevel": fillLevel}))
		
	elif inputState == 1:
	#plantstate
		uiState = 1

		$CareUI.hide()
		$DirtUI.hide()
		$PlantUI.show()
	elif inputState == 2:
	#careState
		uiState = 2
		
		$DirtUI.hide()
		$PlantUI.hide()
		$CareUI.show()
	
	elif inputState == 3:
	#only hud
		uiState = 3
		$DirtUI.hide()
		$PlantUI.hide()
		$CareUI.hide()
		$DateTime.show()
		Global.isInteracting = false


#Mulla paneku nupud. Kutsuvad esile lihtsalt setDirtRatio funki. 
func _on_dirt_button_pressed() -> void:
		setDirtratio("dirt")
		
func _on_gravel_button_pressed() -> void:
		setDirtratio("gravel")

#Signaal mis tuleb interactionArealt mis ütleb, mis akent avada.

#SulgeAken.
func _on_close_plant_button_pressed() -> void:
	setUiState(3)

#Saadab välja tüümiani taime istutamise signaali.
func _on_thyme_button_pressed() -> void:
	var plantResourcePath: String = "res://Scripts/Plants/Plants/Tüümian.tres"
	emit_signal("plantPlanted", plantResourcePath)
	setUiState(3)
	
	print("Saadetud signaal: Istuta taim ", plantResourcePath)
	
func _on_uproot_button_pressed() -> void:
	setUiState(3)
	#print("Saadetud signaal: delet plant")
	emit_signal("uprootPlant")

func _on_interaction_area_show_garden_ui(state: int, plantName: String, dirtLevel: int, moistureLevel: int, fertilizerLevel: int, plantGrowth: int, plantHealth: int) -> void:
	prints("GardenUI sai Signaali showGardenUI state:", state, plantName, dirtLevel, moistureLevel, fertilizerLevel, plantGrowth, plantHealth)
	if plantName != "null":
		$"CareUI/DirtUI BG/HBoxContainer/VBoxContainer/Plantname".set_text(plantName)
	setUiState(state)
	if state > 0:
		$"CareUI/DirtUI BG/HBoxContainer/VBoxContainer/Plantname".set_text(plantName)
		$"PlantUI/DirtUI BG/HBoxContainer/PotStatusContainer/DirtLabel".set_text("Mulda On: {dirt}".format({"dirt": dirtLevel}))
		$"PlantUI/DirtUI BG/HBoxContainer/PotStatusContainer/GravelLabel".set_text("Kruusa On: {gravel}".format({"gravel": (100 - dirtLevel)}))
		$"CareUI/DirtUI BG/HBoxContainer/VBoxContainer/MoistureLabel".set_text(str(moistureLevel))
		$"CareUI/DirtUI BG/HBoxContainer/VBoxContainer/FertLabel".set_text(str(fertilizerLevel))
		$"CareUI/DirtUI BG/HBoxContainer/VBoxContainer/GrowthLabel".set_text(str(plantGrowth))
		$"CareUI/DirtUI BG/HBoxContainer/VBoxContainer/HealthLabel".set_text(str(plantHealth))


func _on_wateringButton_pressed() -> void:
	emit_signal("plantCare" ,0)
	$"CareUI/DirtUI BG/HBoxContainer/VBoxContainer/MoistureLabel".set_text(str(100))


func _on_fertilize_button_pressed() -> void:
	emit_signal("plantCare", 1)
	$"CareUI/DirtUI BG/HBoxContainer/VBoxContainer/FertLabel".set_text(str(100))
	
func _process(delta: float) -> void:
	$DateTime/timeContainer/dayLabel.set_text("Päev: {day}".format({"day":Global.day+1}))
	$DateTime/timeContainer/seasonLabel.set_text("Hooaeg: {season}".format({"season":Global.season+1}))
