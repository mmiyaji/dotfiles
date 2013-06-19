;; -*- Mode: Emacs Lisp ; Coding: utf-8 -*-

;; ########### start package.el ->
(when (require 'package nil t)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
  ; Initialize
  (package-initialize)
)
(require 'cl)
(defvar installing-package-list
  '(
    melpa
    helm
    undo-tree
    igrep
    zlc
    w3m
    org-mode
    ;; ispell
    auto-complete
    ac-ja
    redo+
    hl-line+
    window-layout
    e2wm
    nav
    tabbar
    mac-key-mode
    color-moccur
    highline
    server
    org
    org-blog
    org-bullets
    ;org-ehtml
    powerline
    org-magit
    org-readme
    org-table-comment
    magit
    magithub
    gtags
    anything
    anything-config
    anything-complete
    icomplete
    icomplete+
    yasnippet
    yasnippet-bundle
    flymake
    flymake-cursor
    flymake-python-pyflakes
    twittering-mode
    popwin
    elscreen
    expand-region
    ssh-config-mode
    ;sublime
    htmlize
    google-c-style
    grep-a-lot
    graphviz-dot-mode
    textile-mode
    textmate
    top-mode
    tree-mode
    zen-mode
    pretty-mode
    puppet-mode
    color-theme
    haskell-mode
    lua-mode
    json-mode
    php-mode
    csharp-mode
    csv-mode
    gnuplot-mode
    go-mode
    python-mode
    python-magic
    ipython
    jedi
    ruby-mode
    bib-mode
    cc-mode
    conf-mode
    css-mode
    diff-mode
    make-mode
    markdown-mode
    markdown-mode+
    gitignore-mode
    ))
(let ((not-installed (loop for x in installing-package-list
                            when (not (package-installed-p x))
                            collect x)))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
        (package-install pkg))))
; melpa.el
(require 'melpa)
;; -> end package.el ###########

;; ########### start add load paths ->
;; load-path追加関数
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
     (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))
;; elispとconfをload-pathに追加(サブディレクトリも含めて)
(add-to-load-path "elisp" "conf" "public_repos")
;; -> end add load paths ###########

