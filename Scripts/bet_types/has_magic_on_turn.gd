extends BetTypeClass

class_name HasMagic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func type_str():
	return "Magic Combo"

func payout_odds():
	return 4

func is_winner(player_hand, dealer_hand, last_four): # weird one.  If the hands come in with 6 values
										# then this is a simulation and just use the last 2
										#cards in the dealer and player hands to determine
										#the winner.  If there are 4 values, need to use the
										#deck to decide the winner

	last_four.sort()
	return (last_four[1]-last_four[0]) == (last_four[3]-last_four[2])
	
func completed_after_turn():
	return true
	
func sort_order():
	return 7

func mutex_class_number():
	return 2
