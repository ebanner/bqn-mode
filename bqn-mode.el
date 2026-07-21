;;; bqn-mode.el

(require 'cl-lib)

(require 'quail)

(quail-define-package "bqn-dot" "UTF-8" "•" t
                      "BQN dot+letter replacement"
                      '(("\t" . quail-completion))
                      t                 ; forget-last-selection
                      nil               ; deterministic
                      nil               ; kbd-translate
                      t                 ; show-layout
                      nil               ; create-decode-map
                      nil               ; maximum-shortest
                      nil               ; overlay-plist
                      nil               ; update-translation-function
                      nil               ; conversion-keys
                      t                 ; simple
                      )

(defvar bqn-dot--transcription-alist
  '(("\\strand" . "‿")
    ("`-" . "←")
    ("\\windows" . "↕")
    ("\\range" . "↕")
    ("\\each" . "¨")
    ("\\w" . "𝕨")
    ("\\W" . "𝕎")
    ("\\x" . "𝕩")
    ("\\fold" . "´")
    ("\\cells" . "˘")
    ("`join" . "∾")
    ("`length" . "≠")
    ("\\before" . "⊸")
    ("\\after" . "⟜")
    ("\\macron" . "¯")
    ("\\solo" . "≍")
    ("`," . "⟨")
    ("`." . "⟩")
    ("\\swap" . "˜")
    ("\\right" . "⊢")
    ("\\drop" . "↓")
    ("\\take" . "↑")
    ("\\times" . "×")

    ))

(quail-select-package "bqn-dot")
(quail-install-map
 (quail-map-from-table
  '((default bqn-dot--transcription-alist))))

;; To use: C-\ then select "bqn-dot", then type "\𝕨" for 𝕨, "\𝕩" for 𝕩, etc.

(make-comint-in-buffer "BQN" "*BQN*" "bqn")

(with-current-buffer "*BQN*"
  (setq-local
   comint-input-sender
   (lambda (proc input)
     (comint-send-string proc input)
     (comint-send-string proc "\r"))))

(pop-to-buffer "*BQN*")

(set-input-method "bqn-dot")

(defun my-send-line-to-bqn ()
  (interactive)

  (let ((text (string-trim
               (if (use-region-p)
                   (buffer-substring (region-beginning) (region-end))
                 (thing-at-point 'line t))))
        (win (get-buffer-window "*BQN*")))

    (with-current-buffer (get-buffer "*BQN*")
      (goto-char (point-max))
      (insert text)
      (comint-send-input))

    (when win
      (set-window-point win (with-current-buffer "*BQN*" (point-max))))))

(global-set-key (kbd "TAB") #'my-send-line-to-bqn)
