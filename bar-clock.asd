#|
  This file is a part of bar-clock project.
|#

(defsystem "bar-clock"
  :version "0.1.0"
  :author ""
  :license "MIT"
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "bar-clock"))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown")))
