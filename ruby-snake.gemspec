Gem::Specification.new do |s|

	s.name			= 'ruby-snake'
	s.version		= '0.0.1' 
	s.executables 	= ['ruby-snake'] 
	s.date			= '2014-02-07'
	s.summary		= 'Terminal(command line) Snake Game.'
	s.description	= 'Writed by Ruby, Curses.'
	s.authors 		= ['Zhang Kang']
	s.email			= 'piecehealth@sina.com'
	s.files			= [
						'lib/ruby-snake.rb',
						'lib/ruby-snake/snake.rb',
						'lib/ruby-snake/game.rb'
						]
	s.add_development_dependency 'curses'
	s.homepage		= 'https://github.com/piecehealth/snake-game-ruby'
	s.licenses = ["MIT"]
end