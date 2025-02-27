extends Node

#const URL_SUBMIT = "https://docs.google.com/forms/u/0/d/e/1FAIpQLSc0U0aRaeAAOrFInM92pHZtYDrKKMVBZpkaY0iypnTdkvl_Mw/formResponse"
const HEADERS = ["Content-Type: application/x-www-form-urlencoded"]
#const URL_DATA = "https://opensheet.elk.sh/1hAgSu6z7ClKGyzj3oGB2JIiguNjENj5UyjIq-h5EPxk/data"
const NAME_ID = "entry.1938524964"
const BANKROLL_ID = "entry.1761163609"
const DEAL_SPEED =  "entry.582698062"
const HIGH_WATER_MARK = "entry.1761163609"

const USER_SETTING_URL_SUBMIT = "https://docs.google.com/forms/u/0/d/e/1FAIpQLSdfXDnUKn8XzdxG-4BvtiVO-a7BEFl-9Bcwp8K2V9tVcv1sLg/formResponse"
const USER_SETTING_URL_GET = "https://docs.google.com/spreadsheets/d/1aDtN-A1Z2MIbExq8WIt7JG49iaxifzotas_6OltvIuM/gviz/tq"
const US_DB_NAME_ID = "entry.1898094653"
const US_DB_CHIPS_ID ="entry.1144409569"
const US_DB_SPEED_ID = "entry.692268899"
const US_DB_FIELDNAME_NAME = "Name"
const US_DB_FIELDNAME_CHIPS = "Chips"
const US_DB_FIELDNAME_SPEED = "Deal Speed"

const DB_FIELD_USER_NAME = "Name"
const APP_NAME = "user_name"
const APP_BANKROLL = "bankroll"
const APP_DEAL_SPEED = "deal_speed"

const HIGH_SCORE_URL_SUBMIT = "https://docs.google.com/forms/u/0/d/e/1FAIpQLScBUENATodZ-lwoIAXhlBdGRnlz2Ku8UCuqtZ3suhsmuvS8uw/formResponse"
const HIGH_SCORE_URL_GET = "https://docs.google.com/spreadsheets/d/11vNzrghZHSoruCnyuHzpRxK5ekZgTHT9_8hOsTtRyOo/gviz/tq"
const HS_DB_NAME_ID = "entry.1070984751"
const HS_DB_SCORE_ID = "entry.1915283213"
const HS_DB_DATE_ID = "entry.1672598346"
const HS_DB_FIELDNAME_NAME = "Name"
const HS_DB_FIELDNAME_SCORE = "High Score"
const HS_DB_FIELDNAME_DATE = "Date"
const HS_APP_SCORE = "High Score"
const HS_APP_NAME = "Name"
const HS_APP_DATE = "Date"
const HS_APP_PLACE = "Place"

const HANDS_URL_SUBMIT = "https://docs.google.com/forms/u/0/d/e/1FAIpQLSdSbKQ--MI9Lgoi7qMUbTBI3Xv2NwZI2bgQ8tORQnkVrRyI8w/formResponse"
const HANDS_DB_NAME_ID = "entry.1896296729"
const HANDS_DB_PLAYER_CARDS_IDS = [
"entry.2092062977",
"entry.1932792378",
"entry.1839917505",
"entry.57361537",
"entry.1321366139",
"entry.790428341" ]

const HANDS_DB_DEALER_CARDS_IDS = [
"entry.1621328961",
"entry.1988873726",
"entry.919654098",
"entry.373774427",
"entry.1666948582",
"entry.239047929" ]
const HANDS_DB_FIELDNAME_NAME = "Name"
const HANDS_DB_FIELDNAME_PLAYER = "Player Card "
const HANDS_DB_FIELDNAME_DEALER = "Dealer Card "

const BETS_URL_SUBMIT = "https://docs.google.com/forms/u/0/d/e/1FAIpQLSfG4ghGsWwxdcHYE3Uzvjk2N5Ek2ZG6nj24rF-XpKvtJ5afjA/formResponse"
const BETS_DB_NAME_ID = "entry.898112997"
const BETS_DB_TYPE_ID = "entry.745907306"
const BETS_DB_AMOUNT_ID = "entry.1081984229"
const BETS_DB_RESULT_ID = "entry.1212896191"
const BETS_DB_FIELDNAME_NAME = "Name"
const BETS_DB_FIELDNAME_TYPE = "Bet Type"
const BETS_DB_FIELDNAME_BET_AMT = "Bet Amount"
const BETS_DB_FIELDNAME_RESULTS = "Results"

const APP_DB_CONVERTER = {APP_NAME:US_DB_FIELDNAME_NAME, APP_BANKROLL:US_DB_FIELDNAME_CHIPS, 
APP_DEAL_SPEED:US_DB_FIELDNAME_SPEED }
#const db_app_converter = {db_field_user_name:app_name, db_field_bankroll:app_bankroll}
const US_DB_GFORM_CONVERTER = {US_DB_FIELDNAME_NAME:US_DB_NAME_ID, 
US_DB_FIELDNAME_CHIPS:US_DB_CHIPS_ID, 
US_DB_FIELDNAME_SPEED: US_DB_SPEED_ID
}
const HS_DB_GFORM_CONVERTER = {HS_DB_FIELDNAME_NAME:HS_DB_NAME_ID,
HS_DB_FIELDNAME_SCORE: HS_DB_SCORE_ID,
HS_DB_FIELDNAME_DATE: HS_DB_DATE_ID}

