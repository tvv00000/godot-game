extends Resource

class_name Dialog

@export var dialogs = {}

# Load dialog data
func load_from_json(file_path):
	var data = FileAccess.get_file_as_string(file_path)
	var parsed_data = JSON.parse_string(data)
	if parsed_data:
		dialogs = parsed_data
	else:
		print("Failed to parse: ", parsed_data)

# Return individual NPC dialogs
func get_npc_dialog(npc_id):
	if npc_id in dialogs:
		return dialogs[npc_id]["trees"]
	else:
		return []

"""
For Taavet
"npc_sage": {
		"trees": [
			{
				"branch_id": "npc_sage_1",
				"dialogs": [
					{
						"state": "start",
						"text": "Oh, Eksmati, tüümian ehk aed-liivatee on tõeline päikeselaps! Ta tahab päikest nagu nartsiss kevadel – palju valgust, kuiva ja kivist pinnast",
						"options": {
							"Et siis porilompides ta ei taha hullata, nagu mõni järvetaim?": "plant_info",
							"Kas ma saan teda kuidagi aidata?": "give_quests",
							"Hüvasti": "exit"
						}
					},{
						"state": "plant_info",
						"text": "Täpselt! Ta pigem naudib väikest kannatust – põud pole talle probleem. Vahemeremaades, kust ta pärineb, seal meeldib talle kivide vahel ronida. Ta on väike vapper ürditaimeke.",
						"options": {
							"Ürditaimeke? Mulle meeldib see! Tänan sind, valguse ja kivide valitseja!": "start",
						}
					},{
						"state": "give_quests",
						"text": "Ja ikka saad, too mulle 3 tüümiani.",
						"options": {
							"Lähen otsima!": "end"
						}
					},{
						"state": "end",
						"text": "",
						"options": {}
					},{
						"state": "exit",
						"text": "",
						"options": {}
					}
				]
			},{
			"branch_id": "npc_default",
				"dialogs": [
					{
						"state": "start",
						"text": "npc_default",
						"options": {
							"Say Goodbye": "exit"
						}
					}
				]
			}
		]
	}
"""
