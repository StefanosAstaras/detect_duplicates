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