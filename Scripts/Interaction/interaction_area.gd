extends Area3D

var label: Label3D = null
#See on mängija küljes olev jubin, mis uurib kas ümber on näpitavaid asju, sorteerib neid järjekorda ja lubab interactida.

#SETUP: 1.instanci Interactable.tscn näpitava objekti külge ja lisa ka CollisionShape3d. Interactitav object võiks olla staticbody muidu pead uue versiooni tegema interactable tseenist
#		2. lisa algusesse @onready var Interactable: Area3D = $Interactable et saadaks interactable tseen kätte
#		2.5. Lisa ka tekst "interactName" 
#		3. näpitava objekti sisse funktsioon func onInteract():  kuhu alla saab lisada koodi mida ta tegema peab.

var interactablesInRange := []
var selectedInteractable: StaticBody3D = null

#See sorteerib lähedal olevad interactabled ja valib listist lähima objekti, kui array on suurem kui 1.
func updateInteractables():
	#if elif else oli vajalik sest ta mudu tahtis kräshu bäšhu teha rangest väljudes
	if interactablesInRange.size() > 1:
		interactablesInRange.sort_custom(sortNearest)
		interactableSelector()
			
	elif interactablesInRange.size() == 1:
		interactableSelector()
		
	else:
		label.hide()
		label = null
		selectedInteractable = null

#siin tehakse näpitava valimise toimingud.
func interactableSelector():
	selectedInteractable = interactablesInRange[0] 
	label =  selectedInteractable.Interactable.InteractLabel
	
	label.text = selectedInteractable.interactName
	label.show()

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
	
	


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("UI_Interact"):
		print("interacting with: ", selectedInteractable)
		
		
		if selectedInteractable:
			selectedInteractable.onInteract()
		else:
			print("error interacting, no interactable found!")
			
