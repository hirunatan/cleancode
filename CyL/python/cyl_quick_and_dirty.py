# encoding: utf-8

class Dictionary(object):

    def __init__(self, dict_file):
        self.main_dict = {}

        dict_file.readline() # skip first line (lines count)
        for line in dict_file.readlines():

            word = line.decode('iso-8859-15')
            if word.endswith('\n'):
                word = word[:-1]
            if word.find('/') >= 0:
                word = word.split('/')[0]

            word = word.replace(u"á", u"a")
            word = word.replace(u"é", u"e")
            word = word.replace(u"í", u"i")
            word = word.replace(u"ó", u"o")
            word = word.replace(u"ú", u"u")

            char_dict = self.main_dict
            for char in word:
                if not char_dict.has_key(char):
                    char_dict[char] = {}
                char_dict = char_dict[char]

def letras(letter_list, dictionary, words, word = None):
    if word == None:
        word = []

    for i in range(0, len(letter_list)):

        letter = letter_list[i]

        if not dictionary.has_key(letter):
            continue

        other_dict = dictionary[letter]
        if len(other_dict) == 0:
            words.add(('').join(word) + letter)
        else:
            letras(letter_list[:i] + letter_list[i+1:], other_dict, words, word + [letter])


if __name__ == '__main__':
    f = open('../dictionary/es_ES.dic')
    d = Dictionary(f)
    f.close()

    print "Escribe las letras"
    letters = []
    while True:
        letter = raw_input()
        if letter == "":
            break
        letters.append(letter)

    words = set()
    letras(letters, d.main_dict, words)

    print "Éstas son las combinaciones:"
    for word in words:
        print word

