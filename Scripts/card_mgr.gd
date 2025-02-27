extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2
const ADD_TO_HAND_SPEED = .1
const DEFAULT_CARD_SCALE = 0.8
const CARD_LARGER_SCALE = 0.85

var screen_size
var card_being_dragged
var is_hovering_on_card
#var player_hand_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	#player_hand_reference=$"../PlayerHand"
	#$"../InputMgr".connect("left_mouse_button_released", on_left_click_released)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if card_being_dragged:
			#var mouse_pos = get_global_mouse_position()
			#card_being_dragged.position = Vector2(clamp(mouse_pos.x,0,screen_size.x),
				#clamp(mouse_pos.y, 0, screen_size.y))
	pass
	
func _input(event):
	pass
		
			
			
func connect_card_signals(card):
	#card.connect("hovered", on_hovered_over_card)
	#card.connect("hovered_off", off_hovered_over_card)
	pass
	
func on_hovered_over_card(card):
	if ! is_hovering_on_card:
		highlight_card(card,true)
		is_hovering_on_card = true

#func off_hovered_over_card(card):
	#if ! card_being_dragged:
		#highlight_card(card,false)
		#var new_card_hovered = raycast_check_for_card()
		#if new_card_hovered:
			#highlight_card(new_card_hovered, true)
		#else:
			#is_hovering_on_card = false
			#
#func on_left_click_released():
	#if card_being_dragged:
		#finish_drag(card_being_dragged)

func highlight_card(card,hovered):
	pass
	#if hovered:
		#card.scale = Vector2(CARD_LARGER_SCALE,CARD_LARGER_SCALE)
		#card.z_index = 2
	#else:
		#card.scale = Vector2 (DEFAULT_CARD_SCALE,DEFAULT_CARD_SCALE)
		#card.z_index=1
		
func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
		#return result[0].collider.get_parent()
	return null
	
func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
		#return result[0].collider.get_parent()
	return null

func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	for i in range(1,cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > cards[i]:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
			
func start_drag(card):
	pass
	#card_being_dragged=card
	#card.scale = Vector2(DEFAULT_CARD_SCALE,DEFAULT_CARD_SCALE)
		
func finish_drag(card):
	pass
	#card.scale = Vector2(CARD_LARGER_SCALE, CARD_LARGER_SCALE)
	#var card_slot_found = raycast_check_for_card_slot()
	#if card_slot_found and not card_slot_found.card_in_slot:
		## Card drpopped in empty slot
		#card_being_dragged.position = card_slot_found.position
		#card_being_dragged.get_node("Area2D/CollisionShape2D").disabled=true
		#card_slot_found.card_in_slot = true
	#else:
		#player_hand_reference.add_card_to_hand(card_being_dragged, ADD_TO_HAND_SPEED)
	#card_being_dragged = null
	
func erase_cards_display(hand): #ready for new deal.  Erase all the cards in the hands
	var children = get_children()
	for i in range(children.size()):
		children[i].queue_free()
	
