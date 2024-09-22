(ns reorderfile
  (:require [cloel :as cloel]
            [clojure.string :as str]))

(defn reorder-lines [text]
  (let [lines (str/split-lines text)
        numbered-lines (filter #(re-find #"^\d+\." %) lines)
        reordered-lines (map-indexed
                          (fn [idx line]
                            (str/replace line #"^\d+\." (str (inc idx) ".")))
                          numbered-lines)]
    (reduce
      (fn [acc [old new]]
        (str/replace acc old new))
      text
      (map vector numbered-lines reordered-lines))))

(defn reorder-buffer [buffer-content]
  (future
    (let [reordered-content (reorder-lines buffer-content)]
      (cloel/elisp-eval-async "reorder-file-confirm-replace" reordered-content))))

(defn app-handle-client-connected [client-id]
  (cloel/elisp-eval-async "reorder-file-start-process-confirm" (str client-id)))

(alter-var-root #'cloel/handle-client-connected (constantly app-handle-client-connected))

(cloel/start-server (Integer/parseInt (first *command-line-args*)))
