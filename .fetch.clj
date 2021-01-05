#!/usr/bin/env bb

(require '[babashka.curl :as curl]
         '[clojure.java.io :as io])

(def ITEM_URL
  {"dev.clj" "https://raw.githubusercontent.com/seancorfield/dot-clojure/develop/dev.clj"})

(defn download
  "Download a URL to a file"
  [url filename]
  (io/copy
    (:body (curl/get url #_{:as :stream}))
    (io/file filename)))

(defn -main
  "Script quarterback"
  []
  (->> ITEM_URL
       (run! (fn [[filename url]]
               (printf "Downloading %s as %s\n" url filename)
               (download url filename)))))

(when (= *file* (System/getProperty "babashka.file"))
  (-main))
