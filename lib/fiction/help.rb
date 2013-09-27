class Fiction
	def self.help
		commands = {
			:help => "Show this text",
			:new => "Generate new story",
			:chapter => "Generate new chapter in a story",
			:generate => "Generate HTML of the chapters",
			:doc => "Create docs directory for planning",
			:generatedoc => "Generate HTML version of the docs",
			:serve => "Generate chapters and create local server (default port 4000)",
			:backup => "Generate backup of the story"
		}
		puts "Available commands:"
		commands.each do |key,command|
			puts "#{key} : #{command}"
		end
	end
end