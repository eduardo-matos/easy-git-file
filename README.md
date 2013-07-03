Easy Git File
=============

Facilita a recuperação dos arquivos modificados em certos commits e lista, além de também fornecer a possibilidade de recuperar os arquivos atualmente que estão sendo modificados.


# Utilização
	
##### Retorna uma lista com os nomes de todos os aquivos modificados no commit atual
> $ ruby main.rb

##### Retorna uma lista com os nomes de todos os arquivos que estão sendo modificados
> $ ruby main.rb -m

##### Retorna uma lista com os nomes de todos os arquivos modificados do commit abc12345
> $ ruby main.rb --commit=abc12345

##### Retorna uma lista com os nomes de todos os arquivos modificados nos ultima dos commit a partir do HEAD
> $ ruby main.rb --list=2

##### Retorna uma lista com os nomes de todos os arquivos modificados nos ultimos 5 commits a partir do commit abc12345
> $ ruby main.rb --list=5 --commit="abc12345" 