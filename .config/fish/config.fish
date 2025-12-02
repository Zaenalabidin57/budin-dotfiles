set -gx PATH $PATH /home/shigure/.cargo/bin /home/shigure/.config/composer/vendor/bin

set -gx PROTONPATH /usr/share/steam/compatibilitytools.d/proton-ge-custom/
#set -gx QSG_RHI_BACKEND vulkan


set -gx EDITOR nvim


#CLOD

if test -f ~/.config/fish/secret.fish
  source ~/.config/fish/secret.fish
end

# android
if test -f ~/.config/fish/android.fish
  source ~/.config/fish/android.fish
end
if status is-interactive
    # Use BusyBox instead of GNU coreutils
   # alias ls 'busybox ls --color=auto'
   # alias grep 'busybox grep --color=auto'
   # alias rm 'busybox rm -i'
   # alias mkdir 'busybox mkdir'
   # alias rmdir 'busybox rmdir'
   # alias cat 'busybox cat'
   # alias ps 'busybox ps'
   # alias df 'busybox df -h'
   # alias du 'busybox du -h'
   # alias top 'busybox top'
   xset r rate 200 50

    # Commands to run in interactive sessions can go here
    abbr --add vim nvim
    #abbr --add neofetch nerdfetch
    abbr --add uwe 'sshfs server@192.168.100.69:/ uwe'
    abbr --add eee 'exit'
    abbr --add axis 'sudo sysctl -w net.ipv4.ip_default_ttl=65 && sudo sysctl -w net.ipv6.conf.all.hop_limit=65'
    abbr --add ccd cd
    abbr --add empd "mpd;mpd-mpris &; disown; rmpc"
    # zoxide init fish | source
    bind \cj 'nextd >/dev/null; commandline -f repaint'
    bind \ck 'prevd >/dev/null; commandline -f repaint'
    #alias sumake="sudo make clean install"
    abbr --add sumake sudo make clean install
    abbr --add ymp3 yt-mp3
    abbr --add ymp4 yt-mp4
    abbr --add ygif yt-gif
    abbr --add supa sudo pacman
    abbr --add windog 'sudo rc-service libvirtd start;sleep 2; sudo virsh net-start default;virt-manager &; disown'

    abbr --add  shgiure shigure
    #abbr --add winevn "WINEPREFIX=/home/shigure/.adobo/Adobe-Photoshop/ wine"
    abbr --add winevn "WINEPREFIX=/home/shigure/.winevn LC_ALL=ja_JP.UTF-8 wine"
    abbr --add winegamij "WINEPREFIX=/home/shigure/gaem/.gamij wine"
    abbr --add jp "LC_ALL=ja_JP.UTF-8"

    abbr --add umuj "PROTONPATH='/usr/share/steam/compatibilitytools.d/proton-ge-custom/' umu-run"

    abbr --add boat "sudo rc-service docker start; setsid winboat"

    abbr --add vivo "ssh u0_a286@192.168.100.20 -p 8022"


    # singkatan openrc
    abbr --add rs "rc-service"
    abbr --add ru "rc-update"
    abbr --add rss "rc-status"
    abbr --add rsu "rc-service --user"
    abbr --add ruu "rc-update --user"
    abbr --add cuaca "curl wttr.in/ciwidey?0"
    #paplay /home/shigure/Music/click.wav >/dev/null 2>&1 &
end


function japon
  wine /home/shigure/gaem/LunaTranslator/LunaTranslator.exe &
  LC_ALL=ja_JP.UTF-8 wine $argv
end


function claude
  /usr/bin/claude
end
function bwlist
    bw list items --search $argv | jq --tab
end

#function cp
#advcp -gR $argv
#end
#function mv
#advmv -g $argv
#end
function cd
  z $argv
  ls
end

function kirim
      kdeconnect-cli -d cc33989fd1854142bbcda4707b505883 --share $argv
end

function mkcd
    mkdir $argv[1]
    cd $argv[1]
end

function yt-mp3
  #yt-dlp --extractor-args "youtube:player_client=android,web" --cookies-from-browser firefox:/home/shigure/.config/qutebrowser  -x --audio-format mp3 --audio-quality 0 -o '~/Music/yutub/%(title)s.%(ext)s' $argv
    yt-dlp --cookies-from-browser firefox  -x --audio-format mp3 --audio-quality 0 -o '~/Music/yutub/%(title)s.%(ext)s' $argv
end

function yt-mp4
  # Download the video to a temporary directory
  yt-dlp --cookies-from-browser firefox --format 'bv*[ext=mp4]+ba[ext=ogg]/b[ext=mp4]' -o '~/Videos/yt/%(title)s.%(ext)s' $argv

  #  # Exit if download fails
  #  if test $status -ne 0
  #    echo "Error: yt-dlp failed to download the video."
  #    return 1
  #  end
  #
  #  # Get the name of the downloaded video (the newest one)
  #  set latest_video (ls -t "$HOME/Videos/yt/temp/" | head -n 1)
  #
  #  # Exit if no video is found
  #  if test -z "$latest_video"
  #    echo "Error: Could not find a downloaded video in the temp folder."
  #    return 1
  #  end
  #
  #  # Get the base name of the video (without extension)
  #  set base_name (string split -r -m 1 '.' "$latest_video")[1]
  #
  #  # Convert the video's audio to ALAC and container to MOV
  #  echo "Converting '$latest_video' to MOV with ALAC audio..."
  #  ffmpeg -i "$HOME/Videos/yt/temp/$latest_video" -c:v copy -c:a alac "$HOME/Videos/yt/$base_name.mov"
  #
  #  # Check ffmpeg's exit status
  #  if test $status -eq 0
  #    echo "Conversion successful. Removing temporary file."
  #    # Clean up the temporary file
  #    rm "$HOME/Videos/yt/temp/$latest_video"
  #  else
  #    echo "ffmpeg conversion failed. Temporary file is at $HOME/Videos/yt/temp/$latest_video"
  #    return 1
  #  end
