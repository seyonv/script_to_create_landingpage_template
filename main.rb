# initially just convert the existing Bash Script
# (create_with_index.sh to Ruby)
# require 'colorize'
# 
# Command to run program with usage of 1.txt (instead of standard input, use standard file stream)
Prompt=">"
Welcome_prompt="Follow Instructions below to create new index file with organized sections"
Get_rails_repo_prompt="Enter Full path to the Rails Repo you are working in: "
Get_view_location_prompt="Enter Relative path to the specific VIEW location where all folders/files are to be placed: \n(e.g. app/views/home) \n"
Get_sections_prompt="\nEnter a list of EVERY section you want to create (one per line). ( e.g. Above the fold) and Enter Blankline to end input \n"

def welcome_prompt_and_starting_information()
  # puts Welcome_prompt.green
  # puts "\n",Welcome_prompt.upcase.colorize(:color => :white, :background => :light_blue)

  print Get_rails_repo_prompt, "\n", Prompt
  rails_repo = gets.chomp
  Dir.chdir(rails_repo)
  # exec('cd ')
  counter_file="counter.txt"
  if File.file?(counter_file)
  	puts "Curr Dir: ", Dir.pwd
  	puts old_val=File.open(counter_file) {|f| f.readline}
  	File.open(counter_file,'w') {|f| f.write(old_val.to_i+1)}
  	@num=old_val.to_i+1
  else
  	# File.new("counter_file").puts("1")
  end
end

def get_view_location()
	print Get_view_location_prompt, "\n", Prompt
	@view_loc = gets.chomp
	Dir.chdir(@view_loc)
	puts Dir.pwd
end

def get_list_of_sections()
	print Get_sections_prompt,"\n",Prompt
	input=gets.chomp
	@sections=[]
	while input != ''
		@sections.push input
		print Prompt
		input=gets.chomp
	end
	puts "Sections: #{@sections}"
end

def copy_header_to_index()
	@indexfile="index#{@num}.html.erb"
	header_file="/Users/seyonvasantharajan/Desktop/web_scripts/auto_generate_index/header.html.erb"
	@create_loc=@view_loc+"/landing#{@num}"
	@create_loc.slice!("app/views/")
	File.open(header_file) do |input|
		File.open(@indexfile,"w") do |output|  
			while buff=input.read(4096)
				output.write(buff)
			end
		end
	end
end

def insert_divs_to_index()
	# Goal is to insert all of the divs (from element 1 to element n) right above </body>
	# Sequentially go through file, line-by-line and go to for loop IF you find 
	# a particular line ("</body>")
	oldfile = File.open(@indexfile)
	newfile = File.open("new_file.html.erb", "w")

	oldfile.each_line do |line|
		if (line.include?("</body>"))
			# now go through @full_section_text and output 
			@full_section_text.each do |t|
				newfile.print t
			end
		end
		newfile.print line
	endl
	File.rename(oldfile, "old.orig")
	File.rename(newfile,oldfile)
	# File.open("","")
end
def create_divs_from_section()
	@full_section_text=[]
	@sections.each do |s|
		e_dash=s.gsub(" ","-") 
		e_score=s.gsub(" ","_")
		# MAY HAVE TWO MORE ARRAYS(instance_variables here) so that they can be completed as 
		# required
		lp_text="<div id=\"lp#{@num}-#{e_dash}\"> \n"		
		render_text="\t <%= render '#{@create_loc}/#{e_score}' %> \n"
		end_div_text="</div> \n"
		full_text=lp_text+render_text+end_div_text
		@full_section_text.push(full_text)
	end
	insert_divs_to_index()
end

def create_html_files()
	# put div container, div row in it by default
end

def create_js_files()
end

def create_css_files()
end

def append_to_assetsrb()
end

def add_line_to_routes()
end

end
def generate_index_file()
	# current directory should be view_loc
	puts "SECTIONS: #{@sections}"
	puts @num
	copy_header_to_index()
	create_divs_from_section()
end

welcome_prompt_and_starting_information()
get_view_location()
get_list_of_sections()
generate_index_file()