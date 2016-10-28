# initially just convert the existing Bash Script
# (create_with_index.sh to Ruby)
require 'colorize'
require 'fileutils'
# Command to run program with usage of 1.txt (instead of standard input, use standard file stream)
Prompt=">"
Welcome_prompt="Follow Instructions below to create new index file with organized sections"
Get_rails_repo_prompt="Enter Full path to the Rails Repo you are working in: "
Get_view_location_prompt="Enter Relative path to the specific VIEW location where all folders/files are to be placed: \n(e.g. app/views/home) \n"
Get_sections_prompt="\nEnter a list of EVERY section you want to create (one per line). ( e.g. Above the fold) and Enter Blankline to end input \n"

def welcome_prompt_and_starting_information()
  # puts Welcome_prompt.green
  puts "\n",Welcome_prompt.upcase.colorize(:color => :white, :background => :light_blue)

  print Get_rails_repo_prompt, "\n", Prompt
  @rails_repo = gets.chomp
  Dir.chdir(@rails_repo)
  # exec('cd ')
  counter_file="counter.txt"
  if File.file?(counter_file)
  	puts "Curr Dir: ", Dir.pwd
  	puts old_val=File.open(counter_file) {|f| f.readline}
  	File.open(counter_file,'w') {|f| f.write(old_val.to_i+1)}
  	@num=old_val.to_i+1
  else
  	File.new(counter_file,'w').puts("1")
  end
end

def get_view_location()
	print Get_view_location_prompt, "\n", Prompt
	@view_loc = gets.chomp
	Dir.chdir(@view_loc)
	puts Dir.pwd
	@controller_name=@view_loc
	@controller_name.slice!("app/views/")
	@controller_file="#{@rails_repo}/app/controllers/#{@controller_name}_controller.rb"
	puts "VALUE OF CONTROLLER FILE: #{@controller_file}"
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
	@indexfile_without_html="index#{@num}"
	header_file="/Users/seyonvasantharajan/Desktop/web_scripts/auto_generate_index/header.html.erb"
	@create_loc=@view_loc+"/landing#{@num}"
	puts "Current directory is #{Dir.pwd}"
	FileUtils.mkdir_p "landing#{@num}"
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
		if (line.include?("<body>"))
			puts "ASDASDLHALSDHASLDJH IN THE BODY!!!"
			newfile.print "<%=stylesheet_link_tag \"custom_landing#{@num}\"%>\n"
		end
		newfile.print line
	end
	File.rename(oldfile, "old.orig")
	File.rename(newfile,oldfile)
