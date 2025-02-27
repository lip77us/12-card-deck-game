extends Node2D

const PRE_DEAL_STATE = 0
const DEALING_FLOP_STATE = 1
const FLOP_COMPLETE_STATE = 3
const DEALING_TURN_STATE = 4
const TURN_COMPLETE_STATE = 5
const DEALING_RIVER_STATE = 6
const FINISH_STATE = 7
const WAITING_TO_CLEAR_STATE = 8

signal state_pre_deal
signal state_flop_complete
signal state_turn_complete
signal state_waiting_to_clear


const CARDS_IN_FLOP = 3
const CARDS_ON_TURN = 1
const CARDS_ON_RIVER = 2

var error_dialog
var hand_summary_dialog
@onready var bet_manager = $"../BetMgr"
@onready var db = $"../PersistanceMgr"
@onready var tool_menu = $"../MenuBar/Tools"
var deck
var deal_button
var card_manager
var card_animator
var player_bankroll_mgr
var bet_text
var hand_history
var confetti

const COIN_SCENE_PATH = "res://Scenes/coins.tscn"
var coin_scene = preload(COIN_SCENE_PATH)


var dealer_hand
var player_hand
var play_state 
var player_turn_to_get_card = true
var deal_round = 1 # there are 6 rounds and both a player and a dealer gets a card in a round
var deal_counter = 0 # How many deals have I done this session
var fireworks = true
var coin_cascade = true
var coin_player



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dealer_hand = Hand.new()
	dealer_hand.hand_y_position = 200
	dealer_hand.hand_totals_display = $"../Table Layout/DealerCardTotal/RichTextLabel"
	player_hand = Hand.new()
	player_hand.hand_y_position = 1350
	player_hand.hand_totals_display = $"../Table Layout/PlayerCardTotal/RichTextLabel"
	error_dialog = $"../ErrorDialog"
	hand_summary_dialog = $"../HandSummaryDialog"
	#bet_manager = $"../BetMgr"
	play_state = PRE_DEAL_STATE
	deck = $"../Deck"
	deal_button = $"../Table Layout/Deal_Button"
	card_manager = $"../CardMgr"
	card_animator = $"../CardAnimator"
	player_bankroll_mgr = $"../PlayerBankrollMgr"
	bet_text=$"../Table Layout/BetPanel/Bet Text"
	hand_history = $"../HandHistory"
	confetti = $"../Confetti"
	confetti.turn_on(false)
	load_coins()
	
func load_coins():
	var coin_top = coin_scene.instantiate()
	var coin = coin_top.get_child(0)
	coin_player = coin.get_child(0)
	
	
	#emit_signal("state_pre_deal")

func deal():
	if bet_manager.confirm_ready_to_deal():
		bet_manager.reset_bet_type()
		match play_state:	
			PRE_DEAL_STATE:
				if bet_manager.has_bet():
					deal_counter += 1
					card_from_deck_to_hand(player_hand)
					player_turn_to_get_card = false
					deal_round = 1 # each round ends after the dealer card is dealt
					play_state = DEALING_FLOP_STATE
				else:
					display_error("Must have an initial pre-deal bet")
			FLOP_COMPLETE_STATE:
				deck.clear_cards_coming()
				card_from_deck_to_hand(player_hand)
				player_turn_to_get_card = false
				play_state = DEALING_TURN_STATE
				
			TURN_COMPLETE_STATE:
				deck.clear_cards_coming()
				card_from_deck_to_hand(player_hand)
				player_turn_to_get_card = false
				play_state = DEALING_RIVER_STATE
				
			WAITING_TO_CLEAR_STATE:
				reset_to_next_deal()
				deal_button.set_text("Deal")
				player_hand.clear()
				dealer_hand.clear()
				card_manager.erase_cards_display(player_hand)
				card_manager.erase_cards_display(dealer_hand)
				#bet_manager.setup_predeal_bet_state()
				play_state = PRE_DEAL_STATE
				emit_signal("state_pre_deal")
				tool_menu.autofill()
				
				
		
