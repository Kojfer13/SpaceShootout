extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Popup.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func sprawdz():
	var tekst = $TextEdit.get_line(0);
	print("CODE IS: ", tekst)
	#To be replaced with server side verification
	var kody = {
		"BeerLover" : 4
	}
	if kody.has(tekst):
		GlobalVariables.EquipSkin.emit(4)
		$Popup.show()
		$Popup.text = "Beer Mode Activated"
	else:
		$Popup.show()
		$Popup.text = "Zły kod"
