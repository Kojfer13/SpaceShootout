extends ItemList

var cost = 300 * (GlobalVariables.MoneyLevel + 1)
var cap = 5
signal save

# Called when the node enters the scene tree for the first time.
func _ready():
	cost = 300 * (GlobalVariables.MoneyLevel + 1)
	print("Nowa cena: ", cost, " = 200 * ",  GlobalVariables.MoneyLevel, " + 1")
	print("Masz: ", GlobalVariables.cash)
	$Level.text = "LV %s" % GlobalVariables.MoneyLevel
	$Price.text = "%s $" % cost
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Level.text = "LV %s" % GlobalVariables.MoneyLevel
	if cap == GlobalVariables.MoneyLevel:
		$Price.text = "Ulepszono Maksymalnie"
	else:
		$Price.text = "%s $" % cost
func kup():
	if GlobalVariables.cash >= cost and GlobalVariables.MoneyLevel < cap:
		GlobalVariables.cash -= cost
		GlobalVariables.MoneyLevel += 1
		cost = 300 * (GlobalVariables.MoneyLevel + 1)
		$Price.text = "%s $" % cost
		GlobalVariables.save.emit()
		print("Nowa cena: ", cost, " = 200 * ",  GlobalVariables.MoneyLevel, " + 1" )
	else:
		if GlobalVariables.cash < cost:
			GlobalVariables.insufficient_funds.emit()
	$Level.text = "LV %s" % GlobalVariables.MoneyLevel
	save.emit()
