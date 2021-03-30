(ns darjeeling.app
  (:use [compojure core route])
  (:require
   [ring.adapter.jetty :as jetty]
   [ring.util.response :as reply]
   [ring.middleware.reload :refer [wrap-reload]]
   [clj-http.client :as client]
   [jsonista.core :as j])
  (:gen-class))
(set! *warn-on-reflection* true)

(defn quote-json [] (reply/response
                     (:body (client/get "https://api.fisenko.net/quotes?l=en"))))

(defroutes app
  (GET "/" [] (quote-json))
  (not-found "404 Not Found"))

(def reloadable-app
  (wrap-reload #'app))

(defn -main [& args]
  (cond
    (not (nil? args))
    (intern 'darjeeling.app 'server (do (let [port (Integer/parseInt (or (System/getenv "PORT") "8080"))
        host (or (System/getenv "HOST") "0.0.0.0")]
    (jetty/run-jetty reloadable-app {:port port :join? false
                                     :host host}))))
    :else (.println System/out "needs argument to start")))
