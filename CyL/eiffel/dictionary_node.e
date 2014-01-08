note
	description: "Summary description for {DICTIONARY_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DICTIONARY_NODE

create
	make

feature {NONE} -- Initialization

	make
		do
			create subnodes.make (0)
			is_word_end := false
		end

feature {DICTIONARY_TREE} -- Creation

	add_subnode_for (letter: CHARACTER)
		do
			subnodes.put(create {DICTIONARY_NODE}.make, letter)
		end

	set_is_word_end
		do
			is_word_end := true
		end

feature -- Access

	is_word_end: BOOLEAN

	has_letter (letter: CHARACTER): BOOLEAN
		do
			Result := subnodes.has_key (letter)
		end

	subnode_for (letter: CHARACTER): DICTIONARY_NODE
		require
			node_exists: has_letter (letter)
		local
			subnode: detachable DICTIONARY_NODE
		do
			subnode := subnodes @ letter
			if attached subnode as s then
				Result := s
			else
				create Result.make -- This should not occur, is only for void safety
			end
		end

feature {NONE} -- Implementation

	subnodes: HASH_TABLE [DICTIONARY_NODE, CHARACTER]

end
