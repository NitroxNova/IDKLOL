extends PanelContainer

var file_list = []

func _ready():
	var files = list_files_in_directory("user://save")
	for file_name in files:
		file_list.append("user://save/" + file_name)
		$VBox/Saves/ItemList.add_item(file_name.trim_suffix(".save"))

func _on_Back_pressed():
	get_tree().change_scene("res://Menu/Start/Start_Menu.tscn")
	
func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	if dir.dir_exists(path):
		dir.open(path)
		dir.list_dir_begin()
		while true:
			var file = dir.get_next()
			if file == "":
				break
			elif not file.begins_with("."):
				files.append(file)
		dir.list_dir_end()
	return files

func _on_Load_pressed():
	if $VBox/Saves/ItemList.is_anything_selected():
		var selected = $VBox/Saves/ItemList.get_selected_items()[0]
		var file_name = file_list[selected]
		var game = load("res://Game/Main.tscn").instance()
		game.connect("ready",game,"load_game",[file_name])
		var tree = get_tree()
		tree.get_root().remove_child(self) 
		tree.get_root().add_child(game)
		tree.current_scene = game

func _on_Delete_pressed():
	if $VBox/Saves/ItemList.is_anything_selected():
		var selected = $VBox/Saves/ItemList.get_selected_items()[0]
		var file_name = file_list[selected]
		file_list.remove(selected)
		$VBox/Saves/ItemList.remove_item(selected)
		var dir = Directory.new()
		dir.remove(file_name)
		
