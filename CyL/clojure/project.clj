(defproject cyl "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Apache 2.0"
            :url "http://www.apache.org/licenses/LICENSE-2.0.txt"}
  :dependencies [[org.clojure/clojure "1.5.1"]
                 [swiss-arrows "1.0.0"]]
  :main ^:skip-aot cyl.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
