;;; org-kasten --- A Zettelkasten, but in plain text, using emacs as engine underneath.
;; Package-Requires: ((org-mode)(s)(dash))
;;; Commentary:
;; This is my attempt to make Zettelkaesten not suck in the digital space, so
;; I'm piggybacking on org-mode.  Org-mode is 80% there, the chiefly missing
;; thing is that it has bad navigation for this purpose.  This is mostly a bunch
;; of convenience functions atop org.
;;; Code:
(require 's)
(require 'dash)

(defvar org-kasten-home "~/Dropbox/Perceptron/"
  "Your home for the kasten.
If nil, org-kasten won't do anything.")

(defvar org-kasten-references-home (if (eq nil org-kasten-home)
					 nil
				       (concat org-kasten-home "References/"))
  "Home for your bibliographic references and notes.
You can set this to be the same as your kasten, but I recommend
keeping it separate.  Files in this will be prefixed with 'R' to
keep them in a separate index.")

(defun org-kasten--file-in-kasten-p (filepath)
  "Is the file we're looking at in the kasten?
This is needed for figuring out how to deal with links.
FILEPATH: File in question."
  (s-starts-with-p
   (file-truename org-kasten-home)
   (file-truename filepath)))

(defun org-kasten--parse-properties (string)
  "Get list of all regexp match in a string.
STRING: String to extract from.

All lines of format `#+KEY: VALUE' will be extracted, to keep with org syntax."
  (save-match-data
    (let ((regexp "^#\\+\\(\[a-zA-Z\]+\\): \\(.*\\)")
	  (pos 0)
          matches)
      (while (string-match regexp string pos)
        (push `(,(match-string 1 string) . ,(match-string 2 string)) matches)
        (setq pos (match-end 0)))
      matches)))


(defun org-kasten--read-properties ()
  "Read the org-kasten relevant properties from `current-file'."
  (interactive)
  (let* ((buffer-text (buffer-substring-no-properties (point-min) (point-max)))
         (properties  (org-kasten--parse-properties buffer-text)))
    (setq-local org-kasten-id    (cdr (assoc "ID" properties)))
    (setq-local org-kasten-links (split-string (cdr (assoc "LINKS" properties))))
    (setq-local org-kasten-references (split-string (cdr (assoc "REFERENCES" properties))))))

(defun org-kasten--write-properties ()
  "Write the buffer-local variables to the properties header."
  (interactive))

(defun org-kasten--properties-to-string ()
  "Make a header string that can be inserted on save, with all local variables stringified."
    (concat "#+ID: " org-kasten-id "\n"
	    "#+LINKS: " (string-join org-kasten-links " ") "\n"
	    "#+REFERENCES: " (string-join org-kasten-references " ") "\n"))

(defun org-kasten--buffer-string-without-header ()
  "Return the actual content of the current buffer, that is, without the org-kasten header."
  (let* ((buffer (buffer-substring-no-properties (point-min) (point-max)))
   	 (lines (split-string buffer "\n"))
	 (header-less (-drop 4 lines)))
    (string-join header-less "\n")))

;; TODO: This needs to be expanded to take a path as well, so I can use it for references.
(defun org-kasten--find-file-for-index (index)
  "Convert a link INDEX as number or string to a full filepath."
  (if (not (string= nil org-kasten-home))
      (let* ((files-in-kasten           (org-kasten--files-in-kasten))
	     (string-index              (if (numberp index)
				            (number-to-string index)
				            index))
	     (files-starting-with-index (-filter (lambda (file) (s-starts-with-p string-index file))
						 files-in-kasten)))
	;; TODO: This needs to error if there is no file, the kasten is inconsistent, then.
	(if (> (length files-starting-with-index) 1)
	    (error (concat "Org-Kasten inconsistent, multiple files with index " string-index))
	  (car files-starting-with-index)))))

(defun org-kasten--file-to-index (filepath)
  "Take a full FILEPATH, and return the index of the file, if it is in the kasten."
  (substring filepath 0 (s-index-of "-" filepath)))

(defun org-kasten--files-in-kasten ()
  "Return a list of all files in the kasten.  Excludes `.' and `..'."
  (-filter (lambda (file) (s-matches? "[[:digit:]]+-[[:alnum:]-]+.org$" file)) (directory-files org-kasten-home)))

