require 'xcodeproj'

# verify argument
if ARGV.length != 1
	puts "We need exactly 1 argument that is the path to your xcode project"
	exit
end

# open project
# puts ARGV[0]
project_path = ARGV[0]
project = Xcodeproj::Project.open(project_path)

target = project.targets.first
