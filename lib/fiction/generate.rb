require "yaml"
require "redcarpet"
require "sass"
class Fiction
	def self.generate(quiet=false)
		if File.exists? File.join(@wd,"config.yml")
			# prepare the html dir
			FileUtils.mkdir(File.join(@wd,"html")) unless File.exists? (File.join(@wd,"html"))

			# no longer used since CSS now injected in every page
			# FileUtils.cp(@config['default_template_style'],File.join(@wd,"html"))

			# render stylesheet (.css or .scss)
			template_style = File.open(@config['default_template_style'],"r").read
			template_style = Sass::Engine.new(template_style,syntax: :scss, :style=> :compressed).render

			# load config file
			config = YAML.load_file(File.join(@wd,"config.yml"))

			# create index file
			print "Creating index file..." unless quiet

			template_index = File.open(@config['default_template_index'],"r").read
			chapter_list = ""
			if config["chapters"].size > 0
				config["chapters"].each do |chapter|
					chapter_list = chapter_list + "<li><a href=\"#{File.basename(chapter['file'],".md")}.html\">#{chapter["title"]}</a></li>\n"
				end
			else
				chapter_list = "<p>There is no chapter on this story yet</p>"
			end

			# put summary to empty if there is no 'summary' file
			summary = ""
			if File.exists? (File.join(@wd,"summary"))
				summary = File.open("summary","r").read
			end

			# assign variables
			template_index = template_index % {
				story_title: config["story"]["title"],
				author_name: config["story"]["author"],
				story_summary: summary,
				chapters: chapter_list,
				style: template_style,
				version: Fiction::Version
			}

			File.open(File.join(@wd,"html","index.html"),"w") {|f| f.write template_index}
			puts "done"

			# prepare the markdown parser
			markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:no_links => true,:filter_html => true),:autolink => false)

			chapter_number = 1
			
			# generate chapters
			if config["chapters"].size > 0
				template_html = File.open(@config['default_template_chapter'],"r").read
				
				
				config["chapters"].each do |chapter|
					print "Generating \"#{chapter['title']}\"..." unless quiet
					md_file = chapter["file"]
					md_content = File.open(File.join(@wd,md_file),"r").read
					html_content = markdown.render(md_content)
					template_html_content = template_html % {
						:story_title => config["story"]["title"],
						:story_subtitle => chapter["title"],
						author_name: config["story"]["author"],
						style: template_style,
						:content => html_content
					}
					File.open(File.join(@wd,"html","#{File.basename(chapter['file'],".md")}.html"),"w"){|f| f.write(template_html_content)}
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