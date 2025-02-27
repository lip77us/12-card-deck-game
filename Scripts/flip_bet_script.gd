extends BetTypeClass

class_name FlipBet

var high = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func type_str():
	return "Flip Bet to "+low_or_high()+" DLR"

func low_or_high():
	if high:
		return "Above"
	else:
		return "Below"
	
func payout_odds():
	return -99
	
func odds_need_context():
	return true
	
func can_be_bet(totals_array, flip_from_over):
	#return a true if the hand can be bet and a false otherwise.  Also fix the 
	# odds and set the name to low spots or high spots
	var winners = 0
	if flip_from_over:   #this is a new over bet to flip tp under
		high = false
		for i in range(totals_array.size()):
			if totals_array[i]<39:
				winners +=1
	else:
		high = true
		for i in range(totals_array.size()):
			if totals_array[i]>39:
				winners +=1
	if winners == 0 or winners == 6:
		return false
	else:
		match winners:
			1:
				override_payout_odds = 	4.5	
			2:
				override_payout_odds = 	1.75
			3:
				override_payout_odds = 	0.92
			4:
				override_payout_odds = 0.3
			5:
				override_payout_odds = 0.15
		return true
	
func is_winner(player_hand, dealer_hand, last_four):
	if high:
		return player_hand.hand_totals() > dealer_hand.hand_totals()
	else:
		return player_hand.hand_totals() < dealer_hand.hand_totals()
	
	
func sort_order():
	return 7
	
func is_preflop():
	return false
	
func is_turn():
	return true
	
func is_turn_flip_over_under():
	return true
