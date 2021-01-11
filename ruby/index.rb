require 'xcodeproj'

# verify arguments
if ARGV.length != 2
	puts "We need exactly 2 arguments that is the path to your xcode project and location code"
	exit
end

# get arguments
project_path = ARGV[0]
location_code = ARGV[1]

# open project
project = Xcodeproj::Project.open(project_path)

# add region
known_regions = project.root_object.known_regions
if !known_regions.include?(location_code)
	known_regions.push(location_code)
end

# get target
target = project.targets.first

target.build_configurations.each do |config|
	config.build_settings['CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED'] = 'YES'
end

project.save