const BETS_DB_GFORM_CONVERTER = {
	BETS_DB_FIELDNAME_NAME: BETS_DB_NAME_ID,
	BETS_DB_FIELDNAME_TYPE: BETS_DB_TYPE_ID,
	BETS_DB_FIELDNAME_BET_AMT: BETS_DB_AMOUNT_ID,
	BETS_DB_FIELDNAME_RESULTS: BETS_DB_RESULT_ID
	}


var in_browser = OS.has_feature("web_macos")
var test_mode = false

var client = HTTPClient.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print ("in ready - persistance manager")
	if ! UserProfile.is_loaded():
		load_game_parms()
	else:
		load_high_scores()
	

func http_submit(_http, _response_code, _headers, _body, http):
	http.queue_free()
	
#func _http_request_completed(result, response_code, headers, body):
	#if result != HTTPRequest.RESULT_SUCCESS:
		#push_error("http error")
	#var data = JSON.parse_string(body.get_string_from_utf8())
	#var game_parms_dict = {}
	#for row_dict in data:
		#var name = row_dict[US_DB_FIELDNAME_NAME]
		#game_parms_dict[name] = {APP_BANKROLL:row_dict[US_DB_FIELDNAME_CHIPS], APP_NAME: name}
	#UserProfile.set_game_profile_db(game_parms_dict)
	##update_persistant_nodes() #need to wait for login from main
	#UserProfile.has_been_loaded()
	#pass	
	##print(data)

