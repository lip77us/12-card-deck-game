extends Node2D

class_name Hand


var cards = []
var hand_y_position # This needs to be set when a hand is given to player or dealer
var hand_totals_display #widget to update when totals change
var hand_values = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print($Area2D.collision_mask)
	pass

	
func add_card_to_hand(card):
	cards.insert(0,card)
	hand_values.insert(0,card.value)
	
func insert_card_value(card_value):
	hand_values.insert(0,card_value)
	
func remove_front_card_value():
	return hand_values.pop_front()

func hand_totals():
	var total = 0
	#var card_database_reference
	#card_database_reference = preload("res://Scripts/card_database.gd")
	#for i in range(cards.size()):
		#total += card_database_reference.CARDS[cards[i].name]
	for i in range(hand_values.size()):
		total += hand_values[i]
	return total
		
func update_display():
		hand_totals_display.text = str(hand_totals())
#func remove_card_from_hand(card):
	#if card in hand:
		#hand.erase(card)
		#update_hand_positions(CARD_REMOVE_SPEED)
func clear():
	cards = []
	hand_values = []
	hand_totals_display.text = "Pre Flop"
	
func latest_card_value():
	return hand_values.front()
	
func get_values():
	return hand_values
	
func last_two_values():
	var last_two = []
	last_two.append (hand_values[0])
	last_two.append (hand_values[1])
	return last_two
	
	
