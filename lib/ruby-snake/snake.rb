class Snake

	# Direction:
	UP = 0
	RIGHT = 1
	DOWN = 2
	LEFT = 3

	attr_reader :body, :food, :score

	def initialize width, height, length = 5
		@body = []
		@direction = RIGHT
		length.times  do |i| 
			@body << Pos.new(length - i + 1, height)
		end
		@width, @height = width, height
		@food = make_food
		@wall = []
		0.upto(width) do |i|
			@wall << Pos.new(i, 0)
			@wall << Pos.new(i, height + 1)
		end
		1.upto(height - 1) do |j|
			@wall << Pos.new(0, j)
			@wall << Pos.new(width + 1, j)
		end
		@alive = true
		@score = 0
	end

	def make_food
		food = Pos.new(rand(@width - 2) + 2, rand(@height - 1) + 1)
		while @body.include?(food)
			food = Pos.new(rand(@width - 2) + 2, rand(@height - 1) + 1)
		end
		food
	end

	def goto direction
		n_pos = next_pos direction
		tail = @body.last
		case
		when @wall.include?(n_pos) || @body.include?(n_pos)
			@alive = false
		when n_pos == @food
			eat n_pos
		else
			move n_pos
		end
		tail # when the snake moves, the UI class could know which cell should be erased.
	end

	def alive?
		@alive
	end

	def next_pos direction
		if [[RIGHT, LEFT], [UP, DOWN]].include? [direction, @direction].sort
			direction = @direction
		else
			@direction = direction
		end
		head = @body[0]
		case direction
		when UP
			Pos.new(head.x, head.y - 1)
		when DOWN
			Pos.new(head.x, head.y + 1)
		when RIGHT
			Pos.new(head.x + 1, head.y)
		when LEFT
			Pos.new(head.x - 1, head.y)
		end
	end

	def move pos
		@body.unshift pos
		@body.pop
	end

	def eat pos
		@body.unshift pos
		@food = make_food
		@score += 10
	end

	Pos = Struct.new :x, :y

end