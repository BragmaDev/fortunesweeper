class_name Formatter
extends Node


static func format_time_string(time : float) -> String:
	if time <= 0:
		return "--:--.--"
	
	var time_min = max(int(time / 60), 0)
	var time_sec = max(int(time) % 60, 0)
	var time_ms = max((time - int(time)) * 100, 0)
	return "%02d:%02d.%02d" % [time_min, time_sec, time_ms]
	

static func format_money_string(money : int) -> String:
	var string: String = str(money)
	if string.begins_with("-"):
		string.erase(0, 1)
	var length: int = string.length()
	var formatted: String
	
	for i in range(length):
		if((length - i) % 3 == 0 and i > 0):
			formatted = str(formatted, ",", string[i])
		else:
			formatted = str(formatted, string[i])
	
	if money < 0:
		formatted = "-$" + formatted
	else:
		formatted = "$" + formatted
	return formatted
