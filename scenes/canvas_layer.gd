extends CanvasLayer

@export var leaderboard_internal_name: String = ""

@onready var turbo_text: RichTextLabel = $"Control/turbo text"
@onready var boost_anim: AnimationPlayer = $"Control/turbo text/AnimationPlayer"
@onready var start_text: RichTextLabel = $"start text"
@onready var current_time: RichTextLabel = $"current time"
@onready var best_time: RichTextLabel = $"best time"
@onready var congratulation_text: RichTextLabel = $"congratulation text"
@onready var checkpoint_ui: Control = $"checkpoint ui"
@onready var checkpoints_text: RichTextLabel = $"checkpoint ui/checkpoints text"
@onready var checkpoint_anim: AnimationPlayer = $"checkpoint ui/TextureRect/checkpoint anim"
@onready var car_rb: Car = $"../car_rb"
@onready var username: TextEdit = %Username
@onready var entries_container: VBoxContainer = %Entries
var entry_scene =  preload("uid://rrbrrh7ka5tq")

#making a timer
var sec_delta : float
var miliseconds : float
var seconds : float
var minutes : float 

var current_secdelta : float
var best_secdelta : float = 1000000


var checkpoints = 0

func _ready() -> void:
	turbo_text.visible = false
	congratulation_text.visible = false
	username.clear()
	best_time.text = "BEST TIME : %d:%d:%d" % [minutes, seconds, miliseconds]
	boost_anim.play("scaled")


func _process(delta: float) -> void:
	if car_rb.current_state == car_rb.Car_state.PAUSED :
		start_text.visible = true
		current_time.visible = false
		checkpoint_ui.visible = false
		username.visible = true
		username.editable = true
		entries_container.visible = true
		checkpoints = 0
		if Input.is_action_just_pressed("start"):
			congratulation_text.visible = false
			start_text.visible = false 
			current_time.visible = true
			checkpoint_ui.visible = true
			username.editable = false 
			username.visible = false
			entries_container.visible = false

			
			car_rb.current_state = car_rb.Car_state.IDLE
			sec_delta = 0

	if car_rb.current_state == car_rb.Car_state.IDLE:
		current_timer(delta)

	if car_rb.can_use_turbo :
		turbo_text.visible = true
	else :
		turbo_text.visible = false
		
	checkpoints_text.text = "CHECKPOINTS : %d/5" % [checkpoints]
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func current_timer(delta : float) -> void:
	#timer formula
	sec_delta += delta
	miliseconds = fmod(sec_delta *1000,1000)
	seconds = fmod(sec_delta,60)
	minutes = sec_delta/60
	current_time.text = "CURRENT TIME : %d:%d:%d" % [minutes, seconds, miliseconds]

func _on_finish_area_body_entered(body: Node3D) -> void:
	if body is Car:
		sec_delta = sec_delta
		current_secdelta = sec_delta
		if current_secdelta <= best_secdelta:
			best_secdelta = current_secdelta
			congratulation_text.visible = true
			best_time.text = "BEST TIME : %d:%d:%d" % [minutes, seconds, miliseconds]
			_on_submit_pressed(best_secdelta)


func _on_car_rb_check() -> void:
	checkpoints +=1
	checkpoint_anim.play("scaled")

func _on_submit_pressed(time:float) -> void:
	await Talo.players.identify("username", username.text)
	var score := time

	var res := await Talo.leaderboards.add_entry(leaderboard_internal_name, score)
	assert(is_instance_valid(res))

	_build_entries()
	
func _build_entries() -> void:
	for child in entries_container.get_children():
		child.queue_free()
	var options := Talo.leaderboards.GetEntriesOptions.new()
	options.page = 0
	var res := await Talo.leaderboards.get_entries(leaderboard_internal_name, options)
	var entries: Array[TaloLeaderboardEntry] = res.entries
	var count: int = res.count

	for entry in entries:
		if entry.position >9: return
		_create_entry(entry)

func _create_entry(entry: TaloLeaderboardEntry) -> void:
	var entry_instance = entry_scene.instantiate()
	entry_instance.set_data(entry)
	entries_container.add_child(entry_instance)
