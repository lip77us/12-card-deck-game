extends PopupMenu

var speed_submenu: PopupMenu = PopupMenu.new()
@onready var card_animator = $"../../CardAnimator"
@onready var confetti = $"../../Confetti"
var firework = true
var coin_feature = true
var in_browser = OS.has_feature("web_macos")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_speed_menu()
	add_firework_toggle()
	add_coins_toggle()

func setup_speed_menu():
	speed_submenu.name = "Speed"
	add_child(speed_submenu)
	add_submenu_item("Set Deal Speed...", "Speed")
	speed_submenu.add_item("Slow")
	speed_submenu.add_item("Medium")
	speed_submenu.add_item("Fast")
	speed_submenu.connect("index_pressed",_on_submenu_index_pressed)
	#if ! in_browser:
		#card_animator.set_speed_index(2)	

func add_firework_toggle():
	add_item("Turn off Fireworks")
	
func add_coins_toggle():
	add_item("Turn off Coin Cascade")

func _on_index_pressed(index: int) -> void:
	
	match index:
		0:
			pass # this is a submenu
		1: 
			if firework:
				firework = false
				confetti.disable()
				set_item_text (index,"Turn On Fireworks")
			else:
				firework = true
				confetti.enable()
				set_item_text (index,"Turn Off Fireworks")
			
		2:
			if coin_feature:
				coin_feature = false
				set_item_text (index,"Turn On Coin Cascade")
			else:
				coin_feature = true
				set_item_text (index,"Turn Off Coin Cascade")
			
func _on_submenu_index_pressed(index):
	card_animator.set_speed_index(index)
	UserProfile.set_speed_from_index(index)
