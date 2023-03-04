extends PanelContainer

var name_list = ["Achilles","Adamaris","Adelram","Adonias","Adria","Adrian","Adrianna","Aegeus","Agrippa","Ajax",
"Alaric","Alecia","Alessandra","Alethea","Alexander","Alric","Andromeda","Antigone","Antreas",
"Apollo","Aquilla","Arathorn","Ares","Ariadne","Ariana","Aries","Arthur","Ashanti","Athena",
"Atlas","Barron","Beowulf","Blaine","Bolivar","Frederick","Fulbright","Gable",
"Gael","Gage","Garrett","Garrick","Gaston","Genevieve","Gerhardt","Gervais","Godric","Graden",
"Guryon","Gwen","Hades","Hadrian","Hale","Hannah","Helen","Hercules","Hunter","Hyperion",
"Ilaria","Ingram","Ivan","Ives","Jax","Jedrick","Juliet","Kade","Kaden",
"Kaelan","Katherine","Khronos","Killian","Lance","Lazarus","Leonitus","Lourdes","Luther","Maximus","Monroe",
"Osias","Perseus","Ramses","Rodan","Sable","Saxon","Tiana","Tiberius"]

func _ready():
	random_name()

func random_name():
	$VBox/Player_Name/Line_Edit.text = RNG.array_rand(name_list)
	
func _on_Back_pressed():
	get_tree().change_scene_to_file("res://Menu/Start/Start_Menu.tscn")

func _on_Start_pressed():
	var game = load("res://Game/Main.tscn").instantiate()
	game.connect("ready",Callable(game,"new_game").bind($VBox/Player_Name/Line_Edit.text))
	var tree = get_tree()
	tree.get_root().remove_child(self) 
	tree.get_root().add_child(game)
	tree.current_scene = game