end
def create_divs_from_section()
	@full_section_text=[]
	@html_files=[]
	@sections.each do |s|
		e_dash=s.gsub(" ","-") 
		e_score=s.gsub(" ","_")
		# MAY HAVE TWO MORE ARRAYS(instance_variables here) so that they can be completed as 
		# required
		@id_name="lp#{@num}-#{e_dash}"
		@layout_name="#{@create_loc}/#{e_score}"
		@section_name=e_score

		

		# NEED TO INSERT THE CORRECT CONTENT INTO THEM NOW (render stylesheet and javascript)
		# <%= stylesheet_link_tag "goals/pick_goals" %>
		# ------------put html above this line
		# <div class="container">
		# /t <div class="row">
		# /t </div>
		# </div>
		# <%= javascript_include_tag "goals/pick_goals" %>

		stylesheet_name="#{@layout_name}"
		stylesheet_text="<%= stylesheet_link_tag \"#{stylesheet_name}\" %> \n"

		bootstrap_file="/Users/seyonvasantharajan/Desktop/web_scripts/auto_generate_index/bootstrap.html.erb"
		bootstrap_text=File.read(bootstrap_file)

		javascript_name="#{@layout_name}"
		javascript_text="<%= javascript_include_tag \"#{javascript_name}\" %> \n"

		@full_html_text=stylesheet_text+bootstrap_text+javascript_text
		# ========================================================
		# CREATES THE HTML FILES FOR USAGE
		html_file_name="#{@rails_repo}/app/views/#{@create_loc}/_#{e_score}.html.erb"
		puts "HTML_FILE_NAME: #{html_file_name}"
		# html_file=File.open(html_file_name,"w+")
		File.open(html_file_name,"w+") {|f| f.write(@full_html_text)}

		# --------------------------------------------------------
		# This is used to create section_text in indexfile
		lp_text="<div id=\"#{@id_name}\"> \n"		
		render_text="\t <%= render '#{@layout_name}' %> \n"
		end_div_text="</div> \n"

		full_text=lp_text+render_text+end_div_text
		@full_section_text.push(full_text)

		# ========================================================
		# Create the CSS and JS files in the correct location
		
		@stylesheet_loc="#{@rails_repo}/app/assets/stylesheets/#{@create_loc}"
		@javascript_loc="#{@rails_repo}/app/assets/javascripts/#{@create_loc}"


		FileUtils.mkdir_p @stylesheet_loc
		FileUtils.mkdir_p @javascript_loc

		@stylesheet_to_create="#{@stylesheet_loc}/#{@section_name}.css.less"
		@javascript_to_create="#{@javascript_loc}/#{@section_name}.js"

		File.open(@stylesheet_to_create,"w+") {|f| f.write("")}
		File.open(@javascript_to_create,"w+") {|f| f.write("")}

		# ========================================================
		# Add lines to the bottom of assets.rb
		precompile_line="\n Rails.application.config.assets.precompile += %w( "

		@line_css_for_assets="#{precompile_line}#{@create_loc}/#{@section_name}.css )"
		@line_js_for_assets="#{precompile_line}#{@create_loc}/#{@section_name}.js )"
		@line_for_custom_css="#{precompile_line}custom_landing#{@num}.css )"
		# append these two lines to the end of 
		assets_rb_file="#{@rails_repo}/config/initializers/assets.rb"

		File.open(assets_rb_file,"a") {|f| f.write(@line_css_for_assets) }
		File.open(assets_rb_file,"a") {|f| f.write(@line_js_for_assets) }
		File.open(assets_rb_file,"a") {|f| f.write(@line_for_custom_css) }

		
		# File.rename(newfile2, @routesfile)
		# ========================================================
		# Add lines to custom_landing#{@num}.css.less
		# It should be the id_name
		@section_comment="//-----------------------\n//Section: #{s}\n"
		@id_name="lp#{@num}-#{e_dash}"
		@id_modified="\##{@id_name}{\n\n}\n"
		@text_for_custom_css=@section_comment+@id_modified
		puts "CUSTOM_TEXT_FOR_CSS: #{@text_for_custom_css}"
		custom_file="#{@rails_repo}/app/assets/stylesheets/custom_landing#{@num}.css.less"
		File.open(custom_file,'a') {|f| f.write(@text_for_custom_css)}
		# ========================================================
	end
	# ========================================================
	# Appending get/index#{num} to routes file, right above the last line
	@routesfile="#{@rails_repo}/config/routes.rb"
	oldfile2 = File.open(@routesfile)
	newfile2 = File.open("#{@rails_repo}/config/new_file2.rb", "w+")

	oldfile2.each_line do |line|
		puts "line is #{line}"
		if (line.include?("end"))
			# now go through @full_section_text and output 
			puts "FOUND THE LINE "
			newfile2.print "\t get \'#{@view_loc}/index#{@num}\' \n"
		end
		newfile2.print line
	end
	newfile2.each_line do |line|
		puts "newfile line is: #{line}"
	end
	File.rename(oldfile2, "#{@rails_repo}/config/old2.orig")
	File.rename(newfile2, oldfile2)
	# ========================================================
	# Appending def index#{@num} \n end to app/controllers/
	# @controller_file already defined
	@controller_line_to_add="\n \t def index#{@num} \n end\n"
	oldfile2 = File.open(@controller_file)
	newfile2 = File.open("#{@rails_repo}/app/controllers/new_file2.rb", "w+")

	oldfile2.each_line do |line|
		puts "line is #{line}"
		# Only if it's the LAST line
		# if (line.include?("end"))
		if (line.match(/^end/))
			# now go through @full_section_text and output 
			puts "FOUND THE END LINE "
			@controller_line_to_add="\n \t def index#{@num} \n \t end \n"
			newfile2.print @controller_line_to_add
		end
		newfile2.print line
	end
	newfile2.each_line do |line|
		puts "newfile line is: #{line}"
	end
	File.rename(oldfile2, "#{@rails_repo}/app/controllers/old2.orig")
	File.rename(newfile2, oldfile2)	

	insert_divs_to_index()
end

def create_html_files()
	# put div container, div row in it by default
end

# make sure javascript RENDERS are after the html/css laods
def create_js_files()
end

def create_css_files()
end

def append_to_assetsrb()
end

def add_line_to_routes()
end

def generate_index_file()
	# current directory should be view_loc
	puts "SECTIONS: #{@sections}"
	puts @num
	copy_header_to_index()
	create_divs_from_section()
end

def print_all_vars()
	puts "@create_loc: #{@create_loc}"
	puts "@layout_name: #{@layout_name}"
	puts "@id_name: #{@id_name}"
	puts "@rails_repo: #{@rails_repo}"
	puts "@view_loc: #{@view_loc}"
	puts "@section_name: #{@section_name}"

	puts "@stylesheet_loc: #{@stylesheet_loc}"
	puts "@javascript_loc: #{@javascript_loc}"
end
welcome_prompt_and_starting_information()
get_view_location()
get_list_of_sections()
generate_index_file()
print_all_vars()