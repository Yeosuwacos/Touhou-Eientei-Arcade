extends HSlider

@export var bus := "BGM"
var b_index

func _ready() -> void:
	b_index = AudioServer.get_bus_index(bus)
	var c_db = AudioServer.get_bus_volume_db(b_index)
	value = db_to_linear(c_db)
	value_changed.connect(_on_volume_changed)
	$Txt_BGM.text = "Music: %d" % (value * 100)

func _on_volume_changed(val):
	var db = linear_to_db(val)
	$Txt_BGM.text = "Music: %d" % (value * 100)
	AudioServer.set_bus_volume_db(b_index, db)
