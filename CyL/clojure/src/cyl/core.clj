(ns cyl.core
  (:require [clojure.java.io :as io]
            [clojure.string :as str]
            [swiss.arrows :refer [-<>]])
  (:gen-class))

(defn combine [& maps]
  (apply merge-with combine maps))

(defn normalize-word
  "Normalize word."
  [^String word]
  (-> word
      (str/trim)
      (str/split #"/")
      (first)
      (str/replace #"á" "a")
      (str/replace #"é" "e")
      (str/replace #"í" "i")
      (str/replace #"ó" "o")
      (str/replace #"ú" "u")))

(defn read-dictionary
  "Read a dict file and normalize it."
  [^String filename]
  (let [resource    (io/resource filename)
        raw-words   (str/split-lines (slurp resource))]
    (map normalize-word raw-words)))

(defn make-dictionary
  "Create a data structure for a dictionary"
  []
  (-<> (read-dictionary "dict.txt")
       (map #(reduce (fn [v c] (if v {(str c) v} {(str c) {}})) nil (reverse %1)) <>)
       (apply combine <>)))

(defn read-chars
  "Read input from stdin and return a
  vector of chars."
  []
  (print "Write chats separated by \",\": ")
  (flush)
  (let [readed (read-line)]
    (vec (map str/trim (str/split readed #",")))))

(defn search-words
  "Search words."
  [characters dict]
  (let [words (atom [])
        f     (fn f [characters dict word]
                (doseq [ch characters]
                  (when (dict ch)
                    (if-not (seq (dict ch))
                      (swap! words conj (str word ch))
                      (f characters (dict ch) (str word ch))))))]
    (apply f [characters dict ""])
    (deref words)))

(defn -main
  [& args]
  (let [dict        (make-dictionary)
        characters  (read-chars)]
    (println (str/join "\n" (search-words characters dict)))))
