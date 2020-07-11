extends AnimatedSprite

export var color = Color(50, 50, 255)

var draw_selection_shape = false

func draw_selection():
	draw_selection_shape = true
	update()

func stop_drawing_selection():
	draw_selection_shape = false
	update()

func _draw():
	if draw_selection_shape:
		var size = self.frames.get_frame(self.animation, self.frame).get_size()
		var left_pos = Vector2.ZERO - Vector2(size.x / 2, size.y / 2)
		draw_polyline(PoolVector2Array([left_pos, left_pos + Vector2(size.x, 0), 
				left_pos + Vector2(size.x, size.y), left_pos + Vector2(0, size.y), left_pos + Vector2()]), # close shape?
			color
		)
		# draw_circle(self.get_global_position(), diagonal_length, color)