func user_settings_retreived(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("http error")
	var data_rows = convert_result_body_to_rows(body)
	var user_parms_dict = {}
	for row_dict in data_rows:
		var name = row_dict[US_DB_FIELDNAME_NAME]
		user_parms_dict[name] = {APP_BANKROLL:row_dict[US_DB_FIELDNAME_CHIPS], APP_NAME: name, 
		APP_DEAL_SPEED:row_dict[US_DB_FIELDNAME_SPEED]}
	UserProfile.set_game_profile_db(user_parms_dict)
	##update_persistant_nodes() #need to wait for login from main
	UserProfile.has_been_loaded()
	pass	
	
func convert_result_body_to_rows(http_result_body):
	var json = http_result_body.get_string_from_utf8()
	var result_string = fix_results_from_sheets(json)
	var parsed_json = JSON.parse_string(result_string)
	#get rows of dictionaries with the data in it.
	var data_rows = parse_sheet_data(parsed_json)
	return data_rows

func high_scores_retreived(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("http error")
	var data_rows = convert_result_body_to_rows(body)
	var hs_rows = []
	var i = 1
	for row_dict in data_rows:
		var  hs_row_dict  = {HS_DB_FIELDNAME_SCORE:row_dict[HS_APP_SCORE], 
		HS_APP_NAME: row_dict[HS_DB_FIELDNAME_NAME], 
		HS_APP_DATE:row_dict[HS_DB_FIELDNAME_DATE], HS_APP_PLACE:str(i)}
		hs_rows.append(hs_row_dict)
		i+=1
	UserProfile.set_scores_db(hs_rows)


#func read_from_db() -> void:
# This is dead code.  Get rid of it once I have a git hub commit
	#var http = HTTPRequest.new()
#
	#http.request_completed.connect(self._http_request_completed)
	#add_child(http)
	#
	##var err = http.request(URL_DATA,HEADERS,HTTPClient.METHOD_GET)
	##if err:
		##http.queue_free()

func read_user_settings_from_db():
	var http = HTTPRequest.new()
	var request_data ={
				"method": "GET",
				"mode": "no-cors"
			}
		
	http.request_completed.connect(self.user_settings_retreived)
	add_child(http)
	var err = http.request(USER_SETTING_URL_GET,HEADERS,HTTPClient.METHOD_GET)
	if err:
		http.queue_free()
		
func load_high_scores():
	var http = HTTPRequest.new()
	http.request_completed.connect(self.high_scores_retreived)
	add_child(http)
	var err = http.request(HIGH_SCORE_URL_GET,HEADERS,HTTPClient.METHOD_GET)
	if err:
		http.queue_free()
		
func write_to_us_db(data_dict) -> void: #US = User Settings
	http_update(data_dict,US_DB_GFORM_CONVERTER, USER_SETTING_URL_SUBMIT)
	
func http_update(data_dict, gfrom_converter, url) -> void:
	var http = HTTPRequest.new()
	var user_data_dict = {}
	if (gfrom_converter == null): #no conversion necessary
		user_data_dict = data_dict
	else:
		for key in data_dict.keys():
			var gform_key = gfrom_converter[key]
			user_data_dict[gform_key] = data_dict[key]
	var user_data = client.query_string_from_dict(user_data_dict)
	#print (user_data)
	http.connect("request_completed", http_submit)
	add_child(http)	
	var err = http.request(url,HEADERS,HTTPClient.METHOD_POST,user_data)
	if err:
		http.queue_free()
func get_new_http_request():
	var http = HTTPRequest.new()
	
func update_highscore_db(data_dict):
	http_update(data_dict, HS_DB_GFORM_CONVERTER, HIGH_SCORE_URL_SUBMIT)
	
func update_high_score():
	var db_record = {HS_DB_FIELDNAME_NAME:UserProfile.get_user_name(),
					HS_DB_FIELDNAME_SCORE:str(UserProfile.get_high_score()),
					HS_DB_FIELDNAME_DATE: Time.get_date_string_from_system(false)
					 }
	update_highscore_db(db_record)
	
func update_hands_data_base(player_hand_values, dealer_hand_values):
	var db_record = {HANDS_DB_NAME_ID:UserProfile.get_user_name()}
	for i in range(6):
		db_record[HANDS_DB_PLAYER_CARDS_IDS[i]]=str(player_hand_values[i])
		db_record[HANDS_DB_DEALER_CARDS_IDS[i]]=str(dealer_hand_values[i])
	http_update(db_record, null, HANDS_URL_SUBMIT )
	
func update_bets_data_base(data_dict):
	http_update(data_dict, BETS_DB_GFORM_CONVERTER, BETS_URL_SUBMIT)

func load_game_parms():
		if test_mode:
			broken_load_game_parms_from_file()
		else:
			load_game_parms_from_cloud()
			
	
	
func broken_load_game_parms_from_file():   #THIS IS NOW BROKEN !!!!!!
	var filename = "/Users/paullipkin/Downloads/savegame.save"
	#need to put in check for web browser.  Not sure if tools_menu is available yet
	if not FileAccess.file_exists(filename):
		return # Error! We don't have a save to load.

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open(filename, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data
		#game_parms_dict.merge(node_data) 
		update_persistant_objects()

func load_game_parms_from_cloud():
	if ! UserProfile.is_loaded():
		read_user_settings_from_db()


func update_persistant_objects():
	pass
	#if UserProfile.name_list_has(UserProfile.get_user_name()):
		#var save_nodes = get_tree().get_nodes_in_group("Persist")
		#var user_data = {}
		#for node in save_nodes:
			#if !node.has_method("load_parms"):
				#print("persistent node '%s' is missing a load_parms() function, skipped" % node.name)
				#continue
			## Call the node's save function.
			#var node_data = node.call("load_parms", UserProfile.parms_for_current_user())


func save_game_parms():
	if ! test_mode:
		save_game_parms_to_cloud()
	else:
		save_game_parms_to_file()

func save_game_parms_to_file():
	var save_file = FileAccess.open("/Users/paullipkin/Downloads/savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node has a save function.
		if !node.has_method("save"):
			#print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)
		#print (json_string)

func save_game_parms_to_cloud():
	#var save_nodes = get_tree().get_nodes_in_group("Persist")
	#var db_record = {}
	#for node in save_nodes:
		## Check the node has a save function.
		#if !node.has_method("save"):
			#print("persistent node '%s' is missing a save() function, skipped" % node.name)
			#continue
#
		## Call the node's save function.
		#var node_data = node.call("save") # an array of arrays
		#for node_array in node_data:
			#var key = app_db_converter[node_array[0]]
			#db_record[key] = node_array[1]

	var db_record = {}
	for key in UserProfile.parms_for_current_user().keys():
		var db_key = APP_DB_CONVERTER[key]
		db_record[db_key] = UserProfile.parms_for_current_user()[key]
	write_to_us_db(db_record)
		
func fix_results_from_sheets (string):
	##You get extra stuff when fetching data from google sheet.  remove the 
	## header and trailer information.  I hope this does not change
	var str
	str = string.substr(string.find("setResponse(")+"setResponse(".length())
	str = str.substr(0,str.find(");"))
	return str
	
func extract_date(date_time):
	return date_time.substr(date_time.find(" "))
	#var str = string.substr(string.find("rows\":")+6)
	#str = str.substr(0,str.find(",\"parsedNumHeaders\""))
	#return str
	#
#func sheets_row_parser(row):
	#data_array = row["c"]
	#for data_array
	#{"c":
#[
#{"v":"Date(2025,1,11,9,19,43)",
#"f":"2/11/2025 9:19:44"},
#{"v":"Paul"},
#{"v":99.0,"f":"99"},
#{"v":"Fast"}]}

func parse_sheet_data(json_structure):
	#return rows of dictionaries representing the sheet data
	var field_names = []
	var rows = []
	for col in json_structure["table"]["cols"]:
		field_names.append(col["label"])
	for json_row in json_structure["table"]["rows"]:
		var row = {}
		for i in range (json_row["c"].size()):	
			row[field_names[i]]=json_row["c"][i]["v"]
		rows.append(row)
		
	return rows
			
		
		
	
	
