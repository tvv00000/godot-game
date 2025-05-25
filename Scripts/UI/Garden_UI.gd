extends Control
#TODO: ühenda muld ka planteriga ja salvesta
#TODO: exit nupud menüüdele

#0 = muld, 1 = istuta, 2 = hoolda. Sama mis garden gamemode. 3 (kui vaja) = ainult hud
var uiState: int = 0
var dirtRatio: int = 0
var fillLevel: int = 0

signal dirtFilled_Signal(dirtLevel: int)

signal plantPlanted(plant: Resource)

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
		setUiState(1)

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


#Mulla paneku nupud. Kutsuvad esile lihtsalt setDirtRatio funki. 
func _on_dirt_button_pressed() -> void:
		setDirtratio("dirt")
		
func _on_gravel_button_pressed() -> void:
		setDirtratio("gravel")

func _ready() -> void:
	setUiState(3)

#Signaal mis tuleb interactionArealt mis ütleb, mis akent avada.

#SulgeAken.
func _on_close_plant_button_pressed() -> void:
	setUiState(3)

#Saadab välja tüümiani taime istutamise signaali.
func _on_thyme_button_pressed() -> void:
	var plantResourcePath: String = "res://Resources/Plants/R_Plant_Thyme.tres"
	emit_signal("plantPlanted", plantResourcePath)
	setUiState(3)
	print("Saadetud signaal: Istuta taim ", plantResourcePath)


func _on_interaction_area_show_garden_ui(state: int, plantName: String) -> void:
	print("GardenUI sai Signaali showGardenUI state:", state, plantName)
	if plantName != "null":
		$"CareUI/DirtUI BG/HBoxContainer/VBoxContainer/Plantname".set_text(plantName)
	setUiState(state)
