extends GridContainer

@onready var grid = $"."

const COUNTER_ITEM = preload("res://components/counters/counter_item.tscn")

var counters : Array[CounterType] = []

func addCounter(counter: CounterType):
	var allCounters = grid.get_children()
	for counterNode : CounterItem in allCounters:
		if counter == counterNode.counter_data:
			print('matching')
			print(counterNode.counter_data.value)
			print(counter.value)
			counterNode.counter_data.value += counter.value
			counterNode.updateCounterValue(counterNode.counter_data.value + counter.value)
	if not counters.has(counter):
		counters.append(counter)
		var newCounter : CounterItem = COUNTER_ITEM.instantiate()
		newCounter.counter_data = counter
		grid.add_child(newCounter)
