(defun luadev-send (type client)
  (make-network-process :name "luadev" :family 'ipv4 :host "127.0.0.1" :service 27099)
  (process-send-string "luadev" (concat type "\n" (buffer-name) "\n" client "\n" (buffer-string)))
  (delete-process "luadev"))

(defun luadev-getbuffer (buffer)
  (with-current-buffer buffer
 	(buffer-string)))

(defun luadev-getplayers ()
  (when (get-buffer "luadev-tmp")
  	(kill-buffer "luadev-tmp"))
  (make-network-process :name "luadev" :buffer "luadev-tmp" :family 'ipv4 :host "127.0.0.1" :service 27099)
  (process-send-string "luadev" "requestPlayers\n")
  (sleep-for 0 100)
  (setq buffer (luadev-getbuffer (get-buffer "luadev-tmp")))
  (kill-buffer "luadev-tmp")
  (butlast (split-string buffer "\\\n") 2))

(defun luadev-server ()
  "Run's the code in the current buffer on the server."
  (interactive)
  (luadev-send "sv" ""))

(defun luadev-shared ()
  "Run's the code in the current buffer on the server and all clients."
  (interactive)
  (luadev-send "sh" ""))

(defun luadev-clients ()
  "Run's the code in the current buffer on all clients."
  (interactive)
  (luadev-send "cl" ""))

(defun luadev-self ()
  "Run's the code in the current buffer on yourself."
  (interactive)
  (luadev-send "self" ""))

(defun luadev-client ()
  "Run's the code in the current buffer on the client you select."
  (interactive)
  (let ((client (ido-completing-read "Select the client: " (luadev-getplayers))))
    (luadev-send "client" client)))
