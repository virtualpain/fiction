class Fiction
	def self.generate_doc
		#check config file
		if File.exists?(File.join(@wd,"config.yml"))
			config = YAML.load_file(File.join(@wd,"config.yml"))

			# prepare the markdown parser
			markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:no_links => true,:filter_html => true),:autolink => false)

			# check doc folder
			if File.exists?(File.join(@wd,"docs"))
				docs_dir = File.join(@wd,"docs")
				# clean html/docs/
				FileUtils.mkdir(File.join(@wd,"html","docs")) unless File.exists?(File.join(@wd,"html","docs"))
				# initialize index file content
				index_file = "<h1><a href='../index.html'>#{config["story"]["title"]}</a></h1>"
				template_file = File.open(File.join(@tp,"empty.html"),"r").read
				template_style = File.open(File.join(@tp,"style.css"),"r").read
				# loop through folder
				doc_folders = Dir.entries(File.join(@wd,"docs")).select {|d| File.directory?(File.join(@wd,"docs")) and !(d == "." or d == "..")}
				index_file = index_file + "<ul>"
				doc_folders.each do |folder|
					# puts folder + "/"
					# generate folder with same name in html/docs/
					puts "Created #{folder}"
					FileUtils.mkdir(File.join(@wd,"html","docs",folder)) unless File.exists?(File.join(@wd,"html","docs",folder))
					# loop the files inside /docs/x/
					doc_files = Dir[File.join(@wd,"docs",folder,"*.md")]
					index_file += "\n\t<li><strong>#{folder.capitalize}</strong>:\n\t\t<ul>"
					doc_files.each do |file|
						# create html file in /html/docs/x/
						# puts "#{folder}/#{file}"
						raw_doc_content = File.open(file,"r").read
						content = template_file % {
							:title => folder,
							:content => "<p><a href='../index.html'>Back to documentation</a></p>" + markdown.render(raw_doc_content),
							:style=>template_style}
						File.open(File.join(@wd,"html","docs",folder,File.basename(file,"md")+"html"),"w"){|f| f.write content}
						puts "Generated #{File.basename(file,".md")}.html"
						filename = File.basename(file,".md")
						index_file += "\n\t\t\t<li><a href='#{folder}/#{filename+".html"}'>#{filename.capitalize}</a></li>"
					end
					index_file += "\n\t\t</ul>\n\t</li>"
				end
				index_file += "</ul>"
				# create index file
				index_content = template_file % {
					:title => "Documentation of #{config["story"]["title"]}",
					:style => template_style,
					:content => index_file
				}
				File.open(File.join(@wd,"html","docs","index.html"),"w"){|f| f.write index_content}
				puts "Index file created"
			end
		end
	end
end