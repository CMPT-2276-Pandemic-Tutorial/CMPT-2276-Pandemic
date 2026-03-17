extends Node
var FILE_PATH = "res://boardInformation.json"

var cities = []
var num_of_cities = 0

#var cityCoords: Array[Vector2] = [
#	# Blue Cities
#	Vector2(-503, -348), # San Francisco ./
#	Vector2(-398, -378), # Chicago ./
#	Vector2(-367, -317), # Atlanta ./
#	Vector2(-315, -381), # Montréal ./
#	Vector2(-279, -322), # Washington ./
#	Vector2(-251, -372), # New York ./
#	Vector2(-101, -340), # Madrid ./
#	Vector2(-98, -421),  # London ./
#	Vector2(-36, -380),  # Paris ./
#	Vector2(-16, -437),  # Essen ./
#	Vector2(19, -396),   # Milan ./
#	Vector2(76, -453),   # St Petersburg ./
#
#	# Black Cities
#	Vector2(-18, -294),  # Algiers ./
#	Vector2(56, -349),   # Istanbul ./
#	Vector2(115, -305),  # Baghdad ./
#	Vector2(121, -397),  # Moscow ./
#	Vector2(178, -356),  # Tehran ./
#	Vector2(44, -278),   # Cairo ./
#	Vector2(193, -279),  # Karachi ./
#	Vector2(125, -231),  # Riyadh ./
#	Vector2(255, -302),  # Delhi ./
#	Vector2(312, -282),  # Kolkata ./
#	Vector2(202, -218),  # Mumbai ./
#	Vector2(266, -173),  # Chennai ./
#
#	# Red Cities
#	Vector2(360, -377),  # Beijing ./
#	Vector2(433, -381),  # Seoul ./
#	Vector2(364, -319),  # Shanghai ./
#	Vector2(491, -348),  # Tokyo ./
#	Vector2(498, -285),  # Osaka ./
#	Vector2(438, -261),  # Taipei ./
#	Vector2(372, -249),  # Hong Kong ./
#	Vector2(324, -212),  # Bangkok ./
#	Vector2(376, -153),  # Ho Chi Minh City ./
#	Vector2(456, -158),  # Manila ./
#	Vector2(324, -102),  # Jakarta ./
#	Vector2(504, 12),    # Sydney ./
#
#	# Yellow Cities
#	Vector2(-487, -265), # Los Angeles ./
#	Vector2(-409, -237), # Mexico City ./
#	Vector2(-315, -250), # Miami ./
#	Vector2(-322, -166), # Bogotá ./
#	Vector2(-205, -64),  # São Paulo ./
#	Vector2(-254, -2),   # Buenos Aires ./
#	Vector2(-351, -77),  # Lima ./
#	Vector2(-340, 15),   # Santiago ./
#	Vector2(-44, -182),  # Lagos ./
#	Vector2(8, -123),    # Kinshasa ./
#	Vector2(55, -40),    # Johannesburg ./
#	Vector2(62, -196),   # Khartoum ./
#]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var json = JSON.new()
	var file = FileAccess.open(FILE_PATH, FileAccess.READ)
	var json_text = file.get_as_text()
	var error = json.parse(json_text)
	file.close()
	if error == OK:
		var data_received = json.data
		num_of_cities = data_received["num_of_cities"]
		for i : int in num_of_cities:
			cities.append(City.new(data_received["cities"][i])) 
		for i : int in num_of_cities:
			print(cities[i].name)
	else:
		print("JSON Parse Error")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func findCity(cityName) -> City:
	for i in num_of_cities:
		if cities[i].get_city_name() == cityName:
			return cities[i]
	return null
	
func resetOutbreaks() -> void:
	for i in num_of_cities:
		cities[i].set_outbreak(false)
