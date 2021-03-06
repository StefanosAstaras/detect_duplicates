#!/usr/local/bin/ruby -w
require 'digest/md5'

def usage()
  puts "Detect duplicate files"
  puts "Usage:"
  puts "[ruby ] detect_duplicates.rb [max_bytes_read] [top_directory]"
  puts "  max_bytes_read is the maximum number of bytes that the script will read from each file"
  puts "    default: 1500000"
  puts "    use 0 to read entire files"
  puts "  top_directory is the directory from which the script will start its recursive search"
  puts "    default: current directory"
  puts
end

if !ARGV[0].nil? && ARGV[0].to_s()[0] == '-'
  #User tried to get help - probably passed --help -h --usage etc.
  usage()
  exit(0)
end

logname = "dup_log.txt"
cwd = (!ARGV[0].nil? && Dir.exist?(ARGV[0])) ? ARGV[0] : "."  #top directory
cwd = File.expand_path(cwd)                                   #absolute path for logging
bytes = (!ARGV[1].nil?) ? ARGV[1].to_i() : 1_500_000          #bytes to read

Dir.chdir(cwd)

#Check if logname is free to write on
if File.exist?(logname)
  if File.file?(logname)
    puts "A file with the name #{logname} already exists in the current directory."
    puts "Overwrite? [yes/NO]"
    if gets.chomp! == "yes"
      puts "Are you sure you want to overwrite? [yes/NO]"
      if gets.chomp! == "yes"
        puts "Will overwrite file #{logname}"
        File.delete(logname)
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

#Start!
puts "Starting duplicate file detection on #{cwd} with a #{bytes}-byte limit."
puts "Getting list of files..."
hashes = {}
files_with_errors = []
filenames = Dir.glob("**/*").select {|i| File.file?(i)}
filenames.map! {|i| File.expand_path(i)}
filenames.each.with_index do |f, i|
  begin
  
    #get plaintext
    if (bytes > 0)
      plaintext = File.size(f).to_s() + File.read(f, bytes)
    else
      plaintext = File.size(f).to_s() + File.read(f)
    end
	
	#calculate hash
    hash = Digest::MD5.hexdigest(plaintext)
	
	#create array or push to existing array
    if hashes.has_key?(hash)
	  hashes[hash].push f
    else
	  hashes[hash] = [f]
    end
	
  rescue
  
    #something went wrong?
    puts "Error reading file #{f}!"
    files_with_errors.push f
	
  end
  puts "Completed file #{i} of #{filenames.size}"
end

#Time to dump results
puts "Finished calculating. Writing results..."
File.open(logname, "w") do |log_file|
  log_file.write("Completed detect_duplicates.rb on #{Time.now} from #{cwd} with #{bytes} byte limit.\n")
  log_file.write("Start of log:\n\n")
  
  hashes.each_value do |ifiles|
    if ifiles.size > 1
      log_file.write("-----Identical files-----\n")
      ifiles.each {|i| log_file.write(i + "\n")}
      log_file.write("-------------------------\n")
    end
  end
  
  if !files_with_errors.empty?
    log_file.write("-----Error reading these files-----\n")
    files_with_errors.each {|i| log_file.write(i + "\n")}
    log_file.write("-----------------------------------\n")
  end
  
  log_file.write("\nEnd of log.")
end

puts "Done! [press return to close]"
gets
