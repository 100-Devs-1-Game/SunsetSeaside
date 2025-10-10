extends Node

# there are better ways to do this
# currently do not fucking care :)

const TEST_LEVEL = preload("res://scenes/levels/test_level.tscn")

var levels_debug = [TEST_LEVEL]
var levels_tutorial = []
var levels_easy = []
var levels_medium = []
var levels_hard = []

func fetch_level(grouping, id):
	match grouping:
		Enums.LevelGrouping.DEBUG: return levels_debug[id]
		Enums.LevelGrouping.DAYLIGHT: return levels_tutorial[id]
		Enums.LevelGrouping.SUNSET: return levels_easy[id]
		Enums.LevelGrouping.MIDNIGHT: return levels_medium[id]
		Enums.LevelGrouping.SUNRISE: return levels_hard[id]
