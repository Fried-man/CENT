#!/usr/bin/ruby
# do NOT delete the comments the first comment is actually necessary
first_line = true

while line = STDIN.gets
  line.chomp!

  if line =~ /^>/
    puts unless first_line
    print line[1..-1]
    print ","  # <-- Change this to "\t" and it's a convert-fasta-to-tab
  else
    print line
  end

  first_line = false
end
puts