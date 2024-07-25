extends Control

var id = 2
var price = 15000

# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalVariables.OwnedSkins[id]:
		$Buy.hide()
		$Equip.show()
	else:
		$Buy.show()
		$Equip.hide()
func equip():
	GlobalVariables.EquipSkin.emit(id)
func buy():
	if GlobalVariables.cash >= price:
		GlobalVariables.OwnedSkins[id] = true
		_ready()
		GlobalVariables.save.emit()
		print("Kupione'd")
	else:
		print("Brak Pieniędzy Biedaku Robaku Polaku")
		GlobalVariables.insufficient_funds.emit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
