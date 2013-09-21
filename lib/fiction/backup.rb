require "zip"
class Fiction
	def self.backup
		zip_filename = File.basename(Dir.getwd) + ".zip"
		FileUtils.rm(File.join(@wd,zip_filename)) if File.exists?(File.join(@wd,zip_filename))
		print "Generating backup..."
		files = Dir.glob("*.md")
		files += ["summary","config.yml","docs"]
		Zip::File.open(zip_filename,Zip::File::CREATE) do |zipfile|
			files.each do |file|
				unless File.directory? file
					zipfile.add(file,File.join(@wd,file))
				else
					Dir.glob(file+"/**/*").each do |path|
						if File.directory?(path)
							zipfile.add(path,path)
						else
							zipfile.add(path,path)
						end
					end
				end
			end
		end
		puts "done"
	end
end