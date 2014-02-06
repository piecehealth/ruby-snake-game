class Game

	require 'curses'

	TOP = 0
	BOTTOM = 22
	LEFT = 0
	RIGHT = 70

	include Curses

	def initialize
		Curses.init_screen

		Curses.noecho # Don't show typed key.
		Curses.stdscr.keypad(true)

		# colors
		Curses.start_color
		Curses.init_pair(COLOR_BLUE, COLOR_BLUE, COLOR_BLUE) # Color of boders
		Curses.init_pair(COLOR_RED, COLOR_RED, COLOR_RED)
		Curses.init_pair(COLOR_BLACK, COLOR_BLACK, COLOR_BLACK)
		Curses.init_pair(COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW)
		
		setup		
	end

	def start
		# Create a thread to montior key events
		key_listener = Thread.new do
			loop {Thread.current[:key] = Curses.getch}
		end

		while true
			handle_key key_listener[:key]
			if !@pause

				if @dead_snake # erase dead snake
					@dead_snake.body.each {|pos| erase pos}
					erase @dead_snake.food
					@dead_snake = false
				end

				tail = @snake.goto @direction

				if @snake.alive?
					draw_snake
					draw_food
					erase tail
					@speed += 1 if @snake.score / 100 > @speed - 1
				else
					@dead_snake = @snake.dup
					setup
					@message = "You die! Press 'S' to restart the game."
					@pause = true
				end

				draw_ui
				Curses.refresh
				sleep(0.2 * (0.8 ** (@speed - 1)))
			end
			
		end

	end

	private
	
	def setup
		@snake = Snake.new(RIGHT / 2 - 1, BOTTOM - 1)
		@score = 0
		@speed = 1
		@pause = false
		@direction = Snake::RIGHT
		@message = "Press 'P' to pause, Press 'Q' to quit."
	end

	def draw_ui
		# top border
		Curses.setpos(TOP, LEFT)
		Curses.attron(color_pair(COLOR_BLUE)|A_NORMAL) {Curses.addstr(' ' * RIGHT)}
		# bottom border
		Curses.setpos(BOTTOM, LEFT)
		Curses.attron(color_pair(COLOR_BLUE)|A_NORMAL) {Curses.addstr(' ' * RIGHT)}
		Curses.addstr(' ' * RIGHT)
		# left boder & right boder
		Curses.attron(color_pair(COLOR_BLUE)|A_NORMAL) do
			TOP.upto(BOTTOM) do |i|
				Curses.setpos(i, LEFT); Curses.addstr "  "
				Curses.setpos(i, RIGHT); Curses.addstr "  "
			end
		end
		Curses.setpos(BOTTOM + 1, LEFT)
		Curses.addstr("Score: #{@snake.score} Speed: #{@speed}, #{@message}.")
	end

	def draw_snake
		@snake.body.each do |pos|
			Curses.setpos(pos.y, (pos.x - 1) * 2)
			Curses.attron(color_pair(COLOR_RED)|A_NORMAL) {Curses.addstr "  "}
		end
	end

	def draw_food
		Curses.setpos(@snake.food.y, (@snake.food.x - 1) * 2)
		Curses.attron(color_pair(COLOR_YELLOW)|A_NORMAL) {Curses.addstr "  "}
	end

	def erase pos
		Curses.setpos(pos.y, (pos.x - 1) * 2)
		Curses.attron(color_pair(COLOR_BLACK)|A_NORMAL) {Curses.addstr "  "}
	end

	def handle_key key
		case key
		when 'q', 'Q'
			exit
		when 'p', 'P'
			@message = "Press 'S' to start, Press 'Q' to quit."
			@pause = true
			draw_ui
			Curses.refresh
		when 's', 'S'
			@message = "Press 'P' to pause, Press 'Q' to quit."
			@pause = false
		when Curses::Key::UP
			@direction = Snake::UP
		when Curses::Key::DOWN
			@direction = Snake::DOWN
		when Curses::Key::LEFT
			@direction = Snake::LEFT
		when Curses::Key::RIGHT
			@direction = Snake::RIGHT
		end
	end

end