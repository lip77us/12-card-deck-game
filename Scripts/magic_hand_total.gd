extends BetTypeClass

class_name MagicHandTotal

var hand_total

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func type_str():
	return "*Player* = " + str(hand_total)

func payout_odds():
	return 2
	
func is_winner(player_hand, dealer_hand, last_four):
	return player_hand.hand_totals() == hand_total
	
func sort_order():
	return hand_total
	
func is_preflop():
	return false
	
func is_turn():
	return true
	
func is_magic_total_bet():
	return true