func deal_next_card():  #Assume that we wait until the previous card animation complete
	match play_state:
		DEALING_FLOP_STATE:
			if player_turn_to_get_card:
				card_from_deck_to_hand(player_hand)
			else:
				card_from_deck_to_hand(dealer_hand)
				deal_round += 1
				if deal_round > CARDS_IN_FLOP: #done with the round
						play_state = FLOP_COMPLETE_STATE
						emit_signal("state_flop_complete")
						
		FLOP_COMPLETE_STATE:
			deck.show_cards_coming()
			bet_manager.update_after_flop(player_hand,dealer_hand)
			#var label = "FLop Bet"
			#$"../Table Layout/BetPanel/Bet Text".set_text(label)
			#bet_manager.setup_flop_bet_state()
			
		DEALING_TURN_STATE:
			if player_turn_to_get_card:
				card_from_deck_to_hand(player_hand)
			else:
				card_from_deck_to_hand(dealer_hand)
				deal_round += 1
				if deal_round > CARDS_IN_FLOP+CARDS_ON_TURN: 
						play_state = TURN_COMPLETE_STATE
						emit_signal("state_turn_complete")
		
		TURN_COMPLETE_STATE:
			deck.show_cards_coming()
			update_bet_results()
			bet_manager.update_after_turn(player_hand,dealer_hand)
			
		DEALING_RIVER_STATE:
			if player_turn_to_get_card:
				card_from_deck_to_hand(player_hand)
			else:
				card_from_deck_to_hand(dealer_hand)
				deal_round += 1
				if deal_round > CARDS_IN_FLOP+CARDS_ON_TURN+CARDS_ON_RIVER:
						play_state = FINISH_STATE
		
		FINISH_STATE:
			update_bet_results()
			hand_history.add_hand_values(player_hand.get_values(), dealer_hand.get_values())
			db.update_hands_data_base(player_hand.get_values(), dealer_hand.get_values())
			play_state = WAITING_TO_CLEAR_STATE
			emit_signal("state_waiting_to_clear")
			deal_button.set_text("Hand Results")
			db.save_game_parms()
			if player_bankroll_mgr.is_new_high_score():
				db.update_high_score()

		
	player_turn_to_get_card = ! player_turn_to_get_card
			
func card_from_deck_to_hand(hand):
	var card = deck.draw_card()
	hand.add_card_to_hand(card)
	card_animator.deal_card_from_deck(hand)
	hand.update_display()

func place_bet():
	#place bet button pressed
	bet_manager.place_bet()

func update_bet_results():
	var won_lost = bet_manager.update_bets_results(player_hand, dealer_hand, deal_counter)
	if won_lost > 0:
		player_bankroll_mgr.update_bankroll(won_lost)
		animate_chips(won_lost)

	
func display_error (error_message):
	error_dialog.set_cancel_button_text(error_message)
	error_dialog.popup()
	
func reset_to_next_deal():
	display_deal_summary()
	bet_manager.clear_bets()
	deck.reset_deck()
	bet_text.set_text("New Bet")
	
func player_hand_totals():
	return player_hand.hand_totals()
	
func dealer_hand_totals():
	return dealer_hand.hand_totals()
	
func deck_values(count):
	return deck.peak_at_values(count)
	
func string_for_card_value(value):
	return deck.name_for_value(value)
	
func get_hand_number():
	return deal_counter

func preflop_state():
	return play_state == PRE_DEAL_STATE

func animate_chips(amount_won):
	pass
	
func display_deal_summary():
	var win_level = 0
	var amt_won_lost_this_deal = bet_manager.results_total_for_hand_number(
		deal_counter)
	hand_summary_dialog.title = "Results for Hand Number " + str(deal_counter)
	var result_text = ""
	if (amt_won_lost_this_deal) < 0:
		result_text = "Amount Lost: " + str(-amt_won_lost_this_deal)
	elif amt_won_lost_this_deal > 0:
		result_text = "Amount Won: " + str(amt_won_lost_this_deal)
		if amt_won_lost_this_deal < 5:
			win_level = 1
		elif amt_won_lost_this_deal < 10:
			win_level = 2
		else:
			win_level = 3
	else:
		result_text = "Broke Even"
	hand_summary_dialog.set_text(result_text)
	hand_summary_dialog.show()
	if fireworks and win_level>0:
		show_fireworks(win_level)
	if coin_cascade and win_level>0:
		cascade_coins(win_level)
		
func show_fireworks(level): # 1 a little, 2 some, 3 a lot
	confetti.set_level(level)
	confetti.turn_on(true)
	
func cascade_coins(level):
	coin_player.play("falling coin")
	

func _on_hand_summary_dialog_confirmed() -> void:
	confetti.turn_on(false)
