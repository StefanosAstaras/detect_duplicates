#!/usr/local/bin/ruby -w
require 'digest/md5'

def usage()
  puts "Detect duplicate files"
  puts "Usage:"
  puts "[ruby ] detect_duplicates.rb [max_bytes_read] [top_directory]"
  puts "  max_bytes_read is the maximum number of bytes that the script will read from each file"
  puts "    default: 2000"
  puts "    use 0 to read entire files"
  puts "  top_directory is the directory from which the script will start its recursive search"
  puts "    default: current directiry"
  puts
end

logname = "dup_log.txt"
cwd = (!ARGV[0].nil? && Dir.exist?(ARGV[0])) ? ARGV[0] : "."  #top directory
bytes = (!ARGV[1].nil?) ? ARGV[1].to_i() : 1500               #bytes to read

#Check if logname is free to write on
if File.exist?(logname)
  if File.file?(logname)
    puts "A file with the name #{logname} already exists in the current directory."
    puts "Overwrite? [yes/NO]"
    if gets.chomp! == "yes"
      puts "Are you sure you want to overwrite? [yes/NO]"
      if gets.chomp! == "yes"
        puts "Will overwrite file #{logname}"
      else
        puts "Aborting."
        exit(1)
      end
    else
      puts "Aborting."
      exit(1)
    end
  else
    puts "Error: there is a non-file object with the name #{logname} in the current directory."
    puts "The filename #{logname} is needed to write the search results."
    puts "Aborting."
    exit(1)
  end
else
  puts "Will create file #{logname}"
end
