class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Program entry point
		do
			print ("Leyendo diccionario%N")
			create_dictionary
			run
		end

	dictionary: DICTIONARY_TREE

	create_dictionary
		local
			dict_file: PLAIN_TEXT_FILE
			lo_dict: LIBRE_OFFICE_DICTIONARY
		do
			create dict_file.make_open_read ("../dictionary/es_ES.dic")
			create lo_dict.make_from_file(dict_file)
			dict_file.close
			create dictionary.make_from_words(lo_dict.words)
		end

feature {NONE} -- User interface

	run
			-- Main loop
		local
			quit: BOOLEAN
			letters: LIST [CHARACTER]
			game: CYL_GAME
		do
			from
				quit := false
			until
				quit = true
			loop
				letters := ask_for_letters
				if letters.count > 0 then
					game := create_game(letters)
					display_solution (game)
				else
					quit := true
				end
			end
			print ("Fin%N")
		end

	ask_for_letters: LIST [CHARACTER]
		local
			letters: LIST [CHARACTER]
			letter: CHARACTER
		do
			print ("Escribe las letras%N")
			create {ARRAYED_LIST [CHARACTER]} letters.make (0)
			from
				io.read_line
			until
				io.last_string.count = 0
			loop
				letter := io.last_string[1]
				letters.extend(letter)
				io.read_line
			end
			Result := letters
		end

	create_game (letters: LIST [CHARACTER]): CYL_GAME
		do
			print ("Calculando...%N")
			create Result.make(letters, dictionary)
		end

	display_solution (game: CYL_GAME)
		do
			print ("Estas son las combinaciones:%N")
			across game.words_found as wc loop
				print (wc.item)
				print ("%N")
			end
			print ("%N")
		end
end
