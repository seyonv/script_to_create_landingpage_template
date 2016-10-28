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

def print_all_vars()
	puts "@create_loc: #{@create_loc}"
	puts "@layout_name: #{@layout_name}"
	puts "@id_name: #{@id_name}"
	puts "@rails_repo: #{@rails_repo}"
	puts "@view_loc: #{@view_loc}"
	puts "@controller_name: #{@controller_name}"
	puts "@section_name: #{@section_name}"

	puts "@stylesheet_loc: #{@stylesheet_loc}"
	puts "@javascript_loc: #{@javascript_loc}"
end