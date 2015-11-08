;;Файл конфигурации для Emacs версии 24.4.1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;Установка кодировки текста
;;Используем Windows 1251
;(set-language-environment "Russian")
;(define-coding-system-alias 'windows-1251 'cp1251)
;(set-buffer-file-coding-system 'cp1251-dos)
;(set-default-coding-systems 'cp1251-dos)
;(set-terminal-coding-system 'cp1251-dos)
;(set-selection-coding-system 'cp1251-dos)
;(prefer-coding-system 'cp1251-dos)
;;
;; Использовать окружение UTF-8
(set-language-environment 'UTF-8)
(set-buffer-file-coding-system 'utf-8-dos)
(set-default-coding-systems 'utf-8-dos)
(set-terminal-coding-system 'utf-8-dos)
(set-selection-coding-system 'utf-8-dos)
(define-coding-system-alias 'windows-1251 'cp1251)
;; Установки автоопределения кодировок. Первой будет определяться utf-8-dos
(prefer-coding-system 'cp866-dos)
(prefer-coding-system 'koi8-r-dos)
(prefer-coding-system 'windows-1251-dos)
(prefer-coding-system 'utf-8-dos)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Установка режимов работы Emacs
;;
(setq default-major-mode 'text-mode)
; Turn on auto-fill mode
(add-hook 'text-mode-hook 'turn-on-auto-fill)
;(setq auto-fill-mode t)
(setq fill-column 75)
;; Show marked text
(setq transient-mark-mode '1)
(setq font-lock-maximum-decoration t)
; for syntax highlighting
;;(global-font-lock-mode 1 t);; для версии <23.1
(global-font-lock-mode t)
;; Выделение парных скобок
(show-paren-mode 1)
;(setq show-paren-style 'expression);выделять все выражение в скобках
;;ruler-mode.el required
;;To automatically display the ruler in specific major modes use: 
(add-hook 'text-mode-hook 'ruler-mode) 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Установка правил поведения редактора
;; параметры окружения
;; Start off in "C:/home" dir.
(cd "~/")
(setq my-author-name (getenv "USERNAME"))
(setq user-full-name (getenv "USERNAME"))
;; Shut off message buffer. Note - if you need to debug emacs,
;; comment these out so you can see what's going on.
; (setq message-log-max nil)
; (kill-buffer "*Messages*")
(recentf-mode 1); Recent files in menu
;;
;;Создание резервных копий редактируемых файлов (Backup)
;;это если бэкапы нужны
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/backup"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups
;(setq version-control t);нумерованный бэкап - 2 первых и 2 последних
;(setq delete-old-versions t);удаление промежуточных бэкапов
;;а это если не надо никаких бэкапов ...
;(setq make-backup-files nil) ; Don't want any backup files
;(setq auto-save-list-file-name nil) ; Don't want any .saves files
;(setq auto-save-default nil) ; Don't want any auto saving
;;добавление к пути каталога с моими пакетами, не входящими в дистрибутив
(add-to-list 'load-path "~/emacs")
;;
;;загружается молча
(setq inhibit-startup-message t)
;; Scratch buffer settings. Очищаем его.
(setq initial-scratch-message nil)
;;гладкий скроллинг с полями
(setq scroll-conservatively 50)
(setq scroll-preserve-screen-position 't)
(setq scroll-margin 10)
;;
;; hour format
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(display-time)
(setq calendar-date-display-form (quote ((format "%04s-%02d-%02d" year (string-to-int month) (string-to-int day)))))
(setq calendar-time-display-form (quote (24-hours ":" minutes (if time-zone " (") time-zone (if time-zone ")"))))
(setq calendar-week-start-day 1)
(setq european-calendar-style t)
;;Табулятор
(setq-default tab-width 4)
(setq require-final-newline t) ;добавлять пустую строку в конец файла при сохранении
;;
;;мышка...
;;
;; Scroll Bar gets dragged by mouse butn 1
(global-set-key [vertical-scroll-bar down-mouse-1] 'scroll-bar-drag)
;(setq mouse-yank-at-point t)	;Fix so button 2 pastes at cursor, not Point
;;колесо мышки
(mouse-wheel-mode 1)
;;
;;Настройка поведения редактора "как в Windows"
;;
;;
;;настройка клавиатуры "как в Windows"
;;для версии ДО 24
;;Delete (and its variants) delete forward instead of backward.
;;C-Backspace kills backward a word (as C-Delete normally would).
;;M-Backspace does undo.
;;Home and End move to beginning and end of line
;;C-Home and C-End move to beginning and end of buffer.
;;C-Escape does list-buffers." 
;;Для версий ДО 24.1
;(pc-bindings-mode)
;;Настройка выделения "как в Windows"
;(pc-selection-mode)
;(delete-selection-mode nil)
;;Конец варианта ДО 24
;;Для версии 24 и старше - закомментировать этот кусок
;;
;;
;;Установка режима CUA
;;поддержка Ctr-c,v,x,d как в windows
;;
(require 'cua-base)
(cua-mode t)
;;установка режимов работы курсора через CUA
(setq cua-normal-cursor-color "black")
(setq cua-overwrite-cursor-color "red")
(setq cua-read-only-cursor-color "green") 
;; always end a file with a newline
(setq require-final-newline t)
(delete-selection-mode t) ; <del> удаляет выделенный текст
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;Настройка внешнего вида редактора
;;
;;установка размеров экрана
(set-frame-height (selected-frame) 55)
(set-frame-width (selected-frame) 100)
;;установка левого верхнего угла фрейма 
(set-frame-position (selected-frame) 60 0)
;;
;;установка цветов экрана
(set-background-color "gray90")
(set-foreground-color "black")

;;установка режимов работы курсора
(set-cursor-color "red")
;(setq blink-matching-delay 0.1)
(blink-cursor-mode nil);курсор не мигает!
;;
;; show column & line numbers in status bar
(setq column-number-mode t)
(setq line-number-mode t)
;;нумеровать строки в левой части окна
(require 'linum)
(global-linum-mode 1)
;;
;;показать пробелы
(require 'whitespace)
(global-whitespace-mode 1)
(global-whitespace-newline-mode 1)
;; make whitespace-mode use “¶” for newline and “->” for tab.
;; together with the rest of its defaults
(setq whitespace-display-mappings
 '(
   (space-mark 32 [183] [46]) ; normal space, ·
   (space-mark 160 [164] [95])
   (space-mark 2208 [2212] [95])
   (space-mark 2336 [2340] [95])
   (space-mark 3616 [3620] [95])
   (space-mark 3872 [3876] [95])
   (newline-mark 10 [182 10]) ; newlne, ¶
   (tab-mark 9 [8594 9] [92 9]) ; tab, ->
))
;; disable colours in whitespace-mode
(setq whitespace-style '(space-mark tab-mark newline-mark))
;;
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;Настройки проверка правописания Ispell
;;
;(setq ispell-dictionary "russianw"); default dictionary
(setq ispell-local-dictionary "russianw"); default dictionary
; enable tex parser, also very helpful
(setq ispell-enable-tex-parser t)
(add-hook 'text-mode-hook 'flyspell-mode)
(setq flyspell-default-dictionary "russianw")
(setq flyspell-delay '1)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;Установка значений клавиш
;;
(global-set-key [home] 'beginning-of-line)
(global-set-key [end] 'end-of-line)
(global-set-key [\C-home] 'beginning-of-buffer)
(global-set-key [\C-end] 'end-of-buffer)
;;удаляем строку целиком
;(setq kill-whole-line t) удаляет ОТ позиции курсора до конца строки
(global-set-key [(control y)] 
  '(lambda () 
     (interactive)
     (beginning-of-line)
     (kill-line)))
;; setting some f[1-12] keys
(global-set-key [f1]    'help)
(global-set-key [f2]    'save-buffer)
(global-set-key [f4]    'ispell-buffer)
(global-set-key [M-f4]  'save-buffers-kill-emacs)
(global-set-key [M-f7]  'isearch-forward)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;Настройка печати
;;
;; Use Notepad to print plain text files to the default Windows printer
(setq lpr-command "notepad")
(setq lpr-headers-switches '("/p"))    ; \ mis-use these
(setq lpr-switches nil)                ; / two variables
(setq printer-name nil)		; notepad takes the default
(setq lpr-printer-switch "/P") ;; run notepad as batch printer 
;;
;;Печать через prfile32
;(setq lpr-command "c:/program files/printfile/prfile32.exe")
;(setq lpr-headers-switches '("/p"))
;(setq lpr-switches '("/q"))
;(setq lpr-add-switches nil)
;(setq printer-name nil)
;;
;;Печать в файл
;(setq printer-name "~/myprint.txt")
(setq ps-printer-name nil)
(setq ps-print-header nil)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;Настройки AucTeX
;;
;(require 'tex-mik)
;(add-hook 'LaTeX-mode-hook 'LaTeX-install-toolbar)
;(setq TeX-parse-self t)             ; Enable parse on load.
;(setq TeX-auto-save t)              ; Enable parse on save.
;(setq-default TeX-master nil)       ; Query for master file.
;(setq TeX-PDF-mode t)
;(setq TeX-interactive-mode t)
;(setq TeX-source-specials-mode 1)
;(custom-set-variables
; '(TeX-close-quote ">>")
; '(TeX-open-quote "<<"))
;(custom-set-faces
; )


;;модифицируем меню
;;; some more menu entries in the command list:
;;; see tex-mik.el from package auctex: %v is defined in tex-mik.el
;;; other variables are defined in tex.el from auctex
;;; the meaning of some auctex-varibles:
        ;symbols defined in tex.el and tex-mik.el:
        ;%b name slave tex-file  %t name master tex-file   
        ;%d dvi-file  %f ps-file 
        ;%l "latex --src-specials"
        ;%n line number  %p printcommand  %q "lpq"  
        ;%r (TeX-style-check TeX-print-style)
        ;%s master-file-name without extention
        ;%v yap command view line
(eval-after-load "tex"
  '(progn
     (add-to-list 'TeX-command-list
		  (list "->PS landscape for pdf"
			"dvips %d -N0 -Ppdf -G0 -T 297mm,210mm -o %f " 
			'TeX-run-command nil t))
     (add-to-list 'TeX-command-list
		  (list "All Texify run-viewer"
			"texify --tex-opt=--src --run-viewer --clean %s.tex"
			'TeX-run-command nil t))))
;;
;;Настройки PreviewLatex
;(load "preview-latex.el" nil t t) 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;(autoload 'auto-capitalize-mode "auto-capitalize"
;;  "Toggle `auto-capitalize' minor mode in this buffer." t)
;;(autoload 'turn-on-auto-capitalize-mode "auto-capitalize"
;;  "Turn on `auto-capitalize' minor mode in this buffer." t)
;;(autoload 'enable-auto-capitalize-mode "auto-capitalize"
;;  "Enable `auto-capitalize' minor mode in this buffer." t)
;;(add-hook 'text-mode-hook 'turn-on-auto-capitalize-mode)
;;(setq auto-capitalize-words '("КГБ" "Rajeev" "Nautiyal" "Sanjeev" "Uma"))

;; 


;;
(message ".emacs loaded OK.")
;;
;; end of .emacs
;;
;;

