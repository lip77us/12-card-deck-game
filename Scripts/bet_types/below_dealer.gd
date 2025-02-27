extends BetTypeClass

class_name BelowDealerClass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func type_str():
	return "Below DLR"
	
func payout_odds():
	return 1
	
func is_winner(player_hand, dealer_hand, last_four):
	return player_hand.hand_totals() < dealer_hand.hand_totals()
	
func sort_order():
	return 2
	
func mutex_class_number():
	return 1

func under_dealer_bet():
	return true
