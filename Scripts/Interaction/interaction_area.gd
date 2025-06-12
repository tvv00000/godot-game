extends Area3D

@onready var InteractionLabel: Label3D = $InteractLabel
#See on mängija küljes olev jubin, mis uurib kas ümber on näpitavaid asju, sorteerib neid järjekorda ja lubab interactida.

#SETUP: 1. veendu et interactable object oleks staticbody3d
		#2. lisa talle "var interactLabel: String = "tekst mida kuvatakse kui tahad interaktida"

#TODO: kontrolli üle mitme intractable sortimine
#TODO: pane ka midagi mis awaitib kuni interaktsioon on lõppenud.

var interactablesInRange := []
var selectedInteractable: StaticBody3D = null
signal show_GardenUI(state: int, plantName: String)
signal movementDisabled()

func _ready():
	InteractionLabel.hide()

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
			print("Planterstate: ", selectedInteractable.planterState, " dirtLevel: ", selectedInteractable.dirtRatio, "Taim on: ", selectedInteractable.Plant)	
			#see saadab teate et võta ui ette.
			var planterState: int = selectedInteractable.planterState
			var plantName: String = "null"
			var dirtLevel: int = selectedInteractable.dirtRatio
			var moistureLevel: int = selectedInteractable.moisture
			var fertilizerLevel: int = selectedInteractable.fertilizer
			var plantGrowth: int = selectedInteractable.plantGrowth
			var plantHealth: int = selectedInteractable.plantHealth
			
			if planterState == 0:
				for slot in Global.inventory.slots:
					if slot.item and slot.item.name == "Mullahunnik" and slot.amount > 0:
						var index = Global.inventory.slots.find(slot)
						if index != -1:
							slot.item.use(selectedInteractable)
							Global.inventory.use_item(index)
						Global.inventory.update.emit()
						selectedInteractable.dirtRatio = 100
						selectedInteractable.planterState = 1
						selectedInteractable.planterStater(1)
						InteractionLabel.set_text("Muld lisatud!")
						print("Palun täida mind!")
				return
			
			emit_signal("movementDisabled")
			
			print("Saadetud signaal showGardenUI, state:", selectedInteractable.planterState)
			emit_signal("show_GardenUI", planterState, plantName, dirtLevel, moistureLevel, fertilizerLevel, plantGrowth, plantHealth) 
			

			
			if planterState == 2:
				plantName = selectedInteractable.Plant.name
				emit_signal("show_GardenUI", planterState, plantName, dirtLevel)
				print("Saadetud signaal showGardenUI, state:", selectedInteractable.planterState, plantName)
		
		elif selectedInteractable.is_in_group("Item"):
			print("I. AM. ITEM!")
			
		elif selectedInteractable.is_in_group("Shop"):
			print("Shopping!")
		
		elif selectedInteractable.is_in_group("Map"):
			$"../HUD/WorldMapUi".showMap()
			#print("Koli dilani arvutisse")
		
		elif selectedInteractable.is_in_group("NPC"):
			selectedInteractable.start_dialog()
			#print("Hello. I am under the sea. Please send help. Bulbulbulbul.")

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

func refreshInteractables():
	updateInteractables()
