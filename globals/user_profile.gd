extends Node

var card_animator 
const FIELD_USER_NAME = "Name"
const FIELD_BANKROLL = "bankroll"
const FIELD_SPEED = "deal_speed"
const FIELD_HIGH_SCORE = "High Score"
const FIELD_DATE = "Date"

var user_name = ""
var bankroll = 100
var high_water_mark = 100
var deal_speed_string

var game_profile_dict = {}
var current_user_parms = {}
var high_scores_db = []

var db_loaded = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_animator = $CardAnimator
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_user_name():
	return user_name

func set_user_name(string):
	user_name = string
	# and set all the user globals
	set_user_paramaters()

func set_user_paramaters():
	bankroll = float (parms_for_current_user()[FIELD_BANKROLL])
	deal_speed_string = parms_for_current_user()[FIELD_SPEED]
	
func set_scores_db(scores):
	high_scores_db = scores
	for score_dict in scores:
		if (score_dict[FIELD_USER_NAME]==user_name):
			high_water_mark = float(score_dict[FIELD_HIGH_SCORE])
	
func get_high_scores_db():
	return high_scores_db
	
func set_bankroll(amount):
	bankroll = amount
	parms_for_current_user()[FIELD_BANKROLL]=bankroll
	
func change_bankroll_by(amount):
	set_bankroll(bankroll + amount)
	
func get_bankroll():
	return bankroll
	
func set_game_profile_db(profile_dict):
	game_profile_dict = profile_dict
	
func game_profile_db():
	return game_profile_dict
	
func name_list():
	return game_profile_db().keys()
	
func name_list_size():
	return name_list().size()
	
func name_list_has(string):
	return name_list().has(string)
	
func is_loaded():
	return db_loaded
	
func has_been_loaded():
	db_loaded = true
	
func parms_for_current_user():
	if current_user_parms.size()==0:
		if game_profile_db().has(get_user_name()):
			current_user_parms = game_profile_db()[get_user_name()]
		else:
			current_user_parms = create_new_user_profile()
	return current_user_parms 

func create_new_user_profile():
	var new_profile = {}
	new_profile[FIELD_USER_NAME] = get_user_name()
	new_profile[FIELD_BANKROLL] = bankroll
	new_profile[FIELD_SPEED]= card_animator.CARD_MOVE_SPEED_MEDIUM
	game_profile_db()[get_user_name()] = new_profile
	return new_profile
	
func deal_speed_index():  #return a number 0-2
	var index = -1
	if (deal_speed_string == "Slow"): 
		index=0
	elif deal_speed_string == "Medium":
		index = 1
	elif deal_speed_string == "Fast":
		index = 2
	return index
		
func set_speed_from_index(index):
	match index:
		0:
			deal_speed_string = "Slow"
		1:
			deal_speed_string = "Medium"
		2: 
			deal_speed_string = "Fast"
	parms_for_current_user()[FIELD_SPEED]=deal_speed_string		
	
func get_high_score():
	return high_water_mark
	
func set_new_high_score():
	high_water_mark = bankroll
	for score_dict in high_scores_db:
		if (score_dict[FIELD_USER_NAME]==user_name):
			score_dict[FIELD_HIGH_SCORE]=high_water_mark
			score_dict[FIELD_DATE]=Time.get_date_string_from_system(false)
	
	
func test():
	pass

			
	
	
