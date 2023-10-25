extends Control


var _pages = []
var _current_page = 0

onready var pages : Control = $Content/Pages
onready var prev_button : Button = $Content/PreviousButton
onready var next_button : Button = $Content/NextButton
onready var back_button : Button = $Content/BackButton


func _ready() -> void:
	prev_button.connect("pressed", self, "_on_prev_pressed")
	next_button.connect("pressed", self, "_on_next_pressed")
	back_button.connect("pressed", self, "_on_back_pressed")
	
	_pages = pages.get_children()
	_change_page(0)
	
	EventBus.emit_signal("transition_in_triggered")


func _process(_delta) -> void:
	if Input.is_action_just_pressed("pause"):
		SceneManager.change_scene_instant(SceneManager.MAIN_MENU_SCENE_PATH)


# Hide all pages and show the page with the index of page_num
func _change_page(page_num : int) -> void:
	for page in _pages:
		page.hide()
	
	_pages[page_num].show()

	# Toggle navigation buttons accordingly
	if _current_page == _pages.size() - 1:
		prev_button.set_visible(true)
		back_button.set_visible(false)
		next_button.set_disabled(true)
		
	elif _current_page == 0:
		prev_button.set_visible(false)
		back_button.set_visible(true)
		next_button.set_disabled(false)
		
	else:
		prev_button.set_visible(true)
		back_button.set_visible(false)
		next_button.set_disabled(false)


func _on_back_pressed() -> void:
	SceneManager.change_scene(SceneManager.MAIN_MENU_SCENE_PATH)
	back_button.set_disabled(true)
	next_button.set_disabled(true)


func _on_next_pressed() -> void:
	# Go to the next page
	_current_page = min( _pages.size() - 1, _current_page + 1 )
	_change_page(_current_page)
	

func _on_prev_pressed() -> void:
	# Go to the previous page
	_current_page = max( 0, _current_page - 1 )
	_change_page(_current_page)


