extends ItemList

var cost = 500 * (GlobalVariables.ShieldLevel + 1)
var cap = 5
signal save

# Called when the node enters the scene tree for the first time.
func _ready():
	cost = 500 * (GlobalVariables.ShieldLevel + 1)
	print("Nowa cena: ", cost, " = 200 * ",  GlobalVariables.ShieldLevel, " + 1")
	print("Masz: ", GlobalVariables.cash)
	$Level.text = "LV %s" % GlobalVariables.ShieldLevel
	$Price.text = "%s $" % cost
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Level.text = "LV %s" % GlobalVariables.ShieldLevel
	if cap == GlobalVariables.ShieldLevel:
		$Price.text = "Ulepszono Maksymalnie"
	else:
		$Price.text = "%s $" % cost
func kup():
	if GlobalVariables.cash >= cost and GlobalVariables.ShieldLevel < cap:
		GlobalVariables.cash -= cost
		GlobalVariables.ShieldLevel += 1
		cost = 500 * (GlobalVariables.ShieldLevel + 1)
		$Price.text = "%s $" % cost
		GlobalVariables.save.emit()
		print("Nowa cena: ", cost, " = 200 * ",  GlobalVariables.ShieldLevel, " + 1" )
	else:
		if GlobalVariables.cash < cost:
			GlobalVariables.insufficient_funds.emit()
	$Level.text = "LV %s" % GlobalVariables.ShieldLevel
	save.emit()
