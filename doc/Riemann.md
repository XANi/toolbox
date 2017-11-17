## Cookbook

* Average over 10 seconds `(fixed-time-window 10 (smap folds/mean index)`
* rename keys in map:

    (smap*
      (fn [e]
          (clojure.set/rename-keys e {:plugin :service})
          )
