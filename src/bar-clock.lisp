(uiop/package:define-package :bar-clock/src/bar-clock (:nicknames) (:use :cl)
                             (:shadow) (:export :bar-clock) (:intern))
(in-package :bar-clock/src/bar-clock)
;;don't edit above

(defun get-datetime (&optional (universal-time (get-universal-time)))
  (multiple-value-bind (second minute hour date month year day daylight-p zone)
      (decode-universal-time universal-time)
    (list 
     :second second 
     :minute minute 
     :hour hour 
     :date date 
     :month month 
     :year year 
     :day day 
     :daylight-p daylight-p 
     :zone zone)))

(defun make-bar (value max-value &key (char "*") (max 24))
  (if (> value max-value) (setf value max-value))
  (let ((num (truncate (* (/ value max-value) max))))
    (format nil "~V@{~A~:*~}~*~V@{~A~:*~}~A~2,,,'0A / ~A" num char (- max num) " " value max-value)))

(defun leap-year-p (year)
  (and (zerop (mod year 4))
       (or (plusp (mod year 100)) 
           (zerop (mod year 400)))))

(defvar *max-date* '(31 (28 29) 31 30 31 30 31 31 30 31 30 31))

(defun get-max-date (datetime)
  (let ((year (getf datetime :year))
        (month (getf datetime :month)))
    (if (= month 2)
        (if (leap-year-p year)
            (second (elt *max-date* 1))
            (first (elt *max-date* 1)))
        (elt *max-date* (1- month)))))

(defun get-max (datetime)
  (list 
   :second 60
   :minute 60
   :hour 24
   :date (get-max-date datetime)
   :month 12))

(defun bar-clock (&key (char "*") (max 60)) 
  (let* ((datetime (get-datetime))
         (max-list (get-max datetime)))
    (format t 
            "~4,,,'0@A-~2,,,'0@A-~2,,,'0@A ~2,,,'0@A:~2,,,'0@A:~2,,,'0@A~%" 
            (getf datetime :year)
            (getf datetime :month)
            (getf datetime :date)
            (getf datetime :hour)
            (getf datetime :minute)
            (getf datetime :second))
    (dolist (key '(:second :minute :hour :date :month))
      (format t 
              "~6A: ~A~%" 
              key 
              (make-bar (getf datetime key) (getf max-list key) :char char :max max)))))
