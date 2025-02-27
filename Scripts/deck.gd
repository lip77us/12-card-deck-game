extends Node2D

const CARD_DRAW_SPEED = 0.5
const CARD_SCENE_PATH = "res://Scenes/card.tscn"

#var card_deck = ["Ace", "Two", "Three", "Four","Five","Six","Seven","Eight",
#"Nine","Ten","Jack", "Queen"]

var card_deck = [] # and array of Card Strings.
var card_database_reference
var cards_coming_display = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print($Area2D.collision_mask)
	card_database_reference = preload("res://Scripts/card_database.gd")
	reset_deck()
	setup_cards_coming_display_array()
	clear_cards_coming()

func reset_deck():
	card_database_reference = preload("res://Scripts/card_database.gd")
	$Sprite2D.visible=true
	for key in card_database_reference.CARDS.keys():
		card_deck.append(key)
	card_deck.shuffle()
	clear_cards_coming()


func draw_card():
	var card_drawn_name = card_deck[0]
	card_deck.erase(card_drawn_name)
	
	if card_deck.size() == 0:
		$Sprite2D.visible=false
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	var card_image_path = card_image_path(card_drawn_name)
	new_card.get_node("CardFront").texture = load(card_image_path)
	$"../CardMgr".add_child(new_card)
	new_card.name=card_drawn_name
	new_card.value = card_database_reference.CARDS[card_drawn_name]
	return (new_card)
	
func value_for_card(card_name):
	return(card_database_reference.DECK[card_name])
	
func name_for_value(value):
	return(card_database_reference.CARDS.find_key(value))
	
func setup_cards_coming_display_array(): # Array of GUI holders for cards
										
	cards_coming_display.append($CardsComing1)
	cards_coming_display.append($CardsComing2)
	cards_coming_display.append($CardsComing3)
	cards_coming_display.append($CardsComing4)
	cards_coming_display.append($CardsComing5)
	cards_coming_display.append($CardsComing6)
	
func sort_cards_ascending(a,b):
	return value_for_card_name(a) < value_for_card_name(b)
	
func show_cards_coming():
	var cards_coming = []
	for  i in range(card_deck.size()):
		cards_coming.append(card_deck[i])
	cards_coming.sort_custom(sort_cards_ascending)
	for i in range(cards_coming.size()):
		cards_coming_display[i].texture = load(card_image_path(cards_coming[i]))
		cards_coming_display[i].set_visible(true)
	for i in range(cards_coming.size(),cards_coming_display.size()):
		cards_coming_display[i].set_visible(false)

func clear_cards_coming():
	for i in range(cards_coming_display.size()):
		cards_coming_display[i].set_visible(false)

func card_image_path(card_name):
	return str("res://Assets/cards/" + card_name + ".jpg")
	
func value_for_card_name(name):
	return card_database_reference.CARDS[name]
	
func peak_at_values(count):  #return an array of the next count values from deck
	var card_values = []
	for i in range(count):
		card_values.append(value_for_card_name(card_deck[i]))
	return card_values
	
func peak_at_last_values(count):
	var card_values = []
	if (cards_left()>=count):
		for i in range(cards_left()-count, cards_left()):
			card_values.append(value_for_card_name(card_deck[i]))
	return card_values
	
func cards_left():
	return card_deck.size()
	
func card_value_at(index):
	return(value_for_card_name(card_deck[index]))

func last_four_given_hand_values(player_values, dealer_values):
	var last_four=[]
	var hands = []
	if player_values.size() ==4:
		hands.append_array(player_values)
		hands.append_array(dealer_values)
		for i in range(1,13):
			if !hands.has(i):
				last_four.append(i)
	else:
		last_four.append(player_values[5])
		last_four.append(dealer_values[5])
		last_four.append(player_values[4])
		last_four.append(dealer_values[4])
		
	return last_four
	
func last_six_given_hand_values(player_values, dealer_values):
	var last_six=[]
	var hands = []
	if player_values.size() == 3:
		hands.append_array(player_values)
		hands.append_array(dealer_values)
		for i in range(1,13):
			if !hands.has(i):
				last_six.append(i)
	else:
		last_six.append(player_values[5])
		last_six.append(dealer_values[5])
		last_six.append(player_values[4])
		last_six.append(dealer_values[4])
		last_six.append(player_values[3])
		last_six.append(dealer_values[3])
		
	return last_six