(defun org-kasten--mk-default-content (note-id headline links references body)
  "Take the individual pieces of a new note and stitch together the body.
NOTE-ID: the number that will identitify the new note.
HEADLINE: The headline, later also the file name fragment.
LINKS: A list or string of indices that define the links.
REFERENCES: A list or string of indices that define the references.
BODY: The body of the note, the part under the headlines."
  (let ((strings `(,(concat "#+ID: " note-id)
		  ,(concat "#+LINKS: " links)
		  ,(concat "#+REFERENCES: " references "\n")
		  ,(concat "* " headline"\n")
		  ,body)))
    (string-join strings "\n")))

(defun org-kasten--headline-to-filename-fragment (headline)
  "Turn a typed HEADLINE to a filename fragment.
The fragment is the part that goes after the index: `2-this-is-the-fragment.org'"
  (let* ((downcased (s-downcase headline))
	 (trimmed (s-trim downcased))
	 (no-spaces (s-replace-regexp "[[:space:]]" "-" trimmed)))
    no-spaces))

(defun org-kasten--generate-new-note (&optional headline links references note-body)
  "Generate a new note according to parameters.
All parameters can be omitted and will default to:
HEADLINE: $index.org
LINKS: ()
REFERENCES: ()
NOTE-BODY: Empty String."
  (let ((headline    (if (eq nil headline) "" headline))
	(links      (if (eq nil links) "" links))
	(references (if (eq nil references) "" references))
	(body       (if (eq nil note-body) "" note-body)))
    (let* ((current-highest-index (-max (mapcar 'string-to-number  (mapcar 'org-kasten--file-to-index (org-kasten--files-in-kasten)))))
	   (note-id              (number-to-string (+ 1 current-highest-index)))
	   (file-content         (org-kasten--mk-default-content note-id headline links references body))
	   (stringified-headline (org-kasten--headline-to-filename-fragment headline)))
      (find-file (concat org-kasten-home note-id "-" stringified-headline  ".org"))
      (org-kasten--maybe-parse-properties)
      (insert file-content))))

(defun org-kasten--maybe-parse-properties ()
  "If the `org-kasten' properties are not set, parse and set."
  (if (or (not (boundp 'org-kasten-links))
	   (not (boundp 'org-kasten-id)))
      (org-kasten--read-properties)))

(defun org-kasten--add-link-to-file (file target-index)
  "Add a link to TARGET-INDEX in FILE."
  ;; Open/Visit target file, parse properties, push target-index, write properties, go back.
  )

(defun org-kasten-navigate-links ()
  "Navigate to one of the links from the current card.
Uses `completing-read', use with ivy for best results."
  (interactive)
  (org-kasten--maybe-parse-properties)
  (let ((files (mapcar 'org-kasten--find-file-for-index org-kasten-links)))
    (find-file (completing-read "Links:" files))))

(defun org-kasten-navigate-references ()
  "Navigate to the bibliographical references of this card."
  (interactive)
  (org-kasten--maybe-parse-properties)
  (let ((files (mapcar 'org-kasten--find-file-for-index org-kasten-links)))
    (find-file (completing-read "References:" files))))

(defun org-kasten-new-note ()
  "Create a new, enumerated note in the Kasten."
  (interactive)
  (org-kasten--generate-new-note org-kasten-home "Test!" "1" "" "This is also a test."))

(defun org-kasten-new-reference ()
  "Create a new literary note in the reference store."
  (interactive))

(defun org-kasten-open-index ()
  "Open your index and link file."
  (interactive)
  (find-file (concat org-kasten-home "/0-index.org")))

(defun org-kasten-create-child ()
  "Create a new card that is linked to this one."
  (interactive))

(defun org-kasten-add-link (link-index)
  "Link this card with another one.
The LINK-INDEX is a shorthand for the note to create a link to."
  (interactive)
  (let* ((files (org-kasten--files-in-kasten))
	 (candidates (-filter (lambda (file) (not (string= file (buffer-file-name)))) files))
	 (target-file (completing-read "File to link to:" candidates)))
    (org-kasten--add-link-to-file (buffer-file-name) (org-kasten--file-to-index target-file))
    (org-kasten--add-link-to-file (target-file (org-kasten-id)))))

(defun org-kasten-remove-link ()
  "Remove an existing link between this card and another."
  (interactive))

(defun org-kasten-delete-card ()
  "Delete a card and all of its links.
Can be useful, if it's useful too often you might need to reconsider."
  (interactive))

(provide 'org-kasten)
;;; org-kasten.el ends here
