extends Node2D
	# Takes care of instaniating the Bet Types and deals with the bet type lists

const BET_TYPE_SCENE_PATH = "res://Scenes/bet_type.tscn/"
const STATE_PRE_DEAL = "state_pre_flop"
const STATE_FLOP = "state_flop"
const STATE_TURN = "state_turn"
const STATE_RIVER = "state_river"
#
var bet_type_scene = preload(BET_TYPE_SCENE_PATH)

var all_bet_types = []
var bet_types_eligible = []
var bet_types_eligible_strings = []
var deal_state = STATE_PRE_DEAL


var dealer
var bet_gui_coord
var bets_made_coord

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_collaborators()
	load_bet_types()
	setup_events()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_collaborators():
	dealer = $"../../Dealer"
	bet_gui_coord = $"../BetGUICoord"
	bets_made_coord = $"../BetsMadeCoord"

func load_bet_types():
	#bet_type_scene =  preload(BET_TYPE_SCENE_PATH)
	var abt = bet_type_scene.instantiate()
	var bt = abt.get_children()[1]
	var types = bt.get_children()
	for i in range(types.size()):
		var bet_type = types[i]
		all_bet_types.append(bet_type)
		for j in range(bet_type.instantiation_copies()-1):
			var bt_copy = bet_type.get_script().new()
			bt.add_child(bt_copy)
			all_bet_types.append(bt_copy)
	pass

func setup_events():
	dealer.state_pre_deal.connect(pre_deal)
	dealer.state_flop_complete.connect(flop)
	dealer.state_turn_complete.connect(turn)
	dealer.state_waiting_to_clear.connect(river)

func pre_deal():
	deal_state = STATE_PRE_DEAL
	update_preflop_bet_type_list()
	
func flop():
	deal_state = STATE_FLOP
	update_flop_bet_type_list()
	
func turn():
	deal_state = STATE_TURN
	update_turn_bet_type_list()
	
func river():
	deal_state = STATE_RIVER
	update_river_bet_type_list()

func update_preflop_bet_type_list():
	var strings = preflop_bet_types_strings()
	bet_gui_coord.setup_bet_types_menu(strings)
	
func update_flop_bet_type_list():
	var strings = flop_bet_types_strings()
	bet_gui_coord.setup_bet_types_menu(strings)
	
func update_turn_bet_type_list():
	var strings = turn_bet_types_strings()
	bet_gui_coord.setup_bet_types_menu(strings)
	
func update_river_bet_type_list():
	var strings = river_bet_types_strings()
	bet_gui_coord.setup_bet_types_menu(strings)
	
func preflop_bet_types_strings():
	clear_bet_types()
	var bets_made_types = bets_made_coord.bets_made_types() #need to remove bet types made
															#from strings list
	var bets_made_mutex_siblings = []
	for i in range (bets_made_types.size()):  #also remove the mutually exclusive siblings
		bets_made_mutex_siblings.append_array(
			get_mutex_siblings(bets_made_types[i].mutex_class_number()))
	bets_made_types.append_array(bets_made_mutex_siblings)
		
			
	for i in range(all_bet_types.size()):
		if(!bets_made_types.has(all_bet_types[i])) and type_for_deal_state(all_bet_types[i]):
			bet_types_eligible.append(all_bet_types[i])
	sort_types_and_create_strings()
	return bet_types_eligible_strings

func get_mutex_siblings(class_number):
	var mutex_sibs = []
	if class_number > 0:
		for i in range(all_bet_types.size())	:
			if all_bet_types[i].mutex_class_number() == class_number:
				mutex_sibs.append(all_bet_types[i])
	return mutex_sibs
			
func type_for_deal_state(bet_type):
	var for_current_state = false
	match deal_state:
		STATE_PRE_DEAL:
			for_current_state = bet_type.is_preflop()
		STATE_FLOP:
			for_current_state = bet_type.is_flop()
		STATE_TURN:
			for_current_state = bet_type.is_turn()
	return for_current_state
		
func flop_bet_types_strings():
	clear_bet_types()
	var last_six = dealer.deck_values(6)
	last_six.sort()

	var get_array=[]
	for i in range(6):
		get_array.append(last_six[i])
	var bets_made_types = bets_made_coord.bets_made_types()
	
	for i in range(all_bet_types.size()):
		var bet_type = all_bet_types[i]
		var value
		if(bet_type.is_flop()):
			if bet_type.is_flop_get_card:
				if bets_made_types.has(bet_type):
					#remove that card from the get array
					var index = get_array.find(bet_type.card_value)
					get_array.remove_at(index)
				else:
					value = get_array.pop_front()
					bet_type.card_name = dealer.string_for_card_value(value)
					bet_type.card_value = value
					bet_types_eligible.append(bet_type)
	sort_types_and_create_strings()
	return bet_types_eligible_strings
	
