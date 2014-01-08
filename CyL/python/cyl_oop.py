# encoding: utf-8

class MainDialog(object):

    def __init__(self):
        self.__create_dictionary()

    def run(self):
        while True:
            letters = self.__ask_for_letters()
            if len(letters) == 0:
                break
            game = self.__create_game(letters)
            self.__display_solution(game)

    def __create_dictionary(self):
        dict_file = open('../dictionary/es_ES.dic')
        lo_dict = LibreOfficeDictionary(dict_file)
        dict_file.close()
        self.__dictionary = DictionaryTree(lo_dict.words)

    def __ask_for_letters(self):
        print 'Escribe las letras'
        letters = []
        while True:
            letter = raw_input()
            if letter == '':
                break
            letters.append(letter)

        return letters

    def __create_game(self, letters):
        return CyLGame(letters, self.__dictionary)

    def __display_solution(self, game):
        print 'Éstas son las combinaciones:'
        for word in game.words_found:
            print word
        print


class LibreOfficeDictionary(object):

    def __init__(self, dict_file):
        self.__words = []
        dict_file.readline() # Skip initial line (words count)
        for line in dict_file.readlines():
            word = self.__extract_word(line)
            self.__words.append(word)

    @property
    def words(self):
        return self.__words

    def __extract_word(self, line):
        word = line.decode('iso-8859-15')
        if word.endswith('\n'):
            word = word[:-1]
        if word.find('/') >= 0:
            word = word.split('/')[0]

        word = word.replace(u'á', u'a')
        word = word.replace(u'é', u'e')
        word = word.replace(u'í', u'i')
        word = word.replace(u'ó', u'o')
        word = word.replace(u'ú', u'u')

        return word


class DictionaryTree(object):

    def __init__(self, words):
        self.__root_node = DictionaryNode()
        for word in words:
            self.__add_word(word)

    @property
    def root_node(self):
        return self.__root_node

    def __add_word(self, word):
        node = self.__root_node
        for letter in word:
            if not node.has_letter(letter):
                node._add_letter(letter)
            node = node.subnode_for(letter)
        node._set_is_word_end()


class DictionaryNode(object):

    def __init__(self):
        self.__subnodes = {}
        self.__is_word_end = False

    @property
    def is_word_end(self):
        return self.__is_word_end

    def has_letter(self, letter):
        return self.__subnodes.has_key(letter)

    def subnode_for(self, letter):
        return self.__subnodes[letter]

    def _add_letter(self, letter):
        self.__subnodes[letter] = DictionaryNode()

    def _set_is_word_end(self):
        self.__is_word_end = True


class CyLGame(object):

    def __init__(self, letters, dictionary):
        self.__words_found = set()
        self.__combine_letters(letters, dictionary.root_node)

    @property
    def words_found(self):
        return self.__words_found

    def __combine_letters(self, letters, dict_node, current_word = None):
        if current_word == None:
            current_word = []

        for i in range(0, len(letters)):
            letter = letters[i]

            if not dict_node.has_letter(letter):
                continue

            new_node = dict_node.subnode_for(letter)
            new_letters = letters[:i] + letters[i + 1:]
            new_word = current_word + [letter]

            if new_node.is_word_end:
                self.__words_found.add(''.join(new_word))

            self.__combine_letters(new_letters, new_node, new_word)


if __name__ == '__main__':
    dialog = MainDialog()
    dialog.run()

