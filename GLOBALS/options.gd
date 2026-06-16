extends Node

var music_volume: float = 30.0
var effect_volume: float = 50.0

var min_volume: float = -30.0
var max_volume: float = 30.0

func change_music_volume(new_volume: float) -> void:
	music_volume = new_volume
	var bus_index := AudioServer.get_bus_index("Music")
	if new_volume == 0.0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(bus_index, remap(new_volume, 0.0, 100.0,min_volume,max_volume))

func change_sfx_volume(new_volume: float) -> void:
	effect_volume = new_volume
	var bus_index := AudioServer.get_bus_index("Effects")
	if new_volume == 0.0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(bus_index, remap(new_volume, 0.0, 100.0,min_volume,max_volume))

func get_current_music_volume() -> float:
	return music_volume

func get_current_effect_volume() -> float:
	return effect_volume
