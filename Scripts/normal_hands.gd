extends BetTypeClass

class_name IsNormalHand

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func type_str():
	return "Abstract Type"
	
func first_index():
	return 99
	
func second_index():
	return 99

func sort_order():
	return 7

func payout_odds():
	return 2


func is_winner(player_hand, dealer_hand, last_four): # this is a two stage bet, first
													#magic has to fail and then it has
													#to be the lowest 2 combos of rivers

	#create a table of 6 river combos and find where this combo is.
	var player_river = []
	var dealer_river = []
	var river = []
	var river_card_sums=[]
	var player_sum
	#print("in is winner:"+ str(last_four))
	if last_four.size()== 4:
		if is_early_loss(player_hand, dealer_hand, last_four):
			return false
		else:
			return true
		#player_river.append (last_four[0])
		#player_river.append (last_four[2])
		#dealer_river.append (last_four[1])
		#dealer_river.append (last_four[3])
	else:
		player_river = player_hand.last_two_values()
		dealer_river = dealer_hand.last_two_values()
	player_sum = player_river[0]+player_river[1]	
	river.append_array(player_river)
	river.append_array(dealer_river)
	for i in range(3):
		for j in range(i+1,4):
			river_card_sums.append(river[i]+river[j])
	river_card_sums.sort()
	#print ("in is winner sums"+str(river_card_sums))
	var ret =  (river_card_sums[first_index()]== player_sum or 
		river_card_sums[second_index()] == player_sum)
	if !ret:
		pass
		#print ("Not Winner, second_index, river_card_sums[second_index(),player_sum " +
		#str(second_index())+ " "+ str(river_card_sums[second_index()])+ " "+
		#str(player_sum))
	return ret
	
func is_early_loss(player_hand, dealer_hand, last_four): #you lose if magic on turn
	var last_four_copy = last_four
	last_four_copy.sort()
	var loss = (last_four_copy[1]-last_four_copy[0]) == (last_four_copy[3]-
	last_four_copy[2])
	#print ("in early loss "+ str(loss))
	return loss
	
func check_for_loss_after_turn():
	return true

func mutex_class_number():
	return 2
