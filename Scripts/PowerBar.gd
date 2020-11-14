extends ProgressBar

func _ready():
	pass

func _physics_process(_delta):
	value = get_tree().root.get_node("/root/Forest/Player").power
