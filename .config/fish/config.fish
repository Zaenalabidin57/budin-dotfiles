if status is-interactive
    # Commands to run in interactive sessions can go here
    alias cd='z'
    alias icat='kitten icat'
    #    alias vim='nvim'
    alias kranger='kitty -e ranger .'
    alias neofetch='fastfetch'
    alias winevn='LANG=ja_JP.utf8 WINEPREFIX=/home/shigure/gaem/.winevn wine'
    alias wdiscord=' /usr/bin/discord --enable-features=UseOzonePlatform --ozone-platform=wayland &'
    alias uwe='sshfs server@192.168.100.69:/home/server/ uwe'
    alias cp= "/home/shigure/.local/bin/advcp -g"
    alias mv= "/home/shigure/.local/bin/advmv -g"
    alias yt="yt-dlp --format 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]'"
    # zoxide init fish | source

end

function fish_greeting
  #   chafa /home/shigure/Pictures/mitafull.jpg
  #chafa /home/shigure/.config/fastfetch/fish4.png
  #cat /home/shigure/Shrek-Script.txt
  echo -e "\033[34m _____ _     _
  / ____| |   (_)
 | (___ | |__  _  __ _ _   _ _ __ ___
  \___ \| '_ \| |/ _\` | | | | '__/ _ \\
  ____) | | | | | (_| | |_| | | |  __/
 |_____/|_| |_|_|\\__, |\\__,_|_|  \\___|
                  __/ |
                 |___/                \033[0m"
end
 
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

if test -e "$HOME/.nix-profile/share/fish/site-functions"
  set -gx NIX_SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
  set -gx PATH "$HOME/.nix-profile/bin" $PATH
  status --is-interactive; and source "$HOME/.nix-profile/etc/profile.d/nix.fish"
end

# if status is-login
#     if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
#       exec startx -- -keeptty
#     end
# end


#if status is-login
#  exec sh -c /home/shigure/.config/scripts/abodindwl/run_dwl.sh
#end


