extends Node

# processing time toggle
var time = 0.0

func _ready(): stop()
func _process(delta): time += delta

func start(): set_process(true)
func stop(): set_process(false)
func reset(): set_process(false); time = 0.0
