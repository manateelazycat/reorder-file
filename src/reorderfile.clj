(ns reorderfile
  (:require [cloel :as cloel]
            [clojure.string :as str]))

(defn reorder-numbered-lines
  "Reorder lines starting with numbers, keeping original format and renumbering"
  [lines]
  (let [numbered-lines (filter #(re-find #"^\d+\." %) lines)
        reordered-lines (map-indexed
                         (fn [idx line]
                           (str/replace line #"^\d+\." (str (inc idx) ".")))
                         numbered-lines)]
    [numbered-lines reordered-lines]))

(defn reorder-alpha-lines
  "Sort lines alphabetically"
  [text]
  (let [lines (str/split-lines text)
        sorted-lines (sort-by str/lower-case lines)]
    (str/join "\n" sorted-lines)))

(defn reorder-lines [text]
  (if (some #(re-find #"^\d+\." %) (str/split-lines text))
    ;; For lines starting with numbers, use original logic
    (let [[original-lines sorted-lines] (reorder-numbered-lines (str/split-lines text))]
      (reduce
        (fn [acc [old new]]
          (str/replace acc old new))
        text
        (map vector original-lines sorted-lines)))
    ;; For non-numbered lines, return directly sorted result
    (reorder-alpha-lines text)))

(defn ^:export reorder-buffer [buffer-content]
  (future
    (let [reordered-content (reorder-lines buffer-content)]
      (if (= reordered-content buffer-content)
        (cloel/elisp-show-message "The buffer content unchanged after sorting.")
        (cloel/elisp-eval-async "reorder-file-confirm-replace" reordered-content)))))

(defn app-handle-client-connected [client-id]
  (cloel/elisp-eval-async "reorder-file-start-process-confirm" (str client-id)))

(alter-var-root #'cloel/handle-client-connected (constantly app-handle-client-connected))

(defn -main [& args]
  (cloel/start-server (Integer/parseInt (first args))))
