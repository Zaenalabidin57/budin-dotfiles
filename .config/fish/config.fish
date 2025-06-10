if status is-interactive
    # Commands to run in interactive sessions can go here
    abbr --add cd z
    abbr --add vim nvim
    abbr --add neofetch pfetch
    abbr --add uwe 'sshfs server@192.168.100.69:/home/server/ uwe'
    abbr --add axis 'sudo sysctl -w net.ipv4.ip_default_ttl=65 && sudo sysctl -w net.ipv6.conf.all.hop_limit=65'
    abbr --add empd "mpd;mpd-mpris &; disown; rmpc"
    # zoxide init fish | source
    bind \cj 'nextd >/dev/null; commandline -f repaint'
    bind \ck 'prevd >/dev/null; commandline -f repaint'
    #alias sumake="sudo make clean install"
    abbr --add sumake sudo make clean install
    abbr --add ymp3 yt-mp3
    abbr --add ymp4 yt-mp4
    abbr --add supa sudo pacman
    abbr --add windog 'sudo systemctl start libvirtd; sudo virsh net-start default;virt-manager &; disown'

    abbr --add  shgiure shigure
    abbr --add winevn "WINEPREFIX=/home/shigure/gaem/winevn wine"

end

function mkcd
    mkdir $argv[1]
    cd $argv[1]
end

function yt-mp3
    yt-dlp -x --audio-format mp3 --audio-quality 0 -o '~/Music/yutub/%(title)s.%(ext)s' $argv
end

function yt-mp4
  yt-dlp --format 'bv*[ext=mp4]+ba[ext=ogg]/b[ext=mp4]' -o '~/Videos/yt/%(title)s.%(ext)s' $argv
  #  yt-dlp --format 'bv*+ba[ext=webm][acodec=vorbis]/b[ext=webm]' --prefer-ffmpeg -o '~/Videos/yt/%(title)s.%(ext)s' $argv
end

function fish_greeting
  pfetch
  #   chafa /home/shigure/Pictures/mitafull.jpg
  #chafa /home/shigure/.config/fastfetch/fish4.png
  #cat /home/shigure/Shrek-Script.txt
  #  echo -e "\033[34m _____ _     _
  #  / ____| |   (_)
  # | (___ | |__  _  __ _ _   _ _ __ ___
  #  \___ \| '_ \| |/ _\` | | | | '__/ _ \\
  #  ____) | | | | | (_| | |_| | | |  __/
  # |_____/|_| |_|_|\\__, |\\__,_|_|  \\___|
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

if test -e "$HOME/.nix-profile/share/fish/site-functions"
  set -gx NIX_SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
  set -gx PATH "$HOME/.nix-profile/bin" $PATH
  status --is-interactive; and source "$HOME/.nix-profile/etc/profile.d/nix.fish"
end

#if status is-login
#   if test -z "$DISPLAY" -a (tty) = /dev/tty1
#      exec startx -- -keeptty
#   end
#end


if set -q CONTAINER_ID
  # We are inside a Distrobox container
  if contains $CONTAINER_ID 'archbtw'
    function fish_prompt
      set_color blue
      echo -n "[ Archbtw] "
      set_color normal
      echo -n (prompt_pwd)
      echo -n "> "
    end
  end
  if contains $CONTAINER_ID 'gamij'
    function fish_prompt
      set_color yellow
      echo -n "[ gamij] "
      set_color normal
      echo -n (prompt_pwd)
      echo -n "> "
    end
  else
    function fish_prompt
      set_color green
      echo -n "[ $CONTAINER_ID] "
      set_color normal
      echo -n (prompt_pwd)
      echo -n "> "
    end
  end
end


#if status is-login
#  exec sh -c /home/shigure/.config/scripts/abodindwl/run_dwl.sh
#end

function yt-select
    # Check if a URL is provided
    if test -z "$argv[1]"
        echo "Usage: yt-select <video_url>"
        return 1
    end

    set -l url "$argv[1]"
    set -l output_base_dir "~/Videos/yt"

    set -l temp_output_file (mktemp)
    yt-dlp -F "$url" >"$temp_output_file" 2>&1
    set -l ytdlp_status $status
    set -l ytdlp_full_output (cat "$temp_output_file")
    rm "$temp_output_file"

    if test $ytdlp_status -ne 0 && not string match -q -- "*ID EXT RESOLUTION*" "$ytdlp_full_output"
        echo "Error: yt-dlp failed to list formats or video not found."
        echo -e "\n----- yt-dlp output -----\n$ytdlp_full_output\n----------------------"
        return 1
    end

    # Try to isolate the actual format table, starting from the "ID EXT RESOLUTION" header
    set -l table_header_pattern "^ID\s+EXT\s+RESOLUTION"
    # Use sed to get text from the header pattern to the end of the output
    # This helps skip any warning messages before the actual table.
    set -l format_table_text (echo "$ytdlp_full_output" | sed -n "/$table_header_pattern/,\$p")

    if test -z "$format_table_text"
        echo "Could not find the start of the format table (header starting with 'ID EXT RESOLUTION') in yt-dlp output."
        echo -e "\n----- yt-dlp output -----\n$ytdlp_full_output\n----------------------"
        return 1
    end

    # Extract the header line from the isolated table text
    set -l header_line (echo "$format_table_text" | string match -r -- $table_header_pattern | head -n 1)

    # Extract the actual format lines (those starting with a number - the format ID)
    # from the isolated table text. Allow for optional leading spaces.
    set -l format_lines (echo "$format_table_text" | string match -ra "^\s*\d+\s+.*")

    if test -z "$format_lines"
        echo "Found the format table header, but could not parse any actual format lines (lines starting with a number)."
        echo -e "\n----- Isolated table text used for parsing -----\n$format_table_text\n----------------------"
        echo -e "\n----- Full yt-dlp output for context -----\n$ytdlp_full_output\n----------------------"
        return 1
    end

    set -l choices_string
    set -l num_header_lines 0
    if test -n "$header_line[1]"
        set choices_string "$header_line[1]\n"
        set num_header_lines 1
    end
    set choices_string "$choices_string"(string join "\n" $format_lines)

    set selected_line (echo -e "$choices_string" | fzf --height 60% --layout reverse --border \
        --prompt="Select Format> " --header-lines=$num_header_lines \
        --ansi)

    if test $status -ne 0 || test -z "$selected_line"
        echo "No format selected."
        return 1
    end

    set format_code (echo "$selected_line" | string trim | string split " " -m 1)[1]

    if test -z "$format_code"
        echo "Could not parse format code from selection: '$selected_line'"
        return 1
    end

    echo "Selected format code: $format_code"
    set -l target_dir (eval echo $output_base_dir)
    set -l output_template "$target_dir/%(title)s [%(id)s].%(ext)s"
    echo "Downloading to: $output_template"
    mkdir -p "$target_dir"

    yt-dlp --progress -f "$format_code" -o "$output_template" "$url"

    if test $status -eq 0
        echo "Download complete!"
    else
        echo "Download failed."
        return 1
    end
end

