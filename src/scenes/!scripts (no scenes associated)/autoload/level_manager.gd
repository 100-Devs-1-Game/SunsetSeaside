extends Node

# there are better ways to do this
# currently do not fucking care :)

var path : NodePath
##### paths
const TEST_LEVEL = "res://scenes/levels/test_level.tscn"

var levels_debug = [TEST_LEVEL]
var levels_tutorial = []
var levels_easy = []
var levels_medium = []
var levels_hard = []

const grouping_ammo_amount = [2, 1, 1, 2, 2]
# grouping order: debug, tutorial, easy, medium, hard

func fetch_level_path(grouping, id):
	match grouping:
		Enums.LevelGrouping.DEBUG: return levels_debug[id]
		Enums.LevelGrouping.DAYLIGHT: return levels_tutorial[id]
		Enums.LevelGrouping.SUNSET: return levels_easy[id]
		Enums.LevelGrouping.MIDNIGHT: return levels_medium[id]
		Enums.LevelGrouping.SUNRISE: return levels_hard[id]

func fetch_ammo_amount(grouping):
	match grouping:
		Enums.LevelGrouping.DEBUG: return grouping_ammo_amount[0]
		Enums.LevelGrouping.DAYLIGHT: return grouping_ammo_amount[1]
		Enums.LevelGrouping.SUNSET: return grouping_ammo_amount[2]
		Enums.LevelGrouping.MIDNIGHT: return grouping_ammo_amount[3]
		Enums.LevelGrouping.SUNRISE: return grouping_ammo_amount[4]
