require 'xcodeproj'
require 'pathname'
require 'fileutils'

# utilities
def add_locale(project_dir, project_name, code)
	lproj_folder = project_dir + "/" + project_name + "/" + code + ".lproj"
	localizable_file = "Localizable.strings"
	# create .lproj folder
	if !Dir.exists?(lproj_folder + "/" + localizable_file)
		if !Dir.exists?(lproj_folder)
			FileUtils.mkdir_p lproj_folder
			puts "Created folder: " + lproj_folder
		end
		# create file
		FileUtils.cp("./" + localizable_file, lproj_folder + "/" + localizable_file)
	end
end


# verify arguments
if ARGV.length != 2
	puts "We need exactly 2 arguments that is the path to your xcode project and location code"
	exit
end

# open project
project = Xcodeproj::Project.open(ARGV[0])

# get arguments
location_code = ARGV[1]
root_object = project.root_object
project_dir = Pathname(ARGV[0]).dirname.to_s
project_name = root_object.name


# add region
known_regions = root_object.known_regions
if !known_regions.include?("en")
	known_regions.push("en")
end
if !known_regions.include?(location_code)
	known_regions.push(location_code)
end

# add locale
add_locale(project_dir, project_name, "en")
add_locale(project_dir, project_name, location_code)

# get target
target = project.targets.first

# set flag
target.build_configurations.each do |config|
	config.build_settings['CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED'] = 'YES'
end

project.save