end


function yt-gif
  # 1. Download the video using the provided URL ($argv)
  #yt-dlp --extractor-args "youtube:player_client=android,web" --cookies-from-browser qutebrowser --format 'bv*[ext=mp4]+ba[ext=ogg]/b[ext=mp4]' -o '~/Videos/yt/temp/%(title)s.%(ext)s' $argv
  yt-dlp --cookies-from-browser firefox --format 'bv*[ext=mp4]+ba[ext=ogg]/b[ext=mp4]' -o '~/Videos/yt/temp/%(title)s.%(ext)s' $argv

  # 2. Stop if the download failed
  if test $status -ne 0
    echo "Error: yt-dlp failed to download the video."
    return 1
  end

  # 3. Get the filename of the video that was just downloaded (the newest one)
  set latest_video (ls -t "$HOME/Videos/yt/temp/" | head -n 1)

 # Check that a file was actually found
  if test -z "$latest_video"
    echo "Error: Could not find a downloaded video in the temp folder."
    return 1
  end

  # 4. Remove the old extension to get the base name
  set base_name (string split -r -m 1 '.' "$latest_video")[1]

  # 5. Create the output directory if it doesn't exist
  mkdir -p "$HOME/Videos/yt/gifs/"

  # 6. Run ffmpeg using $HOME for reliable path expansion
  echo "Converting '$latest_video' to a GIF..."
  ffmpeg -i "$HOME/Videos/yt/temp/$latest_video" "$HOME/Videos/yt/gifs/$base_name.gif"

  # 7. Remove the temporary video
  rm -f "$HOME/Videos/yt/temp/*"

end

function fish_greeting
  #fastfetch
  #nerdfetch
  #neofetch
  #chafa ~/Pictures/artix.png
  #chafa ~/.config/fastfetch/uwaahh.png
  #   chafa /home/shigure/Pictures/mitafull.jpg
  #chafa /home/shigure/.config/fastfetch/fish4.png
  #cat /home/shigure/Shrek-Script.txt
  #  echo -e "\033[34m _____ _     _
  #  / ____| |   (_)
  # | (___ | |__  _  __ _ _   _ _ __ ___
  #  \___ \| 
  #_ \| |/ _` | | | | '__/ _ \ 
  #  ____) | | | | | (_| | |_| | | |  __/
  # |_____/|_| |_|_|\__, |\__,_|_|  \___|
  #                  __/ |
  #                 |___/                \033[0m"
end
 
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

function davinki
  if test -z "$argv[1]"
    echo "Usage: davinki <input_video_file>"
    return 1
  end

  set input_file $argv[1]

  if not test -e "$input_file"
    echo "Error: Input file not found: $input_file"
    return 1
  end

  set output_filename (string split -r -m 1 '.' (basename "$input_file"))[1]
  set output_dir (dirname "$input_file")
  set output_path "$output_dir/$output_filename-resolve.mov"

  echo "Converting '$input_file' for DaVinci Resolve..."
  ffmpeg -i "$input_file" -c:v copy -c:a alac "$output_path"

  if test $status -eq 0
    echo "Successfully converted."
    echo "Output: $output_path"
  else
    echo "Error during conversion."
    return 1
  end
end

if test -e "$HOME/.nix-profile/share/fish/site-functions"
  set -gx NIX_SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
  set -gx PATH "$HOME/.nix-profile/bin" $PATH
  status --is-interactive; and source "$HOME/.nix-profile/etc/profile.d/nix.fish"
end

if status is-login
   if test -z "$DISPLAY" -a (tty) = /dev/tty1
     #exec dbus-run-session mango
     #exec dbus-run-session sway
     exec dbus-run-session startx
     #exec run_dwl
     #exec dbus-run-session niri --session
     #exec dbus-run-session labwc
   end
end


#if set -q CONTAINER_ID
#  # We are inside a Distrobox container
#  if contains $CONTAINER_ID 'archbtw'
#    function fish_prompt
#      set_color blue
#      echo -n "[ Archbtw] "
#      set_color normal
#      echo -n (prompt_pwd)
#      echo -n "> "
#    end
#  end
#  if contains $CONTAINER_ID 'gamij'
#    function fish_prompt
#      set_color yellow
#      echo -n "[ gamij] "
#      set_color normal
#      echo -n (prompt_pwd)
#      echo -n "> "
#    end
#  else
#    function fish_prompt
#      set_color green
#      echo -n "[ $CONTAINER_ID] "
#      set_color normal
#      echo -n (prompt_pwd)
#      echo -n "> "
#    end
#  end
#end


#if status is-login
#  exec sh -c /home/shigure/.config/scripts/abodindwl/run_dwl.sh
#end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# opencode
fish_add_path /home/shigure/.opencode/bin

