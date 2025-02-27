extends Node

var deck

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck	 = $"../Deck"

func calculate_odds_to_win_on_turn (player_hand, dealer_hand, bet_type):
	# returns the odds based on cards remaining in the deck
	# as an array of two values, win combos and total combinations
	

	var local_player_hand = Hand.new()
	var local_dealer_hand = Hand.new()
	var itteration_count = 0
	var winners = 0
	
	for i in range(4):
		local_player_hand.add_card_to_hand(player_hand.cards[i])
		local_dealer_hand.add_card_to_hand(dealer_hand.cards[i])
	
	for i in range(3):
		for j in range(i+1,4):
				var player_cards_indexes = [i,j]
				for deck_index in range (4):
					var value = deck.value_for_card_name(deck.card_deck[deck_index])
					if player_cards_indexes.has(deck_index):
						local_player_hand.insert_card_value(value)
					else:
						local_dealer_hand.insert_card_value(value)
				itteration_count += 1
				if (bet_type.is_winner(local_player_hand, local_dealer_hand,[])):
					#deck.peak_at_last_values(4))):
					winners += 1
				for l in range(2):
					local_player_hand.remove_front_card_value()
					local_dealer_hand.remove_front_card_value()
	#print ("winners: "+str(winners) + " out of " + str(itteration_count) + "combinations")
	return ([winners, itteration_count])
	
func calculate_odds_to_win_on_flop (player_hand, dealer_hand, bet_type):
	# returns the odds based on cards remaining in the deck
	# as an array of two values, win combos and total combinations
	

	var local_player_hand = Hand.new()
	var local_dealer_hand = Hand.new()
	var itteration_count = 0
	var winners = 0
	var last_four = []
	#xxx deck.last_four_given_hand_values(player_hand.get_values(),
		 #dealer_hand.get_values())
	
	for i in range(3):
		local_player_hand.insert_card_value(player_hand.cards[i].value)
		local_dealer_hand.insert_card_value(dealer_hand.cards[i].value)

	if bet_type.completed_after_turn() or bet_type.check_for_loss_after_turn():
		
		for i in range(5):
			for j in range(i+1,6):
					for deck_index in range (6):
						var value = deck.value_for_card_name(deck.card_deck[deck_index])
						if deck_index == i:
							local_player_hand.insert_card_value(value)
						elif deck_index == j:
							local_dealer_hand.insert_card_value(value)
						else:
							last_four.append(value)

					itteration_count += 1
					#print("    Player Total: "+str(local_player_hand.hand_totals()))
					#print("Dealer Total: "+str(local_dealer_hand.hand_totals()))
					if (bet_type.is_winner(local_player_hand, local_dealer_hand, last_four)):
						winners += 1
						#print("              is winner")
					for l in range(1):
						local_player_hand.remove_front_card_value()
						local_dealer_hand.remove_front_card_value()
					last_four=[]
	else:
		
		for i in range(4):
			for j in range(i+1,5):
				for k in range(j+1,6):
					var player_cards_indexes = [i,j,k]
					for deck_index in range (6):
						var value = deck.value_for_card_name(deck.card_deck[deck_index])
						if player_cards_indexes.has(deck_index):
							local_player_hand.insert_card_value(value)
						else:
							local_dealer_hand.insert_card_value(value)
					itteration_count += 1
					if (bet_type.is_winner(local_player_hand, local_dealer_hand, last_four)):
						winners += 1
					for l in range(3):
						local_player_hand.remove_front_card_value()
						local_dealer_hand.remove_front_card_value()
					last_four = []
	#print ("winners: "+str(winners) + " out of " + str(itteration_count) + "combinations")
	return ([winners, itteration_count])
					
					

	
	
