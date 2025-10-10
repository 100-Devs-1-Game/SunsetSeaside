extends Node

# there are better ways to do this
# currently do not fucking care :)

# brainstorming level information storage:
# need to store it as an array of arrays containing data
# one containing specifics: 
# # of shots completed in (index 0) 
# record time (index 1) 
# was par met (index 2)
# was time limit met (index 3)
# was jug collected (index 4)
# 4 arrays, one for each grouping (debug unneeded)

var path : NodePath
##### paths
const TEST_LEVEL = "res://scenes/levels/test_level.tscn"

var levels_debug = [TEST_LEVEL]
var levels_tutorial = []
var levels_easy = []
var levels_medium = []
var levels_hard = []

func fetch_level_path(grouping, id):
	match grouping:
		Enums.LevelGrouping.DEBUG: return levels_debug[id]
		Enums.LevelGrouping.DAYLIGHT: return levels_tutorial[id]
		Enums.LevelGrouping.SUNSET: return levels_easy[id]
		Enums.LevelGrouping.MIDNIGHT: return levels_medium[id]
		Enums.LevelGrouping.SUNRISE: return levels_hard[id]
