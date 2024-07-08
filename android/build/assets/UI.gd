extends CanvasLayer

signal start
signal menu
signal retry
signal save
signal unpause
signal pause
signal refresh

var score = 0
var highscore = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func zapisz():
	var save_dict = {
		"highscore" : highscore,
		"cash" : GlobalVariables.cash,
		"SpeedLv" : GlobalVariables.SpeedLevel,
		"MoneyLv" : GlobalVariables.MoneyLevel,
		"ShieldLv" : GlobalVariables.ShieldLevel,
		"OwnedSkins" : GlobalVariables.OwnedSkins,
		"EquippedSkin" : GlobalVariables.EquippedSkin
	}
	return save_dict
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
func _on_start_button_pressed():
	emit_signal("start")
func ukryj_menu():
	$TitleScreen.hide()
func pokarz_menu():
	$TitleScreen.show()
func pokarz_hud():
	$Hud.show()
func ukryj_hud():
	$Hud.hide()
func gameover():
	#$GameOver/ScoreValue.text = str(score)
	$GameOver/ScoreText.text = "Twój wynik to: %s " % score
	if score > highscore:
		highscore = score
		save.emit()
	$GameOver/HighScoreText.text = "Twój najlepszy wynik to: %s" % highscore
	$GameOver.show()
func ukryj_gameover():
	$GameOver.hide()
func update_zycia(wynik):
	$Hud/LivesDisplay.text = str(wynik)
func update_shield(wynik):
	$Hud/ShieldDisplay.text = str(wynik)
func pokarz_tarcze():
	$Hud/Shield.show()
	$Hud/ShieldDisplay.show()
func ukryj_tarcze():
	$Hud/Shield.hide()
	$Hud/ShieldDisplay.hide()
func update_score():
	score += 100
func pokarz_pauze():
	$PauseScreen.show()
func ukryj_pauze():
	print("odpauza")
	$PauseScreen.hide()
	unpause.emit()
func _on_menu_pressed():
	emit_signal("menu")
func _on_retry_pressed():
	emit_signal("retry")
func _on_pause_button_pressed():
	pause.emit()
func pokarz_sklep():
	refresh.emit()
	$Sklep.show()
	GlobalVariables.GdzieJestem = 3
func ukryj_sklep():
	$Sklep.hide()
	GlobalVariables.GdzieJestem = 0
func pokarz_credits():
	$Credits.show()
	GlobalVariables.GdzieJestem = 4
func ukryj_credits():
	$Credits.hide()
	GlobalVariables.GdzieJestem = 0
