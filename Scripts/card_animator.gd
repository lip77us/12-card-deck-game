extends Node2D

const CARD_WIDTH = 240
const CARD_MOVE_SPEED_FAST = 0.2	
const CARD_MOVE_SPEED_MEDIUM = 0.5
const CARD_MOVE_SPEED_SLOW = 1.0
const CARD_MOVE_TEXT_SLOW = "Slow"
const CARD_MOVE_TEXT_MEDIUM = "Medium"
const CARD_MOVE_TEXT_FAST = "Fast"
const CARD_MOVE_OPTIONS = [CARD_MOVE_TEXT_SLOW, CARD_MOVE_TEXT_MEDIUM, CARD_MOVE_TEXT_FAST]

var center_screen_x
var queue = []
var card_move_speed = -99
var deal_speed_button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2 - 100
	deal_speed_button = $"../Table Layout/DealSpeedButton"
	setup_deal_speed_button()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func deal_card_from_deck (hand):
	if card_move_speed < 0:
		set_speed_index(UserProfile.deal_speed_index())
	update_hand_positions(hand, card_move_speed)

#func add_card_to_hand(card, hand):
	#if card not in hand:
		#hand.insert(0,card)
		#update_hand_positions(hand, CARD_MOVE_SPEED)
	#else:
		#animate_card_to_position(card, card.position_in_hand, CARD_MOVE_SPEED)
	
func update_hand_positions(hand, card_move_speed):
	for i in range(hand.cards.size()):
		var new_position = Vector2(calculate_card_position(hand.cards,i),hand.hand_y_position)
		var card = hand.cards[i]
		card.position_in_hand = new_position
		var from_deck = (i == hand.cards.size()-1)
		animate_card_to_position(card, new_position, card_move_speed, from_deck)
		
func calculate_card_position(hand,index):
	var total_width = (hand.size()-1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width/2
	return x_offset
	
func	 animate_card_to_position(card, new_position, speed, big_move_from_deck):
	var tween = get_tree().create_tween()
	if big_move_from_deck:
		tween.connect("finished", card_animation_complete)
	tween.tween_property(card,"position",new_position, speed)

func card_animation_complete():
	$"../Dealer".deal_next_card()

func setup_deal_speed_button():
	var speeds = ["Slow", "Medium", "Fast"]
	for i in range(speeds.size()):
		var label = Label.new()  # Create a new Label node
		deal_speed_button.get_popup().add_item(CARD_MOVE_OPTIONS[i])
	deal_speed_button.get_popup().id_pressed.connect( deal_speed_menu_pressed )
	
func deal_speed_menu_pressed(id:int): #adjust the dealing speed based on user preference
	deal_speed_button.text = CARD_MOVE_OPTIONS[id]
	match CARD_MOVE_OPTIONS[id]:
		CARD_MOVE_TEXT_SLOW:
			card_move_speed = CARD_MOVE_SPEED_SLOW
		CARD_MOVE_TEXT_MEDIUM:
			card_move_speed = CARD_MOVE_SPEED_MEDIUM		
		CARD_MOVE_TEXT_FAST:
			card_move_speed = CARD_MOVE_SPEED_FAST		
			
func set_speed_index(index):
	match index:
		0:
			card_move_speed = CARD_MOVE_SPEED_SLOW
		1:
			card_move_speed = CARD_MOVE_SPEED_MEDIUM
		2:
			card_move_speed = CARD_MOVE_SPEED_FAST
			
func get_speed_text():
	return CARD_MOVE_OPTIONS[card_move_speed]
