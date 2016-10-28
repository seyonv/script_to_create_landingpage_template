def insert_line_before_another_line(filename,line_to_insert,line_to_find)
	# This function creates a secondary copy of the file, modifies this and only after this is fully completed
	# does it rename files
	oldfile=File.open(filename)
	newfile=File.open('new_file.txt','w')
	oldfile.each_line do |line|
		if (line.include?("#{line_to_find}"))
			newline.print "#{line_to_insert}"
		end
	end
	newfile.print line
	File.rename(oldfile, "old.orig")
	File.rename(newfile,oldfile)
	File.delete("old.orig")
end

# print each value of the newfile
newfile2.each_line {|line| puts "newfile line is: #{line}"}
