require "redcarpet"
require "sass"
require "redcloth"
class Fiction
	def self.render(content,format)
		# prepare the markdown parser
		markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:no_links => true,:filter_html => true),:autolink => false)
		if format.match /^(md|markdown)$/
			compiled_content = markdown.render(content)

		elsif format == "textile"
			compiled_content = RedCloth.new(content).to_html
		elsif format == "sass"
			compiled_content = Sass::Engine.new(template_style,syntax: :scss, :style=> :compressed).render
		else
			puts "Fiction.render : Unknown format, returning raw content"
			compiled_content = content
		end

		return compiled_content
			
	end
end