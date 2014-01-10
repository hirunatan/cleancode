(ns cyl.core
  (:require [clojure.java.io :as io]
            [clojure.string :as str]
            [clojure.math.combinatorics :as combo]
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

(defn make-combinations
  "Given a vector of characrters as string
  return vector of possible combinations."
  [cs]
  (let [combs (for [i (range 1 (inc (count cs)))]
                (combo/combinations cs i))
        combs (for [i1 combs i2 i1] i2)
        combs (for [i combs] (combo/permutations i))
        combs (for [i1 combs i2 i1] i2)]
    (vec (apply hash-set combs))))

(defn read-dictionary
  "Read a dict file and normalize it."
  [^String filename]
  (let [resource    (io/resource filename)
        raw-words   (str/split-lines (slurp resource))]
    (map normalize-word (next raw-words))))

(defn make-dictionary
  "Creates a plain dictionare from list
  of words"
  []
  (zipmap (read-dictionary "dict.txt") (repeat 1)))

(defn read-chars
  "Read input from stdin and return a
  vector of chars."
  []
  (print "Write chats separated by \",\": ")
  (flush)
  (let [readed (read-line)]
    (vec (map str/trim (str/split readed #",")))))

(defn search-words
  "Given a characters vector, return a lazy seq."
  [characters dict]
  (let [f (fn f [combinations]
            (let [fcomb (first combinations)]
              (when fcomb
                (let [candidate (apply str fcomb)]
                  (if (contains? dict candidate)
                    (cons candidate (lazy-seq (f (next combinations))))
                    (cons :nodata (lazy-seq (f (next combinations)))))))))]
     (remove #(= % :nodata)
             (f (make-combinations characters)))))

(defn -main
  [& args]
  (let [dict        (make-dictionary)
        characters  (read-chars)]
    (println "Found:" (str/join ", " (search-words characters dict)))))
