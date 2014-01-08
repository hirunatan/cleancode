class
	LIBRE_OFFICE_DICTIONARY

create
	make_from_file

feature {NONE} -- Initialization

	make_from_file (file: PLAIN_TEXT_FILE)
		local
			word: STRING
		do
			from
				create {ARRAYED_LIST [STRING]} words.make (0)
				file.next_line -- Skip initial line (words count)
			until
				file.end_of_file
			loop
				file.read_line
				word := extract_word (file.last_string)
				words.extend (word)
			end
		end

feature -- Attributes

	words: LIST [STRING]

feature -- Implementation

	extract_word (line: STRING): STRING
		local
			pos: INTEGER
			word: STRING
		do
			pos := line.index_of('/', 1)
			if pos > 0 then
				word := line.substring(1, pos - 1)
			else
				word := line.twin
			end
			word.replace_substring_all("á", "a")
			word.replace_substring_all("é", "e")
			word.replace_substring_all("í", "i")
			word.replace_substring_all("ó", "o")
			word.replace_substring_all("ú", "u")
			Result := word
		end

end
