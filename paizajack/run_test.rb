#!/usr/bin/ruby

if ARGV.length == 0
  STDERR.puts "Usage: #{$0} <path/to/target_script.rb>"
  exit 1
end

TARGET_SCRIPT=ARGV[0]

puts "TEST TARGET: #{TARGET_SCRIPT}"

buff = []
loop do
  line = STDIN.gets
  puts line
  break if line.nil?
  line = line.strip

  if line=='' 
    if buff.length>0
      expects = buff[0].split(' ').last
      expects = nil if expects == '--'
      lines = buff.map {|str| str = str.gsub(/\s*#.*$/, '').strip }.select{|x| x!=''}.join "\n"
      result = IO.popen("ruby #{TARGET_SCRIPT}", 'r+') do |io|
        io.puts lines
        io.close_write
        io.gets
      end
      exit 2 if $?!=0
      
      result = result.chomp
      puts "===> #{result}"

      if !expects.nil? && result != expects
        STDERR.puts "ERROR: expects '#{expects}', but actual '#{result}'. Input=#{lines}"
        exit 1
      end
      puts "     OK."

      buff = []
    end
  else
    buff << line
  end
end

puts "----- FINISH -----"
