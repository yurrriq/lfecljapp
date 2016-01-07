(defmodule lfeclj-cfg
  (export (get 1) (get-str 1)))

(defun get (key)
  (application:load 'lfecljapp)
  (element 2 (application:get_env 'lfecljapp key)))

(defun get-str (key) (atom_to_list (get key)))
