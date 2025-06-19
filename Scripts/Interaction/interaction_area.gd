extends Area3D

@onready var InteractionLabel: Label3D = $InteractLabel
#See on mängija küljes olev jubin, mis uurib kas ümber on näpitavaid asju, sorteerib neid järjekorda ja lubab interactida.

@onready var tutorial_menu = $"../HUD/TutorialMenu"
@onready var tutorial_text = $"../HUD/TutorialMenu/TextureRect/VBoxContainer/TutorialText"

#SETUP: 1. veendu et interactable object oleks staticbody3d
		#2. lisa talle "var interactLabel: String = "tekst mida kuvatakse kui tahad interaktida"


var interactablesInRange := []
var selectedInteractable: StaticBody3D = null
signal show_GardenUI(state: int, plantName: String)
signal movementDisabled()
var seeds: Resource

func _ready():
	InteractionLabel.hide()
	seeds  = load("res://Scenes/Inventory/items/seemned.tres")

#See sorteerib lähedal olevad interactabled ja valib listist lähima objekti, kui array on suurem kui 1.
func updateInteractables():
	#if elif else oli vajalik sest ta mudu tahtis kräshu bäšhu teha rangest väljudes
	if interactablesInRange.size() > 1:
		interactablesInRange.sort_custom(sortNearest)
		interactableSelector()
			
	elif interactablesInRange.size() == 1:
		interactableSelector()
		
	else:
		InteractionLabel.hide()
		InteractionLabel.hide()
		selectedInteractable = null

#siin tehakse näpitava valimise toimingud.
func interactableSelector():
	selectedInteractable = interactablesInRange[0] 
	InteractionLabel.set_text(selectedInteractable.interactLabel) 
	InteractionLabel.text = selectedInteractable.interactLabel
	print(selectedInteractable.interactLabel)
	InteractionLabel.show()

#Sortmeetod mis annab true/false sõltuvalt sellest kas interactable1 on lähemal kui interactable2
func sortNearest(body1, body2):
	var body1_distance = global_position.distance_to(body1.global_position)
	var body2_distance = global_position.distance_to(body2.global_position)
	return body1_distance < body2_distance

#need alumised kaks händlivad interact range sisenevad objektid ja väljuvad
func _on_body_entered(body: Node3D) -> void:
	interactablesInRange.push_back(body)	
	updateInteractables()
	print("entered interactable range of : ", body, " Active object: ", selectedInteractable)

func _on_body_exited(body: Node3D) -> void:
	interactablesInRange.erase(body)
	updateInteractables()
	print("left interactable range of: ", body, " Active object: ", selectedInteractable)

