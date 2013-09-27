require "fileutils"
require "yaml"
require "webrick"
require_relative "fiction/generate"
require_relative "fiction/generatedoc"
require_relative "fiction/backup"
require_relative "fiction/help"
class Fiction
	def self.new(wd,tp)
		@wd = wd
		@tp = tp
		# puts "@wd = #{@wd}"
		# puts "@tp = #{@tp}"
	end
	def self.create(title)
		if title.empty?
			puts "Title cannot be empty"
		else
			# make the directory
			dir_name = title.downcase.strip.gsub(/[^a-z1-9]/,"_").gsub(/\_{2,}/,"")
			target_dir = File.join(@wd,dir_name)
			unless File.exists?(target_dir)
				Dir.mkdir(target_dir)
				# copy config file
				FileUtils.cp(File.join(@tp,"config.yml"),target_dir)
				# change config file
				config = YAML.load_file(File.join(target_dir,"config.yml"))
				config["story"]["title"] = title
				File.open(File.join(target_dir,"config.yml"),"w") {|f| f.write(config.to_yaml)}
				# create html dir
				FileUtils.mkdir(File.join(target_dir,"html"))
				File.open(File.join(target_dir,"summary"),"w"){|f| f.write("#{title} summary, edit me in `summary` file")} 
				# create draft dir
				# FileUtils.mkdir(File.join(target_dir,"drafts"))
				puts "New story \"#{title}\" created in #{dir_name}"
			else
				puts "#{dir_name} already exists"
			end
		end
	end
	def self.chapter(title)
		if not (title.nil? or title.empty?)
			# check if there is config file in the folder
			if File.exists? File.join(@wd,"config.yml")
				# get new chapter number
				config = YAML.load_file(File.join(@wd,"config.yml"))
				new_chapter_number = config["chapters"].size + 1

				# add new content file
				filename = title.downcase.strip.gsub(/[^a-z1-9]/,"_").gsub(/\_{2,}/,"")
				filename = "#{new_chapter_number}.#{filename}"
				FileUtils.cp(File.join(@tp,"empty.md"),File.join(@wd,"#{filename}.md"))

				# modify config
				config["chapters"] = config["chapters"] + [{"title"=>title,"file"=>"#{filename}.md"}]
				File.open(File.join(@wd,"config.yml"),"w") {|f| f.write(config.to_yaml)}
				puts "Created new chapter \"#{title}\" in #{filename}.md"
			else
				puts "No config file found"
			end
		else
			puts "Title cannot be empty!"
		end
	end

	def self.serve(port=4000)
		include WEBrick
		puts "Running server at http://#{Socket.gethostname}:#{port}"
		server = HTTPServer.new(:Port=>port,:DocumentRoot=>File.join(@wd,"html"))
		trap("INT"){server.shutdown}
		server.start
	end

	def self.doc
		# check if there is config,
		if File.exists?(File.join(@wd,"config.yml"))
			# config = YAML.load_file(File.join(@wd,"config.yml"))
			# check if there is no doc folder
			if not File.exists?(File.join(@wd,"docs"))
				# create doc folder
				FileUtils.mkdir(File.join(@wd,"docs"))
				# create folders: character, location, time, plots, etc
				folders = %w{characters locations timeline plots}
				folders.each do |folder|
					puts "Creating #{folder}"
					FileUtils.mkdir(File.join(@wd,"docs",folder))
					FileUtils.touch(File.join(@wd,"docs",folder,"#{folder}.md"))
				end
			else
				puts "There is already docs folder"
			end
		else
			puts "No config file in here"
		end
	end

	
end