extends BetTypeClass

class_name FiveSpot

var high = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func type_str():
	return "Five or Six "+low_or_high()+ " Spots"

func low_or_high():
	if high:
		return "High"
	else:
		return "Low"
	
func payout_odds():
	return -99
	
func odds_need_context():
	return true
	
func can_be_bet(player_hand_values, last_four):
	#return a true if the hand can be bet and a false otherwise.  Also fix the 
	# odds and set the name to low spots or high spots
	var lows = 0
	var highs = 0
	for i in range(player_hand_values.size()):
		if player_hand_values[i] <= 6:
			lows += 1
	if lows==2:
		return false # no way to get 5 with only 2 cards left
	var last4_lows = 0
	var last4_highs = 0
	for i in range(4):
		if last_four[i] <= 6:
			last4_lows +=1
	last4_highs = 4 - last4_lows
	highs = 4-lows
	if ((lows ==3 and last4_lows < 2) or (lows == 4 and last4_lows < 1) or (
		highs == 3 and last4_highs < 2) or (highs == 4 and last4_highs < 1)):
			return false # now all we have left are real chances
	
	if lows == 3:
		high = false
		if last4_lows == 2:
			override_payout_odds = 4.5 #1 of 6
		else: #( must be 3 )
			override_payout_odds = .92 #3 of 6
	elif lows == 4:
		high = false
		if last4_lows == 2:
			override_payout_odds = .15 #5 of 6 chance
		else: #( must be 1 )
			override_payout_odds = .92 #3 of 6
	elif highs == 3:
		high = true
		if last4_highs == 2:
			override_payout_odds = 4.5 #1 of 6
		else: #( must be 3 )
			override_payout_odds = .92 #3 of 6
	elif highs == 4:
		high = true
		if last4_highs == 2:
			override_payout_odds = .15 #5 of 6 chance
		else: #( must be 1 )
			override_payout_odds = .92 #3 of 6
	return true
	
	
func is_winner(player_hand, dealer_hand, last_four):
	var lows = 0
	var highs = 0
	for i in range(player_hand.hand_values.size()):
		if (player_hand.hand_values[i] <= 6):
			lows += 1
		else:
			highs += 1
	return lows >= 5 or highs >= 5
	
func sort_order():
	return 6
	
func is_preflop():
	return false
	
func is_turn():
	return true
	
func is_turn_five_spots():
	return true