#siia alla saab panna asjad millega interakteerud.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("UI_Interact"):
		print("interacting with: ", selectedInteractable)


		#planteri interaktsioon, tõsta eraldi funki hiljem vist. 
		#Planteri endaga on ühenduses see node siin. UI saadab siia signaale. 
		if !selectedInteractable:
			print("nothing to interact with")

		elif selectedInteractable.is_in_group("Planter"):
			if !Global.tutorial_state["GardenTut"]:
				show_tutorial("GardenTut")
				Global.tutorial_state["GardenTut"] = true
			
			else:
				#print("Planterstate: ", selectedInteractable.planterState, " dirtLevel: ", selectedInteractable.dirtRatio, "Taim on: ", selectedInteractable.Plant)	
				#see saadab teate et võta ui ette.
				var planterState: int = selectedInteractable.planterState
				var plantName: String = "null"
				var dirtLevel: int = selectedInteractable.dirtRatio
				var moistureLevel: int = selectedInteractable.moisture
				var fertilizerLevel: int = selectedInteractable.fertilizer
				var plantGrowth: int = selectedInteractable.plantGrowth
				var plantHealth: int = selectedInteractable.plantHealth
				
				if planterState == 0:
					#kontrollib invist kas sul ikka mulda on
					var soilFound: bool = false
					for slot in Global.inventory.slots:
						if slot.item and slot.item.name == "item_Soil" and slot.amount > 0:
							var index = Global.inventory.slots.find(slot)
							if index != -1:
								slot.item.use(selectedInteractable)
								Global.inventory.use_item(index, 10)
								soilFound = true
								
							Global.inventory.update.emit()
							emit_signal("show_GardenUI", planterState, plantName, dirtLevel, moistureLevel, fertilizerLevel, plantGrowth, plantHealth)
							Global.isInteracting = true
							#print("Palun täida mind!") #mida?
							
							emit_signal("movementDisabled")
					if !soilFound:
						displayLabel("Kasti täitmiseks on vaja leida mulda")
				
				#print("Saadetud signaal showGardenUI, state:", selectedInteractable.planterState)
				#emit_signal("show_GardenUI", planterState, plantName, dirtLevel, moistureLevel, fertilizerLevel, plantGrowth, plantHealth) 
				
				if planterState == 1:
					var seedsFound: bool = false
					for slot in Global.inventory.slots:
						if slot.item and slot.item.name == "seemned" and slot.amount > 0:
							var index = Global.inventory.slots.find(slot)
							if index != -1:
								slot.item.use(selectedInteractable)
								Global.inventory.use_item(index, 1)
								seedsFound = true
					if !seedsFound:
						displayLabel("Istutamiseks on vaja seemneid")
					

				
				if planterState == 2:
					plantName = selectedInteractable.Plant.name
					emit_signal("show_GardenUI", planterState, plantName, dirtLevel, moistureLevel, fertilizerLevel, plantGrowth, plantHealth) 
					Global.isInteracting = true
					print("Saadetud signaal showGardenUI, state:", selectedInteractable.planterState, plantName)
				
				#see ei toimi
				if planterState == 3:
					Global.inventory.insert(seeds, 5)
					selectedInteractable.planterStater(1)


		elif selectedInteractable.is_in_group("Item"):
			if $"..".is_item_needed(selectedInteractable.item_id):
				$"..".check_quest_objectives(selectedInteractable.item_id, "collection", selectedInteractable.item_quantity)
				selectedInteractable.queue_free()
			else: 
				print("Item not needed for any active quest.")

		elif selectedInteractable.is_in_group("Shop"):
			Global.isInteracting = true
			print("Shopping!")
			if !Global.tutorial_state["ShopTut"]:
				show_tutorial("ShopTut")
				Global.tutorial_state["ShopTut"] = true
			else:
				$"../HUD/Shop_UI".open()
		
		elif selectedInteractable.is_in_group("Map"):
			if !Global.tutorial_state["MapTut"]:
				show_tutorial("MapTut")
				Global.tutorial_state["MapTut"] = true
			else:
				Global.isInteracting = true
				$"../HUD/WorldMapUi".showMap()
				#print("Koli dilani arvutisse")
		
		elif selectedInteractable.is_in_group("NPC"):
			if !Global.tutorial_state["NpcTut"]:
				show_tutorial("NpcTut")
				Global.tutorial_state["NpcTut"] = true
			else:
				Global.isInteracting = true
				selectedInteractable.start_dialog()
				$"..".check_quest_objectives(selectedInteractable.npc_id, "talk_to", null)

#see saadab teate, et mulla ladumine on lõppenud. Paneb paika ka mulla taseme. 
func _on_garden_ui_dirt_filled_signal(dirtLevel: int) -> void:
	selectedInteractable.dirtRatio = dirtLevel
	selectedInteractable.planterState = 1
	selectedInteractable.planterStater(1)
	refreshInteractables()

func _on_garden_ui_plant_planted(plant: String) -> void:
	print("Saadud signaal istuta taim: ", plant)
	selectedInteractable.Plant = load(plant)
	selectedInteractable.planterState = 2
	selectedInteractable.planterStater(2)
	refreshInteractables()

func _on_garden_ui_uproot_plant() -> void:
	selectedInteractable.uprootPlant()
	refreshInteractables()

func _on_garden_ui_plant_care(careType: int) -> void:
	match careType:
		0:
			selectedInteractable.moisture = 100
		1:
			selectedInteractable.fertilizer = 100

func show_tutorial(ui_type: String) -> void:
	var message := ""
	match ui_type:
		"ShopTut":
			message = "See on kohalik pood. Poes saab osta asju, mida võib vaja minna!"
		"MapTut":
			message = "Vajutades ruroopale saad sinna reisida. Paremal nurgas oleva nupuga saad naaseda ülikooliaeda!"
		"GardenTut":
			message = "Taimekastides saad kasvatada taimi. Taimekast on esialgu vaja täita mullaga ja siis on vaja leida seeme, mida istutada"
		"NpcTut":
			message = "Siin saab suhelda tegelastega! Kasutades eri valikuid saad koguda infot või vastu võtta ülesandeid!"
	tutorial_menu.show_tutorial(message)

func refreshInteractables():
	updateInteractables()

func displayLabel(text: String):
	$InteractLabel.set_text(text)
	$InteractLabel.show()
	await get_tree().create_timer(1.0).timeout
	$InteractLabel.hide()
	
