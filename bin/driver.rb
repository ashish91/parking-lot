#!/usr/bin/ruby
require 'pry'
require 'pry-nav'

require File.join(Dir.pwd, 'bin/require_tree')

FILENAME = ARGV[0]

$parking_service = ParkingService.new
def execute(line)
  command, args = CommandParserService.parse_line(line)
  CommandValidatorService.validate(command, args)

  result = $parking_service.send(command, *args)
  OutputFormatterService.send(command, result)
rescue Command::Invalid => e
  puts e.message
end

if FILENAME
  if File.exists?(FILENAME)
    File.foreach(FILENAME) do |line|
      execute(line)
    end
  else
    puts "File #{FILENAME} doesn't exist."
  end
else
  input = gets.chomp.strip
  while input != 'exit'
    execute(input)

    input = gets.chomp.strip
  end
end

