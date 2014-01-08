class
	DICTIONARY_TREE

create
	make_from_words

feature {NONE} -- Initialization

	make_from_words (words: LIST [STRING])
		do
			create root_node.make
			across words as wc loop
				add_word (wc.item)
			end
		end

feature -- Attributes

	root_node: DICTIONARY_NODE

feature {NONE} -- Implementation

	add_word (word: STRING)
		local
			node: DICTIONARY_NODE
			letter: CHARACTER
		do
			node := root_node
			across word as wc loop
				letter := wc.item
				if not node.has_letter (letter) then
					node.add_subnode_for (letter)
				end
				node := node.subnode_for (letter)
			end
			node.set_is_word_end
		end
end