;; load environment value
(load-file (expand-file-name "~/.emacs.d/shellenv.el"))
(dolist (path (reverse (split-string (getenv "PATH") ":")))
  (add-to-list 'exec-path path))

;; server start for emacs-client
(require 'server)
(unless (server-running-p)
  (server-start))

(set-language-environment "Japanese")
;; テキストエンコーディングとしてUTF-8を優先使用
(prefer-coding-system 'utf-8)
;; zshを使う
(setq shell-file-name "/bin/zsh")
(setq-default tab-width 4)
(setq-default tab-width 4 indent-tabs-mode nil)
;; 矩形選択 C-RET
(cua-mode t)
(setq cua-enable-cua-keys nil) ;; 変なキーバインド禁止
;; 改行コードを表示
(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")
;; ファイル末の改行がなければ追加
(setq require-final-newline t)
;; C-x bでミニバッファにバッファ候補を表示
(iswitchb-mode t)
;; (iswitchb-default-keybindings)
(setq iswitchb-buffer-ignore (append iswitchb-buffer-ignore '("*Messages*" "*scratch*" "*Completions*" "*Kill Ring*")))
(add-hook 'iswitchb-define-mode-map-hook
          'iswitchb-my-keys)

(defun iswitchb-my-keys ()
  "Add my keybindings for iswitchb."
  (define-key iswitchb-mode-map [right] 'iswitchb-next-match)
  (define-key iswitchb-mode-map [left] 'iswitchb-prev-match)
  (define-key iswitchb-mode-map "\C-f" 'iswitchb-next-match)
  (define-key iswitchb-mode-map " " 'iswitchb-next-match)
  (define-key iswitchb-mode-map "\C-b" 'iswitchb-prev-match)
  )
(define-key global-map "\C-t" 'other-window)

;;; undohist
(when (require 'undohist nil t)
  (undohist-initialize))
;;; tree-undo
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))

(require 'e2wm)
(global-set-key (kbd "M-+") 'e2wm:start-management)
(global-set-key (kbd "M--") 'e2wm:dp-array)

;;; filer
(require 'nav)
(setq nav-split-window-direction 'vertical) ;; 分割したフレームを垂直に並べる
(global-set-key "\C-x\C-d" 'nav-toggle)

;; expand region
(require 'expand-region)
(global-set-key (kbd "C-\\") 'er/expand-region)
(global-set-key (kbd "C-M-\\") 'er/contract-region) ;; リージョンを狭める
;; transient-mark-modeが nilでは動作しませんので注意
(transient-mark-mode t)

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; 改行削除
(setq kill-whole-line t)

;; tabbar.el 設定 http://d.hatena.ne.jp/tequilasunset/20110103/p1
(require 'tabbar)
(tabbar-mode 1)
;; タブ上でマウスホイール操作無効
(tabbar-mwheel-mode -1)
;; グループ化しない
(setq tabbar-buffer-groups-function nil)
;; 左に表示されるボタンを無効化
(dolist (btn '(tabbar-buffer-home-button
               tabbar-scroll-left-button
               tabbar-scroll-right-button))
  (set btn (cons (cons "" nil)
                 (cons "" nil))))
;; タブの長さ
(setq tabbar-separator '(1.5))
;; 外観変更
(set-face-attribute
 'tabbar-default nil
 :background "black"
 :foreground "gray72"
 :height 1.0)
(set-face-attribute
 'tabbar-unselected nil
 :background "black"
 :foreground "grey72"
 :box nil)
(set-face-attribute
 'tabbar-selected nil
 :background "black"
 :foreground "yellow"
 :box nil)
(set-face-attribute
 'tabbar-button nil
 :box nil)
(set-face-attribute
 'tabbar-separator nil
 :height 1.5)
;; タブに表示させるバッファの設定
(defvar my-tabbar-displayed-buffers
  '("*scratch*" "*Messages*" "*Backtrace*" "*Colors*" "*Faces*" "*vc-")
  "*Regexps matches buffer names always included tabs.")
(defun my-tabbar-buffer-list ()
  "Return the list of buffers to show in tabs.
Exclude buffers whose name starts with a space or an asterisk.
The current buffer and buffers matches `my-tabbar-displayed-buffers'
are always included."
  (let* ((hides (list ?\  ?\*))
         (re (regexp-opt my-tabbar-displayed-buffers))
         (cur-buf (current-buffer))
         (tabs (delq nil
                     (mapcar (lambda (buf)
                               (let ((name (buffer-name buf)))
                                 (when (or (string-match re name)
                                           (not (memq (aref name 0) hides)))
                                   buf)))
                             (buffer-list)))))
    ;; Always include the current buffer.
    (if (memq cur-buf tabs)
        tabs
      (cons cur-buf tabs))))
(setq tabbar-buffer-list-function 'my-tabbar-buffer-list)
;; Chrome ライクなタブ切り替えのキーバインド
(global-set-key (kbd "<M-s-right>") 'tabbar-forward-tab)
(global-set-key (kbd "<M-s-left>") 'tabbar-backward-tab)
;; Terminalっぽく
(global-set-key (kbd "<S-s-right>") 'tabbar-forward-tab)
(global-set-key (kbd "<S-s-left>") 'tabbar-backward-tab)
;; タブ上をマウス中クリックで kill-buffer
(defun my-tabbar-buffer-help-on-tab (tab)
  "Return the help string shown when mouse is onto TAB."
  (if tabbar--buffer-show-groups
      (let* ((tabset (tabbar-tab-tabset tab))
             (tab (tabbar-selected-tab tabset)))
        (format "mouse-1: switch to buffer %S in group [%s]"
                (buffer-name (tabbar-tab-value tab)) tabset))
    (format "\
mouse-1: switch to buffer %S\n\
mouse-2: kill this buffer\n\
mouse-3: delete other windows"
            (buffer-name (tabbar-tab-value tab)))))
(defun my-tabbar-buffer-select-tab (event tab)
  "On mouse EVENT, select TAB."
  (let ((mouse-button (event-basic-type event))
        (buffer (tabbar-tab-value tab)))
    (cond
     ((eq mouse-button 'mouse-2)
      (with-current-buffer buffer
        (kill-buffer)))
     ((eq mouse-button 'mouse-3)
      (delete-other-windows))
     (t
      (switch-to-buffer buffer)))
    ;; Don't show groups.
    (tabbar-buffer-show-groups nil)))
(setq tabbar-help-on-tab-function 'my-tabbar-buffer-help-on-tab)
(setq tabbar-select-tab-function 'my-tabbar-buffer-select-tab)

;;; igrep.el
(require 'igrep)
; lgrepの出力をUTF-8にする
(igrep-define lgrep (igrep-use-zgrep nil)(igre-regex-option "-n -Ou8"))
(igrep-find-define lgrep (igrep-use-zgrep nil)(igrep-regex-option "-n -Ou8"))

(require 'linum)
(setq linum-delay t)
(defadvice linum-schedule (around my-linum-schedule () activate)
  (run-with-idle-timer 0.2 nil #'linum-update-current))
(global-set-key [f9] 'linum-mode)
;; メージャーモード/マイナーモードでの指定
(defvar my-linum-hook-name nil)
(mapc (lambda (hook-name)
        (add-hook hook-name (lambda () (linum-mode t))))
      my-linum-hook-name)

;; 拡張子での判定
(defvar my-linum-file-extension nil)
(defun my-linum-file-extension ()
  (when (member (file-name-extension (buffer-file-name)) my-linum-file-extension)
    (linum-mode t)))
(add-hook 'find-file-hook 'my-linum-file-extension)
;; メージャーモード/マイナーモードでの指定
;(setq my-linum-hook-name '(emacs-lisp-mode-hook slime-mode-hook sh-mode-hook text-mode-hook
;                                                php-mode-hook python-mode-hook ruby-mode-hook
;                                                css-mode-hook yaml-mode-hook org-mode-hook
;                                                howm-mode-hook js2-mode-hook java-mode-hook javascript-mode-hook
;                                                smarty-mode-hook html-helper-mode-hook))
;; 拡張子での判定
(setq my-linum-file-extension '("conf" "bat" "el" "tex" "py" "bib" "org" "csv"
                                "text" "rb" "c" "cpp" "java" "js" "cu"
                                "css" "html" "xhtml" "cob"))

; 現在行を2秒後に赤にする
(require 'hl-line+)
(toggle-hl-line-when-idle 2)
(set-face-background 'hl-line "#840001")

(add-to-list 'auto-mode-alist '("\\.tex\\'" . LaTeX-mode))
;; ;; C# mode
;; (require 'csharp-mode)
;; (add-to-list 'auto-mode-alist '("\\.cs\\'" . csharp-mode))

(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/elisp/my-snippets")
(setq yas-trigger-key "TAB")
;; (setq yas/trigger-key (kbd "SPC"))
;; (setq yas-snippet-dirs
;;       '("~/.emacs.d/elisp/my-snippets"))
;; (yas-global-mode t)
;; (custom-set-variables '(yas-trigger-key "TAB"))
;;;; anything interface
(eval-after-load "anything-config"
 '(progn
    (defun my-yas/prompt (prompt choices &optional display-fn)
      (let* ((names (loop for choice in choices
                          collect (or (and display-fn (funcall display-fn choice))
                                      choice)))
             (selected (anything-other-buffer
                        `(((name . ,(format "%s" prompt))
                           (candidates . names)
                           (action . (("Insert snippet" . (lambda (arg) arg))))))
                        "*anything yas/prompt*")))
        (if selected
            (let ((n (position selected names :test 'equal)))
              (nth n choices))
          (signal 'quit "user quit!"))))
    (custom-set-variables '(yas/prompt-functions '(my-yas/prompt)))))
;; yasnippet の snippet を置いてあるディレクトリ
;; (setq yas/root-directory (expand-file-name "~/.emacs.d/elisp/my-snippets"))
;; 自分用スニペットディレクトリ(リストで複数指定可)
;; (defvar my-snippet-directories
;;   (list (expand-file-name "~/.emacs.d/elisp/my-snippets")))
;; (defun yas/load-all-directories ()
;;   (interactive)
;;   (yas/reload-all)
;;   (mapc 'yas/load-directory-1 my-snippet-directories))

;;; org-modeの設定
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (org-set-local 'yas/trigger-key [tab])
;;             (define-key yas/keymap [tab] 'yas/next-field-or-maybe-expand)))
(defun yas/advise-indent-function (function-symbol)
  (eval `(defadvice ,function-symbol (around yas/try-expand-first activate)
           ,(format
             "Try to expand a snippet before point, then call `%s' as usual"
             function-symbol)
           (let ((yas/fallback-behavior nil))
             (unless (and (interactive-p)
                          (yas/expand))
               ad-do-it)))))

(yas/advise-indent-function 'ruby-indent-line)
;;; org-modeでの行折り返し関数。
(setq org-startup-truncated nil)
(defun change-truncation()
  (interactive)
  (cond ((eq truncate-lines nil)
         (setq truncate-lines t))
        (t
         (setq truncate-lines nil))))

(require 'tramp)
(require 'smartchr)
(require 'auto-complete)
(global-auto-complete-mode t)
(require 'ac-ja)
(setq ac-sources (append ac-sources '(ac-source-dabbrev-ja)))
(auto-revert-mode t)
;; BS で選択範囲を消す
(delete-selection-mode 1)
;;; 対応する括弧を強調表示させる
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")
;; (set-face-attribute 'show-paren-match-face nil
;;                     :background nil :foreground nil
;;                     :underline "#ffff00" :weight 'extra-bold)

;;; Localeに合わせた環境の設定
(set-locale-environment nil)
;; The local variables list in .emacs と言われるのを抑止
(add-to-list 'ignored-local-variables 'syntax)

(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-dark-laptop)
     (set-face-foreground
      `font-lock-keyword-face "#CDA869")
     )
  )

;; デフォルトエンコーディングをUTF8にする
(set-default-coding-systems 'utf-8)

(setq-default show-trailing-whitespace t) ; 行末の不要なスペースを強調表示する
(setq compilation-scroll-output t)        ; コンパイル時に出力を追って表示する
;; (add-hook 'before-save-hook 'delete-trailing-whitespace) ; 保存時に無駄なスペースを削除
;; ビープ音の代りに画面を点滅させる
(setq visible-bell t)
;; 時間を表示
(display-time)
;; 行と列の表示
(line-number-mode t)
(column-number-mode t)

;; メニューバーを消す
(menu-bar-mode t)

;;; バックアップファイルを作らない
(setq backup-inhibited t)

;; #のバックアップファイルを作成しない
(setq make-backup-files nil)
(setq auto-save-default nil)
;; Commands History を再起動後も使用する
(setq desktop-globals-to-save '(extended-command-history))
(setq desktop-files-not-to-save "")
(desktop-save-mode 1)

;;; 補完時に大文字小文字を区別しない
(setq completion-ignore-case t)

;; C-a C-aしてバッファーの頭に移動する
(require 'sequential-command-config)
(sequential-command-setup-keys)

;;; 強力な補完機能を使う
;;; p-bでprint-bufferとか
;(load "complete")
;(partial-completion-mode t)

;;; 補完可能なものを随時表示
;;; 少しうるさい
(icomplete-mode 1)
(require 'icomplete+)

(require 'zlc)
(setq zlc-select-completion-immediately t)
;; (let ((map minibuffer-local-map))
;;   ;;; like menu select
;;   (define-key map (kbd "<down>")  'zlc-select-next-vertical)
;;   (define-key map (kbd "<up>")    'zlc-select-previous-vertical)
;;   (define-key map (kbd "<right>") 'zlc-select-next)
;;   (define-key map (kbd "<left>")  'zlc-select-previous)
;;   ;;; reset selection
;;   (define-key map (kbd "C-c") 'zlc-reset)
;;   )

;;; スクロールを一行ずつにする
(setq scroll-step 1)

;;; タイトルバーにファイル名を表示する
(setq frame-title-format (format "%%f" (system-name)))

;;; 画像ファイルを表示する
(auto-image-file-mode t)

;;; 自動でファイルを挿入する
;; (auto-insert-mode t)

;;; 最近使ったファイルを保存(M-x recentf-open-filesで開く)
(recentf-mode)

;; Mac mode切り替え
(when (eq system-type 'darwin)
  (if window-system (progn
                      ;; mac keybind
                      (require 'mac-key-mode)
                      (mac-key-mode t)
                      )
    )
  (setq mac-command-key-is-meta nil) ; コマンドキーをメタにしない
  (setq mac-option-modifier1 'meta)   ; オプションキーをメタに
  (setq mac-command-modifier 'super) ; コマンドキーを Super に
  (setq mac-pass-control-to-system t) ; コントロールキーを Mac ではなく Emacs に渡す
  )

(setq x-select-enable-clipboard t)
;; (global-set-key "\C-y" 'x-clipboard-yank)
(global-set-key "\C-xa" 'anything)

;; (define-key global-map [(super a)] 'anything)
(define-key global-map [?\M-¥] [?\\])
(define-key global-map [(super z)] 'undo)
(define-key global-map [(super y)] 'redo)
(define-key global-map [(super shift z)] 'redo)
(define-key global-map [(super v)] 'yank)
(define-key global-map [(super s)] 'save-buffer)
(define-key global-map [(super x)] 'clipboard-kill-region)
(define-key global-map [(super r)] 'compile)    ; make
(define-key global-map [(super /)] 'comment-or-uncomment-region)       ;コメントアウト

;;;キーバインド
(define-key global-map "\C-ci" 'indent-region)       ; インデント
;; (define-key global-map "ESC" 'dabbrev-expand)   ; 補完
(define-key global-map "\C-c;" 'comment-region)      ; コメントアウト
(define-key global-map "\C-c:" 'uncomment-region)    ; コメント解除
(define-key global-map "\C-c/" 'comment-or-uncomment-region)    ; トグルコメント
(define-key global-map "\C-xk" 'kill-this-buffer)    ; 現在バッファ削除

;; シフト + 矢印で範囲選択
(if (fboundp 'pc-selection-mode)
    (pc-selection-mode)
  (require 'pc-select))
(custom-set-variables
 '(pc-selection-mode t nil (pc-select)))
(setq pc-select-selection-keys-only t)
(transient-mark-mode 1)
;; "yes or no"を"y or n"に
(fset 'yes-or-no-p 'y-or-n-p)

;; ショートカットキー設定
(global-set-key "\C-z" 'undo)
(global-set-key "\C-c;" 'comment-region)
(global-set-key "\C-c:" 'uncomment-region)
(global-set-key "\C-x\C-e" 'eval-buffer)
(global-set-key "\C-m" 'newline-and-indent)
(global-set-key "\C-x\C-g" 'igrep)
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <down>")  'windmove-down)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c r") 'query-replace) ; C-c r aka M-%

;; C-x l で goto-line を実行
(define-key ctl-x-map "l" 'goto-line)

;; C-o に動的略語展開機能を割り当てる
(define-key global-map "\C-o" 'dabbrev-expand)
(setq dabbrev-case-fold-search nil) ; 大文字小文字を区別

;; 日本語・英語混じり文での区切判定
(defadvice dabbrev-expand
  (around modify-regexp-for-japanese activate compile)
  "Modify `dabbrev-abbrev-char-regexp' dynamically for Japanese words."
  (if (bobp)
      ad-do-it
    (let ((dabbrev-abbrev-char-regexp
           (let ((c (char-category-set (char-before))))
             (cond
              ((aref c ?a) "[-_A-Za-z0-9]") ; ASCII
              ((aref c ?j) ; Japanese
               (cond
                ((aref c ?K) "\\cK") ; katakana
                ((aref c ?A) "\\cA") ; 2byte alphanumeric
                ((aref c ?H) "\\cH") ; hiragana
                ((aref c ?C) "\\cC") ; kanji
                (t "\\cj")))
              ((aref c ?k) "\\ck") ; hankaku-kana
              ((aref c ?r) "\\cr") ; Japanese roman ?
              (t dabbrev-abbrev-char-regexp)))))
      ad-do-it)))

(require 'anything)
(require 'anything-config)
;;(add-to-list 'anything-sources)
(add-to-list 'anything-sources 'anything-c-source-emacs-commands)

;; killringの履歴を表示する
(global-set-key (kbd "C-S-v") 'anything-show-kill-ring)

;;; color-moccur.elの設定

(require 'color-moccur)
;; 複数の検索語や、特定のフェイスのみマッチ等の機能を有効にする
;; 詳細は http://www.bookshelf.jp/soft/meadow_50.html#SEC751
(setq moccur-split-word t)
;; migemoがrequireできる環境ならmigemoを使う
(when (require 'migemo nil t) ;第三引数がnon-nilだとloadできなかった場合にエラーではなくnilを返す
  (setq moccur-use-migemo t))

;;; anything-c-moccurの設定
;; http://d.hatena.ne.jp/IMAKADO/20080724/1216882563
(require 'anything-c-moccur)
;; カスタマイズ可能変数の設定(M-x customize-group anything-c-moccur でも設定可能)
(setq anything-c-moccur-anything-idle-delay 0.2 ;`anything-idle-delay'
      anything-c-moccur-higligt-info-line-flag t ; `anything-c-moccur-dmoccur'などのコマンドでバッファの情報をハイライトする
      anything-c-moccur-enable-auto-look-flag t ; 現在選択中の候補の位置を他のwindowに表示する
      ;; anything-c-moccur-enable-initial-pattern t
      ) ; `anything-c-moccur-occur-by-moccur'の起動時にポイントの位置の単語を初期パターンにする

;;; キーバインドの割当(好みに合わせて設定してください)
(global-set-key (kbd "M-o") 'anything-c-moccur-occur-by-moccur) ;バッファ内検索
(global-set-key (kbd "C-M-o") 'anything-c-moccur-dmoccur) ;ディレクトリ
(add-hook 'dired-mode-hook ;dired
          '(lambda ()
             (local-set-key (kbd "O") 'anything-c-moccur-dired-do-moccur-by-moccur)))

;; フォント一覧
;; http://d.hatena.ne.jp/mooz/20110320
(require 'cl)  ; loop, delete-duplicates

(defun anything-font-families ()
  "Preconfigured `anything' for font family."
  (interactive)
  (flet ((anything-mp-highlight-match () nil))
    (anything-other-buffer
     '(anything-c-source-font-families)
     "*anything font families*")))

(defun anything-font-families-create-buffer ()
  (with-current-buffer
      (get-buffer-create "*Fonts*")
    (loop for family in (sort (delete-duplicates (font-family-list)) 'string<)
          do (insert
              (propertize (concat family "\n")
                          'font-lock-face
                          (list :family family :height 2.0 :weight 'bold))))
    (font-lock-mode 1)))

(defvar anything-c-source-font-families
  '((name . "Fonts")
    (init lambda ()
          (unless (anything-candidate-buffer)
            (save-window-excursion
              (anything-font-families-create-buffer))
            (anything-candidate-buffer
             (get-buffer "*Fonts*"))))
    (candidates-in-buffer)
    (get-line . buffer-substring)
    (action
     ("Copy Name" lambda
      (candidate)
      (kill-new candidate))
     ("Insert Name" lambda
      (candidate)
      (with-current-buffer anything-current-buffer
        (insert candidate))))))

;;====================================
;;jaspace.el を使った全角空白、タブ、改行表示モード
;;切り替えは M-x jaspace-mode-on or -off
;;====================================
(require 'jaspace)
;; 全角空白を表示させる。
(setq jaspace-alternate-jaspace-string "□")
;; 改行記号を表示させる。
(setq jaspace-alternate-eol-string "↓\n")
;; タブ記号を表示。
(setq jaspace-highlight-tabs t)  ; highlight tabs

;; 半角スペースや全角スペースなどを色付け表示する
;;(defface my-face-b-1 '((t (:background "blue"))) nil)
(defface my-face-b-1 '((t (:background "blue"))) nil)
(defface my-face-b-2 '((t (:background "gray10"))) nil)
(defface my-face-b-2 '((t (:background "gray"))) nil)
(defface my-face-u-1 '((t (:foreground "DarkBlue" :underline t))) nil)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(
     ("　" 0 my-face-b-1 append)
     ("\t" 0 my-face-b-2 append)
     ("[ ]+$" 0 my-face-u-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)
(add-hook 'find-file-hooks '(lambda ()
                              (if font-lock-mode
                                  nil
                                (font-lock-mode t))))
(global-font-lock-mode t)
;; (require 'face-list)
;; ;;; region
(transient-mark-mode t)
;; (set-face-background 'region "DarkBlue")
(set-face-background 'region "yellow4")
(set-face-foreground 'region "black")
;; ;;; modeline
;; (set-face-background 'modeline "DarkBlue")
(set-face-background 'modeline "Red")
(set-face-foreground 'modeline "white")
(set-face-bold-p 'modeline nil)

;;; comment
;; (set-face-foreground 'font-lock-comment-face "MediumPurple1")
(set-face-foreground 'font-lock-comment-face "OrangeRed")


;; 起動時にスタートアップ画面を表示しない
(setq inhibit-startup-message t)
;;; search している単語を highlight する
(setq search-highlight t)
;;; replace するときに highlight する
(setq query-replace-highlight t)

(require 'highlight-current-line)
(highlight-current-line-on t)
;; To customize the background color
(set-face-background 'highlight-current-line-face "DarkBlue")

;; diffの表示方法を変更
(defun diff-mode-setup-faces ()
  ;; 追加された行は緑で表示
  (set-face-attribute 'diff-added nil
                      :foreground "white" :background "dark green")
  ;; 削除された行は赤で表示
  (set-face-attribute 'diff-removed nil
                      :foreground "white" :background "dark red")
  ;; 文字単位での変更箇所は色を反転して強調
  (set-face-attribute 'diff-refine-change nil
                      :foreground nil :background nil
                      :weight 'bold :inverse-video t))
(add-hook 'diff-mode-hook 'diff-mode-setup-faces)

;; diffを表示したらすぐに文字単位での強調表示も行う
(defun diff-mode-refine-automatically ()
  (diff-auto-refine-mode t))
(add-hook 'diff-mode-hook 'diff-mode-refine-automatically)

;; diff関連の設定
(defun magit-setup-diff ()
  ;; diffを表示しているときに文字単位での変更箇所も強調表示する
  ;; 'allではなくtにすると現在選択中のhunkのみ強調表示する
  (setq magit-diff-refine-hunk 'all)
  ;; diff用のfaceを設定する
  (diff-mode-setup-faces)
  ;; diffの表示設定が上書きされてしまうのでハイライトを無効にする
  (set-face-attribute 'magit-item-highlight nil :inherit nil))
(add-hook 'magit-mode-hook 'magit-setup-diff)

;; dsvn
(autoload 'svn-status "dsvn" "Run `svn status'." t)
(autoload 'svn-update "dsvn" "Run `svn update'." t)
(setq svn-status-svn-file-coding-system 'utf-8)

;;; cursor 位置の face を調べる関数
(defun describe-face-at-point ()
  "Return face used at point."
  (interactive)
  (message "%s" (get-char-property (point) 'face)))
;; windowシステムの時だけ適用する設定
(if window-system (progn
                    ;; スクロールバーを消す
                    (toggle-scroll-bar nil)

                    ;; ;; font-lock-mode (色の設定等) を有効にする
                    ;; (global-font-lock-mode t)
                    ;; ;; 文字の色を設定します。
                    (add-to-list 'default-frame-alist '(foreground-color . "snow"))
                    ;; ;; 背景色を設定します。
                    (add-to-list 'default-frame-alist '(background-color . "black"))
                    ;; ;; モードラインの文字の色を設定します。
                    (set-face-foreground 'modeline "white")
                    ;; ;; モードラインの背景色を設定します。
                    (set-face-background 'modeline "navy")
                    ;; ;; 選択中のリージョンの色を設定します。
                    ;; (set-face-background 'region "RoyalBlue4")
                    ;; デフォルトの透明度を設定する (85%)
                    (add-to-list 'default-frame-alist '(alpha . 0.90))
                    ;; カレントウィンドウの透明度を変更する (85%)
                    (set-frame-parameter nil 'alpha 0.85)
                    ;; ;;; 初期フレームの設定
                    ;;             (setq initial-frame-alist
                    ;;               (append
                    ;;                '((top    . 22)    ; フレームの Y 位置(ピクセル数)
                    ;;                  (left    . 0)   ; フレームの X 位置(ピクセル数)
                    ;;                  (width    . 81)    ; フレーム幅(文字数)
                    ;;                  (height    . 50))   ; フレーム高(文字数)
                    ;;                initial-frame-alist))
                    ;; ;;; 新規フレームのデフォルト設定
                    ;;             (setq default-frame-alist
                    ;;               (append
                    ;;                '((width    . 81)    ; フレーム幅(文字数)
                    ;;                  (height    . 50))    ; フレーム高(文字数)
                    ;;                default-frame-alist))
;;; ホイールマウス
                    (mouse-wheel-mode t)
                    (setq mouse-wheel-follow-mouse t)
;;; ツールバーを消す
                    (tool-bar-mode 0)
                    (when (eq system-type 'darwin)
                      (when (>= emacs-major-version 23)
                        (set-face-attribute 'default nil
                                            :family "monaco"
                                            :height 120)
                        (set-fontset-font
                         (frame-parameter nil 'font)
                         'japanese-jisx0208
                         '("Hiragino Maru Gothic Pro" . "iso10646-1"))
                        (set-fontset-font
                         (frame-parameter nil 'font)
                         'katakana-jisx0201
                         '("Hiragino Maru Gothic Pro" . "iso10646-1"))
                        ;; (set-fontset-font
                        ;;  (frame-parameter nil 'font)
                        ;;  'mule-unicode-0100-24ff
                        ;;  '("monaco" . "iso10646-1"))
                        (setq face-font-rescale-alist
                              '(("^-apple-hiragino.*" . 1.2)
                                (".*osaka-bold.*" . 1.2)
                                (".*osaka-medium.*" . 1.2)
                                (".*courier-bold-.*-mac-roman" . 1.0)
                                (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
                                (".*monaco-bold-.*-mac-roman" . 0.9)
                                ("-cdac$" . 1.3)))
                        )
                      )
                    (when (eq system-type 'gnu/linux)
                      (when (>= emacs-major-version 23)
                        (set-default-font "VL Gothic-13")
                        (set-fontset-font (frame-parameter nil 'font)
                                          'japanese-jisx0208
                                          '("VL Gothic" . "unicode-bmp"))
                        )
                      )
                    ))
;; フォントの設定
                                        ;(when (>= emacs-major-version 23)
                                        ;        (set-face-attribute 'default nil :family "monaco" :height 140)
                                        ;        (set-fontset-font
                                        ;         (frame-parameter nil 'font)
                                        ;         'japanese-jisx0208
                                        ;         '("Hiragino Maru Gothic Pro" . "iso10646-1"))
                                        ;        (set-fontset-font
                                        ;         (frame-parameter nil 'font)
                                        ;         'japanese-jisx0212
                                        ;         '("Hiragino Maru Gothic Pro" . "iso10646-1"))
                                        ;        (set-fontset-font
                                        ;         (frame-parameter nil 'font)
                                        ;         'mule-unicode-0100-24ff
                                        ;         '("monaco" . "iso10646-1"))
                                        ;        (setq face-font-rescale-alist
                                        ;              '(("^-apple-hiragino.*" . 1.2)
                                        ;                (".*osaka-bold.*" . 1.2)
                                        ;                (".*osaka-medium.*" . 1.2)
                                        ;                (".*courier-bold-.*-mac-roman" . 1.0)
                                        ;                (".*monaco cy-bold-.*-mac-cyrillic" . 0.9) (".*monaco-bold-.*-mac-roman" . 0.9)
                                        ;                ("-cdac$" . 1.3))))

                                        ;(when (>= emacs-major-version 23)
                                        ; (set-face-attribute 'default nil
                                        ;                     :family "monaco"
                                        ;                     :height 140)
                                        ; (set-fontset-font
                                        ;  (frame-parameter nil 'font)
                                        ;  'japanese-jisx0208
                                        ;  '("Hiragino Maru Gothic Pro" . "iso10646-1"))
                                        ; (set-fontset-font
                                        ;  (frame-parameter nil 'font)
                                        ;  'japanese-jisx0212
                                        ;  '("Hiragino Maru Gothic Pro" . "iso10646-1"))
                                        ; (set-fontset-font
                                        ;  (frame-parameter nil 'font)
                                        ;  'mule-unicode-0100-24ff
                                        ;  '("monaco" . "iso10646-1"))
                                        ; (setq face-font-rescale-alist
                                        ;      '(("^-apple-hiragino.*" . 1.2)
                                        ;        (".*osaka-bold.*" . 1.2)
                                        ;        (".*osaka-medium.*" . 1.2)
                                        ;        (".*courier-bold-.*-mac-roman" . 1.0)
                                        ;        (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
                                        ;        (".*monaco-bold-.*-mac-roman" . 0.9)
                                        ;        ("-cdac$" . 1.3))))
;; (set-default-font "Andale Mono")
;; (set-face-font 'variable-pitch "Inconsolata")
;; (set-fontset-font (frame-parameter nil 'font)
;;                   'japanese-jisx0208
;;                   '("Takaoゴシック" . "unicode-bmp")
;; )
(defun toggle-fullscreen (&optional f)
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
    (set-frame-parameter nil 'fullscreen
                         (if (equal 'fullboth current-value)
                             (if (boundp 'old-fullscreen) old-fullscreen nil)
                           (progn (setq old-fullscreen current-value)
                                  'fullboth)))))
(global-set-key [f11] 'toggle-fullscreen)
                                        ; Make new frames fullscreen by default. Note: this hook doesn't do
                                        ; anything to the initial frame if it's in your .emacs, since that file is
                                        ; read _after_ the initial frame is created.
(add-hook 'after-make-frame-functions 'toggle-fullscreen)

;; powerline.el
(defun arrow-right-xpm (color1 color2)
  "Return an XPM right arrow string representing."
  (format "/* XPM */
static char * arrow_right[] = {
\"12 18 2 1\",
\". c %s\",
\"  c %s\",
\".           \",
\"..          \",
\"...         \",
\"....        \",
\".....       \",
\"......      \",
\".......     \",
\"........    \",
\".........   \",
\".........   \",
\"........    \",
\".......     \",
\"......      \",
\".....       \",
\"....        \",
\"...         \",
\"..          \",
\".           \"};"  color1 color2))

(defun arrow-left-xpm (color1 color2)
  "Return an XPM right arrow string representing."
  (format "/* XPM */
static char * arrow_right[] = {
\"12 18 2 1\",
\". c %s\",
\"  c %s\",
\"           .\",
\"          ..\",
\"         ...\",
\"        ....\",
\"       .....\",
\"      ......\",
\"     .......\",
\"    ........\",
\"   .........\",
\"   .........\",
\"    ........\",
\"     .......\",
\"      ......\",
\"       .....\",
\"        ....\",
\"         ...\",
\"          ..\",
\"           .\"};"  color2 color1))


;; (defconst color1 "#FF6699")
;; (defconst color3 "#CDC0B0")
;; (defconst color2 "#FF0066")
;; (defconst color4 "#CDC0B0")
(defconst color1 "#E7F3FE")
;; (defconst color2 "#6FAEFB")
(defconst color2 "#004DF8")
(defconst color3 "#001FB9")
(defconst color4 "#03020C")

(defvar arrow-right-1 (create-image (arrow-right-xpm color1 color2) 'xpm t :ascent 'center))
(defvar arrow-right-2 (create-image (arrow-right-xpm color2 color3) 'xpm t :ascent 'center))
(defvar arrow-right-3 (create-image (arrow-right-xpm color3 "None") 'xpm t :ascent 'center))
(defvar arrow-left-1  (create-image (arrow-left-xpm color2 color1) 'xpm t :ascent 'center))
(defvar arrow-left-2  (create-image (arrow-left-xpm color3 color2) 'xpm t :ascent 'center))
(defvar arrow-left-3  (create-image (arrow-left-xpm "None" color3) 'xpm t :ascent 'center))

(setq-default mode-line-format
              (list  '(:eval (concat (propertize " %* %b " 'face 'mode-line-color-1)
                                     (propertize " " 'display arrow-right-1)))
                     '(:eval (concat (propertize " %Z " 'face 'mode-line-color-2)
                                     (propertize " " 'display arrow-right-2)))
                     '(:eval (concat (propertize " %m " 'face 'mode-line-color-3)
                                     (propertize " " 'display arrow-right-3)))

                     ;; Justify right by filling with spaces to right fringe - 16
                     ;; (16 should be computed rahter than hardcoded)
                     '(:eval (propertize " " 'display '((space :align-to (- right-fringe 17)))))

                     '(:eval (concat (propertize " " 'display arrow-left-2)
                                     (propertize " %p " 'face 'mode-line-color-2)))
                     '(:eval (concat (propertize " " 'display arrow-left-1)
                                     (propertize "%4l:%2c  " 'face 'mode-line-color-1)))
                     ))

(make-face 'mode-line-color-1)
(set-face-attribute 'mode-line-color-1 nil
                    :foreground "#000"
                    :background color1)

(make-face 'mode-line-color-2)
(set-face-attribute 'mode-line-color-2 nil
                    :foreground "#fff"
                    :background color2)

(make-face 'mode-line-color-3)
(set-face-attribute 'mode-line-color-3 nil
                    :foreground "#fff"
                    :background color3)
(make-face 'mode-line-color-4)
(set-face-attribute 'mode-line-color-4 nil
                    :foreground "#fff"
                    :background color4)

(set-face-attribute 'mode-line nil
                    :foreground "#fff"
                    :background color3
                    :box nil)
(set-face-attribute 'mode-line-inactive nil
                    :foreground "#fff"
                    :background color4)

;;; 選択範囲の行数と文字数をモードラインに表示
(defun count-lines-and-chars ()
  (if mark-active
      (format "[%d lines, %d chars ]"
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
    ;;(count-lines-region (region-beginning) (region-end)) ; これだとエコーエリアがチラつく
    ""))
(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))
;; (require 'one-key-default) ; one-key.el も一緒に読み込んでくれる
;; (require 'one-key-config) ; one-key.el をより便利にする
;; (one-key-default-setup-keys) ; one-key- で始まるメニュー使える様になる
;; (define-key global-map "\C-x" 'one-key-menu-C-x) ;; C-x にコマンドを定義

(setq pop-up-windows nil)
(require 'popwin nil t)
(when (require 'popwin nil t)
  (setq anything-samewindow nil)
  (setq display-buffer-function 'popwin:display-buffer)
  (push '("anything" :regexp t :height 0.5) popwin:special-display-config)
  (push '("*Completions*" :height 0.4) popwin:special-display-config)
  (push '("*compilation*" :height 0.4 :noselect t :stick t) popwin:special-display-config)
  )
(require 'direx)
;; http://cx4a.blogspot.jp/2011/12/popwineldirexel.html
;; (global-set-key (kbd "C-x C-j") 'direx:jump-to-directory)
(setq direx:leaf-icon "  "
      direx:open-icon "▾ "
      direx:closed-icon "▸ ")
(push '(direx:direx-mode :position left :width 25 :dedicated t)
      popwin:special-display-config)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory-other-window)
(global-set-key (kbd "C-x C-k") 'direx:jump-to-directory)
;;; 現在の表示画面の通りにHTMLレンダリング->ブラウザで開く 自動化
(defun htmlize-and-browse ()
  (interactive)
  (defcustom
    htmlize-and-browse-directory-path temporary-file-directory
    "htmlize-and-browse-temporary-file-directory"
    :type 'string
    :group 'htmlize-and-browse)
  (setq htmlize-and-browse-buffer-file-name (concat "htmlize-and-browse-" (format-time-string "%Y%m%d%H%M%S" (current-time)) ".html"))
  (setq htmlize-and-browse-buffer-file-path (concat htmlize-and-browse-directory-path htmlize-and-browse-buffer-file-name))
  (with-current-buffer (htmlize-buffer)
    (write-file htmlize-and-browse-buffer-file-path)
    (set-buffer-modified-p nil)
    (kill-buffer htmlize-and-browse-buffer-file-name)
    (shell-command (concat "open " htmlize-and-browse-buffer-file-path))
    )
  )
;;; Safari指定で開く
(defun htmlize-and-browse-by-safari ()
  (interactive)
  (defcustom
    htmlize-and-browse-directory-path temporary-file-directory
    "htmlize-and-browse-temporary-file-directory"
    :type 'string
    :group 'htmlize-and-browse)
  (setq htmlize-and-browse-buffer-file-name (concat "htmlize-and-browse-" (format-time-string "%Y%m%d%H%M%S" (current-time)) ".html"))
  (setq htmlize-and-browse-buffer-file-path (concat htmlize-and-browse-directory-path htmlize-and-browse-buffer-file-name))
  (with-current-buffer (htmlize-buffer)
    (write-file htmlize-and-browse-buffer-file-path)
    (set-buffer-modified-p nil)
    (kill-buffer htmlize-and-browse-buffer-file-name)
    (shell-command (concat "open -a safari " htmlize-and-browse-buffer-file-path))
    )
  )
(defun anything-c-sources-git-project-for (pwd)
  (loop for elt in
        '(("Modified files (%s)" . "--modified")
          ("Untracked files (%s)" . "--others --exclude-standard")
          ("All controlled files in this project (%s)" . ""))
        collect
        `((name . ,(format (car elt) pwd))
          (init . (lambda ()
                    (unless (and ,(string= (cdr elt) "") ;update candidate buffer every time except for that of all project files
                                 (anything-candidate-buffer))
                      (with-current-buffer
                          (anything-candidate-buffer 'global)
                        (insert
                         (shell-command-to-string
                          ,(format "git ls-files $(git rev-parse --show-cdup) %s"
                                   (cdr elt))))))))
          (candidates-in-buffer)
          (type . file))))

(defun anything-git-project ()
  (interactive)
  (let* ((pwd default-directory)
         (sources (anything-c-sources-git-project-for pwd)))
    (anything-other-buffer sources
                           (format "*Anything git project in %s*" pwd))))
(define-key global-map (kbd "C-;") 'anything-git-project)
