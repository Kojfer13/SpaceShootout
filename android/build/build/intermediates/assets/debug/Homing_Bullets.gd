extends ItemList

var cost = 400 * (GlobalVariables.HomingLevel + 1)
var cap = 5
signal save

# Called when the node enters the scene tree for the first time.
func _ready():
	cost = 400 * (GlobalVariables.MoneyLevel + 1)
	print("Nowa cena: ", cost, " = 200 * ",  GlobalVariables.HomingLevel, " + 1")
	print("Masz: ", GlobalVariables.cash)
	$Level.text = "LV %s" % GlobalVariables.HomingLevel
	$Price.text = "%s $" % cost
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Level.text = "LV %s" % GlobalVariables.HomingLevel
	if cap == GlobalVariables.HomingLevel:
		$Price.text = "Ulepszono Maksymalnie"
	else:
		$Price.text = "%s $" % cost
func kup():
	if GlobalVariables.cash >= cost and GlobalVariables.HomingLevel < cap:
		GlobalVariables.cash -= cost
		GlobalVariables.HomingLevel += 1
		cost = 300 * (GlobalVariables.HomingLevel + 1)
		$Price.text = "%s $" % cost
		GlobalVariables.save.emit()
		print("Nowa cena: ", cost, " = 200 * ",  GlobalVariables.HomingLevel, " + 1" )
	$Level.text = "LV %s" % GlobalVariables.HomingLevel
	save.emit()