func turn_bet_types_strings():
	#all the turn bets need context.  There are currently 3 types of bets, Hand total,
	# 5 spot and Flip the under/over bet.  I will need to do different prep for each one
	# I will use a turn type to determine which type I have
	clear_bet_types()
	#setup for hand totals bet
	var totals_array = []
	var totals_array_for_flip=[]
	var player_hand_count = dealer.player_hand_totals()
	var dealer_hand_count = dealer.dealer_hand_totals()
	var last_four = dealer.deck_values(4)
	last_four.sort()
	
	#setup for the magic bet
	var magic_hand_total = 0
	var bets_made_types = bets_made_coord.bets_made_types()
	if (last_four[1]-last_four[0]) == (last_four[3]-last_four[2]):
		magic_hand_total = player_hand_count + last_four[0] + last_four[3]
	
	#now put non-magic totals amount in totals_array
	for i in range(3):
		for j in range(i+1,4):
			var total = player_hand_count + last_four[i]+ last_four[j]
			if total != magic_hand_total:
				totals_array.append(total)
				totals_array_for_flip.append(total)
	#now loop through each type and fill in values 
	
	for i in range(all_bet_types.size()):
		var bet_type = all_bet_types[i]
		if(bet_type.is_turn()):
						
			if bet_type.is_magic_total_bet() and magic_hand_total > 0 and (
				!bets_made_types.has(bet_type)):
				bet_type.hand_total = magic_hand_total
				bet_types_eligible.append(bet_type)
				
			elif bet_type.is_turn_hand_total() and totals_array.size() >0:
				if bets_made_types.has(bet_type):
					#remove that total from the totals_array
					var index = totals_array.find(bet_type.hand_total)
					totals_array.remove_at(index)
				else:
					bet_type.hand_total = totals_array.pop_front()			
					bet_types_eligible.append(bet_type)
				
			elif bet_type.is_turn_five_spots() and (
				!bets_made_types.has(bet_type)):
				if (bet_type.can_be_bet(dealer.player_hand.get_values(),last_four)):
					bet_types_eligible.append(bet_type)
			
			elif bet_type.is_turn_flip_over_under():
				# flip to over under dealer based on current totals.
				var currently_above_dealer = (dealer.player_hand_totals() >  
					dealer.dealer_hand_totals())
				if (bet_type.can_be_bet(totals_array_for_flip, currently_above_dealer )):
					bet_types_eligible.append(bet_type)
							#
				#for index in range(bets_made_types.size()):
					#if (bets_made_types[index].over_dealer_bet()):
						#above_dealer_bet = true
					#elif (bets_made_types[index].under_dealer_bet()):
						#below_dealer_bet = true
				#if above_dealer_bet:
					#if (bet_type.can_be_bet(totals_array_for_flip, true)):
						#bet_types_eligible.append(bet_type)
				#elif below_dealer_bet:
					#if (bet_type.can_be_bet(totals_array_for_flip, false)):
						#bet_types_eligible.append(bet_type)
					  
				
	sort_types_and_create_strings()
	return bet_types_eligible_strings
	
func river_bet_types_strings():
	clear_bet_types()	
	return []
	
func clear_bet_types():
	bet_types_eligible = []
	bet_types_eligible_strings = []

func get_bet_type():
	return bet_gui_coord.selected_type()
	
func get_type_at(index):
	return bet_types_eligible[index]
	
func bet_type_now_eligible(type): #Add it back into list
	bet_types_eligible.append(type)
	sort_types_and_create_strings ()
	

func sort_ascending(a, b):
	if a.sort_order() < b.sort_order():
		return true
	return false
	
func sort_types_and_create_strings():
	
	bet_types_eligible.sort_custom(sort_ascending)
	bet_types_eligible_strings = []
	for i in range(bet_types_eligible.size()):
		bet_types_eligible_strings.append(bet_types_eligible[i].name_with_odds())
		
func update_bet_types():
	match deal_state:
		STATE_PRE_DEAL:
			update_preflop_bet_type_list()
		STATE_FLOP:
			update_flop_bet_type_list()
		STATE_TURN:
			update_turn_bet_type_list()
		STATE_RIVER:
			update_river_bet_type_list()
			
func ok_to_remove_bet_at(index): #look up the bet and see if it is still in current state
	var bet_type = bets_made_coord.bet_made_at(index).get_type()
	match deal_state:
		STATE_PRE_DEAL:
			return bet_type.is_preflop()
		STATE_FLOP:
			return bet_type.is_flop()
		STATE_TURN:
			return bet_type.is_turn()
		STATE_RIVER:
			return bet_type.is_river()
	
func reset_bet_type_button():
		bet_gui_coord.reset_bet_type_button_text()
