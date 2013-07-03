# Retorna o nome do branch atual
#   return string Nome do Branch
def get_branch_name
	git_result = IO.popen('git rev-parse --abbrev-ref HEAD').read
	return git_result.to_s.slice(0, -1)
end

# Retorna os aquivos modificados no commit passado
#   return array Lista dos arquivos modificados
def get_files_by_commit commit = 'HEAD'
	query = 'git show ' + commit + ' --name-only --pretty="format:"'
	git_result = IO.popen(query).read
	return git_result.split(/[\r\n]+/).uniq.sort.reject! {|i| i.empty?}
end

# Retorna os arquivos dos ultimos commits
#   return array Lista dos arquivos modificados dos ultimos commits
def get_files_last_commits num_last = 1, commit = 'HEAD' # 1 == HEAD, 2 == HEAD + HEAD~1...
	last = (num_last.to_i * -1).to_s
	query = 'git log ' + commit +' '+ last + ' --name-only --pretty="format:"'
	git_result = IO.popen(query).read
  return git_result.split(/[\r\n]+/).uniq.sort.reject! {|i| i.empty?}
end

# Retorna os arquivos que foram modificados
#   return array Lista com os arquivos modificados
def get_files_modified
	git_result = IO.popen('git status -u --porcelain').read
	return git_result.split(/[\r\n]+/).uniq.sort
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

	return @formated_commat_line
end

def get_formated_print_files list_files
   return get_formated_commat_line_object.has_key?('--format') ? list_files.join(',') : list_files
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
