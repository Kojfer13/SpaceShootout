extends Node

var zycia
var diff = 0
var difflvl = 1
var spawn_count = 1
var shield = GlobalVariables.ShieldLevel

func _ready():               
	GlobalVariables.save.connect(zapisz)
	GlobalVariables.GdzieJestem = 0
	print("Gdzie Jestem = 0 w ready")
	$ShootDelay.stop()
	$SpawnDelay.stop()
	get_tree().set_auto_accept_quit(false)
	wczytaj()
	menu()
func menu():
	GlobalVariables.GdzieJestem = 0
	odpauzuj()
	print("Gdzie Jestem = 0 w menu")
	$ShootDelay.stop()
	$SpawnDelay.stop()
	get_tree().call_group("przeciwnicy", "queue_free")
	get_tree().call_group("naboje", "queue_free")
	$UI.ukryj_pauze() 
	$UI/Credits.hide()
	$UI.pokarz_menu()
	$UI.ukryj_hud()
	$UI.ukryj_gameover()
	$UI/Sklep.hide()
	$Tlo.hide()
	$Gracz.hide()
	$Kontrola.hide()
	$SpawnSound.stop()
func start():
	spawn_count = 1
	GlobalVariables.GdzieJestem = 1
	print("Gdzie Jestem = 1 w start")
	zycia = 5
	$ShootDelay.wait_time = 0.5  - GlobalVariables.SpeedLevel * 0.05
	$SpawnDelay.wait_time = 1.5
	$UI.score = -100
	$UI.update_score() 
	$UI.update_zycia(zycia)
	if GlobalVariables.ShieldLevel > 0:
		shield = GlobalVariables.ShieldLevel
		$UI.update_shield(shield)
		$UI.pokarz_tarcze()
	else:
		$UI.ukryj_tarcze()
	$UI.ukryj_menu()
	$UI.ukryj_gameover()
	$UI.pokarz_hud()
	$Gracz.show()
	$Tlo.show()
	$Kontrola.value = 480 / 2
	$Kontrola.show()
	$ShootDelay.start()
	$SpawnDelay.start()
	$DiffTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Gracz.position.x = $Kontrola.value

func strzel():
	var pocisk = preload("res://bullet.tscn").instantiate()
	pocisk.position.x = $Gracz.position.x
	pocisk.position.y = $Gracz.position.y - 100
	pocisk.linear_velocity = Vector2(0, -900)
	add_child(pocisk)
	$SpawnSound.play()

func spawnuj():
	for i in spawn_count:
		var przeciwnik = preload("res://kwadrat.tscn").instantiate()
		przeciwnik.position.y = -500
		przeciwnik.position.x = randi() % 1080
		przeciwnik.linear_velocity = Vector2(0, 500)
		przeciwnik.DefPos.connect(emit_cash_particle)
		add_child(przeciwnik)
		przeciwnik.point.connect($UI.update_score)
		przeciwnik.cash.connect(GlobalVariables.Update_Cash)
		przeciwnik.poza.connect(uderzono)
	$SpawnDelay.wait_time = 1
func emit_cash_particle(gdzie):
	var sto = preload("res://cashparticle.tscn").instantiate()
	sto.position = gdzie
	add_child(sto)
func uderzono():
	print("Życia: ", zycia, " Tarcza: ", shield)
	if shield > 0:
		shield -= 1
		$UI.update_shield(shield)
		$ShieldTimer.start()
		if shield == 0:
			$UI.ukryj_tarcze()
		return
	zycia -= 1
	$UI.update_zycia(zycia)
	if zycia <= 0:
		GlobalVariables.GdzieJestem = 0
		print("Gdzie Jestem = 0 w gameover")
		get_tree().call_group("przeciwnicy", "queue_free")
		get_tree().call_group("naboje", "queue_free")
		$UI.ukryj_hud()
		$ShootDelay.stop()
		$SpawnDelay.stop()
		$UI.gameover()
		zapisz()
		$UI.score = 0
