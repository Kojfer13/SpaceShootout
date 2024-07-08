extends Control

var id = 3
var price = 7000

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
		GlobalVariables.insufficient_funds.emit()
		print("Brak Pieniędzy Biedaku Robaku Polaku")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
