# Retorna o nome do branch atual
#   return string Nome do Branch
def get_branch_name
	puts IO.popen('git branch --no-abbrev').read.slice(2..-1)
end

def files_modified_in_commit commit = 'HEAD', num_commits_back = 0
	last = (num_commits_back.to_i + 1).to_s
	query = 'git log ' + commit + ' -' + last + ' --name-only --pretty="format:"'
	IO.popen(query).read.split(/[\r\n]+/).uniq.sort.reject! {|i| i.empty?}
end

# Retorna os arquivos que foram modificados
#   return array Lista com os arquivos modificados
def get_files_modified
	git_result = IO.popen('git status -u --porcelain').read
	git_result.split(/[\r\n]+/).uniq.sort
end

# Retorna os parametros passados no commad line em um HASH
#   return hash
@formated_commat_line = {}
def get_formated_commat_line_object
	require 'json'
	itens = JSON.parse ARGV.to_s
	map   = {}

	itens.each do |item|
		chave, valor = item.split('=')
		map[chave] = valor
	end
	@formated_commat_line = map

	@formated_commat_line
end

def get_formated_print_files list_files
   get_formated_commat_line_object.has_key?('--format') ? list_files.join(',') : list_files
end


options = get_formated_commat_line_object

list_files_git = []

if options.size == 0
	list_files_git = get_files_by_commit
else
  
  if options.has_key?('--list') and options['--list'] == nil
    puts "\nQuando --list for definido, ele sempre deve conter um valor\n\n"
    exit
  end

  if options.has_key?('-m') 
    list_files_git = get_files_modified
  
  elsif options.has_key?('--list') and options.has_key?('--commit')
      list_files_git = get_files_last_commits options['--list'].to_i, options['--commit']
	
  elsif options.has_key?('--list') and !options.has_key?('--commit')
       list_files_git = get_files_last_commits options['--list'].to_i
  
  elsif options.has_key?('--commit') and !options.has_key?('--list') 
      list_files_git = get_files_by_commit options['--commit']
  
  end
end

puts get_formated_print_files list_files_git