func zapisz():
	var zapis = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var dane = $UI.call("zapisz")
	print("Odczytano:")
	print(dane)
	var json_string = JSON.stringify(dane)
	print("zapisano:")
	print(json_string)
	zapis.store_line(json_string)
func wczytaj():
	if not FileAccess.file_exists("user://savegame.save"):
		print("BRAK ZAPISU ROBAKU")
		return
	var zapis = FileAccess.open("user://savegame.save", FileAccess.READ)
	print("PLIK ZAPISU ODNALEZIONY")
	var json = JSON.new()
	var parse = json.parse(zapis.get_line())
	var temp = {
		"highscore" : 0,
		"cash" : 0,
		"SpeedLv" : 0,
		"MoneyLv" : 0,
		"ShieldLv" : 0,
		"OwnedSkins" : [true, false, false, false, false, false, false, false, false, false],
		"EquippedSkin" : 0
	}
	var dane = json.get_data()
	dane.merge(temp, false)
	print("Merged: ", dane)
	if dane == null:
		print("PLIK ZAPISU USZKODZONY")
		return
	print("odczytano: ", dane)
	$UI.highscore =  int(dane["highscore"])
	GlobalVariables.cash = int(dane["cash"])
	GlobalVariables.SpeedLevel = int(dane["SpeedLv"])
	GlobalVariables.MoneyLevel = int(dane["MoneyLv"])
	GlobalVariables.ShieldLevel = int(dane["ShieldLv"])
	GlobalVariables.OwnedSkins = Array(dane["OwnedSkins"])
	GlobalVariables.EquippedSkin = int(dane["EquippedSkin"])
	GlobalVariables.EquipSkin.emit(GlobalVariables.EquippedSkin)
	print("Załadowany wynik: ", int($UI.highscore))
	print("Załadowane pieniądze: ", int(GlobalVariables.cash))
	print("Posiadane Skiny", GlobalVariables.OwnedSkins)
	print("Obecny Skin", GlobalVariables.EquippedSkin)
	
func _notification(what): 
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			#Debug
			match GlobalVariables.GdzieJestem: 
				0:
					print("JESTEM W 0")
					zapisz()
					get_tree().quit()
				1:
					pause()
				2:
					odpauzuj()
				3:
					$UI.ukryj_sklep()
				4:
					$UI.ukryj_credits()
				_:
					pass
					
		NOTIFICATION_WM_GO_BACK_REQUEST:
			#Android
			match GlobalVariables.GdzieJestem: 
				0:
					get_tree().quit()
				1:
					pause()
				2:
					odpauzuj()
				3:
					$UI.ukryj_sklep()
				4:
					$UI.ukryj_credits()
				_:
					print("NIC wartosc: ", GlobalVariables.GdzieJestem)

func pause():
	$UI.pokarz_pauze()
	GlobalVariables.GdzieJestem = 2
	print("Gdzie Jestem = 2 w pauze")
	get_tree().paused = true

func odpauzuj():
	if GlobalVariables.GdzieJestem == 0:
		get_tree().paused = false
		return
	$UI/PauseScreen.hide()
	GlobalVariables.GdzieJestem = 1
	print("Gdzie Jestem = 1 w odpauzuj")
	get_tree().paused = false
func _on_diff_timer_timeout():
	diff = 0.1
	if $SpawnDelay.wait_time != 0.6:
		$SpawnDelay.wait_time = 1 - diff
		print("Zmiana spawn time:", $SpawnDelay.wait_time)
	else:
		difflvl += 1
		print("Difflvl = ", difflvl)
		if difflvl == 5:
			spawn_count = 2
			print("Zmiana spawn count:", spawn_count)


func regeneruj():
	if shield < GlobalVariables.ShieldLevel:
		shield += 1
		if shield == 1:
			$UI.pokarz_tarcze()
		if shield <= GlobalVariables.ShieldLevel:
			$ShieldTimer.start()
