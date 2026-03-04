extends Node2D

var cityCoords: Array[Vector2] = [
	# Blue Cities
	Vector2(-503, -348), #San Fran
	Vector2(-398, -378), #Chicago
	Vector2(-367, -317), # Atlanta
	Vector2(-315, -381), # Montreal
	Vector2(-251, -372), # New York
	Vector2(-279, -322), # Washington
	Vector2(-98, -421), # London
	Vector2(-101, -340), # Madrid
	Vector2(-36, -380), # Paris
	Vector2(-16, -437), # Essen
	Vector2(19, -396), # Milan
	Vector2(76, -453), # St.Petersburg
	
	# Yellow Cities
	Vector2(-487, -265), # Los Angeles
	Vector2(-409, -237), # Mexico City
	Vector2(-315, -250), # Miami
	Vector2(-322, -166), # Bogota
	Vector2(-351, -77), # Lima
	Vector2(-340, 15), # Santiago
	Vector2(-205, -64), # Sao Paulo
	Vector2(-254, -2), # Buenos Aires
	Vector2(-44, -182), # Lagos
	Vector2(62, -196), # Khartoum
	Vector2(8, -123), # Kinshasa
	Vector2(55, -40), # Johannesburg
	
	# Black Cities
	Vector2(-18, -294), # Algiers
	Vector2(56, -349), # Istanbul
	Vector2(121, -397), # Moscow
	Vector2(44, -278), # Cairo
	Vector2(115, -305), # Baghdad
	Vector2(178, -356), # Tehran
	Vector2(125, -231), # Riyahd
	Vector2(193, -279), # Karachi
	Vector2(255, -302), # Delhi
	Vector2(202, -218), # Mumbai
	Vector2(266, -173), # Chennai
	Vector2(312, -282), # Kolkata
	
	# Red Cities
	Vector2(360, -377), # Beijing
	Vector2(433, -381), # Seoul
	Vector2(364, -319), # Shanghai
	Vector2(491, -348), # Tokyo
	Vector2(324, -212), # Bangkok
	Vector2(372, -249), # Hong Kong
	Vector2(438, -261), # Tripei
	Vector2(498, -285), # Osaka
	Vector2(324, -102), # Jakarta
	Vector2(376, -153), # Ho Chi Minh City
	Vector2(456, -158), # Manila
	Vector2(504, 12), # Sydney
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for city in cityCoords:
		var add_city = $Area2D.duplicate()
		add_city.position = city
		add_child(add_city)
	$Area2D.visible = false # to hide the original area at (0,0)
