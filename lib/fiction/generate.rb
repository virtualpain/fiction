require "yaml"
require "redcarpet"
require "sass"
require "liquid"
class Fiction
	def self.generate(quiet=false)
		if File.exists? File.join(@wd,"config.yml")
			# prepare the html dir
			FileUtils.mkdir(File.join(@wd,"html")) unless File.exists? (File.join(@wd,"html"))

			# no longer used since CSS now injected in every page
			# FileUtils.cp(@config['default_template_style'],File.join(@wd,"html"))

			# load config file
			config = YAML.load_file(File.join(@wd,"config.yml"))

			# check if using own template
			using_own_template = config["settings"]["template"]

			# render stylesheet (.css or .scss)
			if not using_own_template
				template_style = File.open(@config['default_template_style'],"r").read
			else
				template_style = File.open( File.join() ,"r").read
			end
			template_style = Fiction.render(template_style,'sass')

			# create index file
			print "Creating index file..." unless quiet

			
			# put summary to empty if there is no 'summary' file
			summary = ""
			if File.exists? (File.join(@wd,"summary"))
				summary = File.open("summary","r").read
			end

			# render liquid template
			if not using_own_template
				template_index = File.open(@config['default_template_index'],"r").read
			else
				template_index = File.open( File.join(@wd,"template","index.html") )
			end
			template = Liquid::Template.parse(template_index)
			compiled_template = template.render(
				'title' => config["story"]["title"],
				'author' => config["story"]["author"],
				'summary' => summary,
				'chapters' => config["chapters"],
				'style' => template_style,
				'version' => Fiction::Version
			)

			File.open(File.join(@wd,"html","index.html"),"w") {|f| f.write compiled_template}
			puts "done"

			chapter_number = 1
			
			# generate chapters
			if config["chapters"].size > 0
				config["chapters"].each do |chapter|
					print "Generating \"#{chapter['title']}\"..." unless quiet
					raw_file = chapter["file"]
					raw_content = File.open(File.join(@wd,raw_file),"r").read

					# rendering content
					if config["settings"]["format"].nil?
						config["settings"]["format"] = 'md'
					end
					compiled_content = Fiction.render(raw_content,config["settings"]["format"])

					# rendering liquid template
					if not using_own_template
						template_html = File.open(@config['default_template_chapter'],"r").read
					else
						template_html = File.open( File.join(@wd,"template","chapter.html") ,"r").read
					end
					template_html_content = Liquid::Template.parse(template_html)
					compiled_chapter_template = template_html_content.render(
						'title' => config["story"]["title"],
						'chapter' => chapter["title"],
						'author' => config["story"]["author"],
						'style' => template_style,
						'content' => compiled_content
					)
					File.open(File.join(@wd,"html","#{chapter['file']}.html"),"w"){|f| f.write(compiled_chapter_template)}
					puts "done" unless quiet
					chapter_number += 1
				end
			else
				puts "There is no chapter found"
			end
		else
			puts "Config file not found!"
		end
	end
end