require "yaml"
require "redcarpet"
class Fiction
	def self.generate
		if File.exists? File.join(@wd,"config.yml")
			# prepare the html dir
			FileUtils.mkdir(File.join(@wd,"html")) unless File.exists? (File.join(@wd,"html"))
			FileUtils.rm_rf(Dir.glob("*.html"))
			FileUtils.rm_rf(Dir.glob("*.css"))
			FileUtils.cp(File.join(@tp,"style.css"),File.join(@wd,"html"))

			# load config file
			config = YAML.load_file(File.join(@wd,"config.yml"))

			# create index file
			print "Creating index file..."
			template_index = File.open(File.join(@tp,"template_story.html"),"r").read
			chapter_list = ""
			if config["chapters"].size > 0
				config["chapters"].each do |chapter|
					chapter_list = chapter_list + "<li><a href=\"#{chapter["file"]}.html\">#{chapter["title"]}</a></li>\n"
				end
			else
				chapter_list = "<p>There is no chapter on this story yet</p>"
			end

			# Summary
			summary = ""
			if File.exists? (File.join(@wd,"summary"))
				summary = File.open("summary","r").read
			end

			# assign variables
			template_index = template_index % {
				story_title: config["story"]["title"],
				author_name: config["story"]["author"],
				story_summary: summary,
				chapters: chapter_list
			}
			File.open(File.join(@wd,"html","index.html"),"w") {|f| f.write template_index}
			puts "done"

			# prepare the markdown parser
			markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:no_links => true,:filter_html => true),:autolink => false)

			chapter_number = 1
			
			# generate chapters
			if config["chapters"].size > 0
				config["chapters"].each do |chapter|
					print "Generating \"#{chapter['title']}\"..."
					md_file = chapter["file"] + ".md"
					md_content = File.open(File.join(@wd,md_file),"r").read
					html_content = markdown.render(md_content)
					template_html = File.open(File.join(@tp,"template_story_viewer.html"),"r").read
					template_html_content = template_html % {
						:story_title => config["story"]["title"],
						:story_subtitle => chapter["title"],
						author_name: config["story"]["author"],
						:content => html_content
					}
					File.open(File.join(@wd,"html","#{chapter['file']}.html"),"w"){|f| f.write(template_html_content)}
					puts "done"
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