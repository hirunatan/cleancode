class
	CYL_GAME

create
	make

feature {NONE} -- Initialization

	make (letters: LIST [CHARACTER]; dictionary: DICTIONARY_TREE)
		do
			create {ARRAYED_SET [STRING]} words_found.make (0)
			combine_letters (letters, dictionary.root_node, create {ARRAYED_LIST [CHARACTER]}.make (0))
		end

feature -- Attributes

	words_found: ARRAYED_SET [STRING]

feature {NONE} -- Implementation

	combine_letters (letters: LIST [CHARACTER]; dict_node: DICTIONARY_NODE; current_word: ARRAYED_LIST [CHARACTER])
		local
			i, j: INTEGER
			letter: CHARACTER
			new_node: DICTIONARY_NODE
			new_letters: LIST [CHARACTER]
			new_word: ARRAYED_LIST [CHARACTER]
			word_string: STRING
		do
			from
				i := 1
			until
				i > letters.count
			loop
				letter := letters [i]

				if dict_node.has_letter(letter) then

					new_node := dict_node.subnode_for (letter)

					new_letters := letters.twin
					new_letters.go_i_th (i)
					new_letters.prune (letter)

					new_word := current_word.twin
					new_word.extend (letter)

					if new_node.is_word_end then
						word_string := ""
						across new_word as cwc loop
							word_string.extend (cwc.item)
						end
						words_found.extend (word_string)
					end

					combine_letters (new_letters, new_node, new_word)
				end

				i := i + 1
			end
		end
end
