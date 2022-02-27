#-----------------------------------------------------------------------
# https://fishshell.com/docs/current/tutorial.html#prompt
function fish_prompt --description 'Write out the prompt'
    set last_status $status
    set bg_color normal #000000
    set right_prompt_fg_color 94bac5

    #-------------------------------------------------------------------
    set prompt_char_fg_color 00aaff
    if test (id -u) -eq 0
        set prompt_char_fg_color dd6666
    end

    #-------------------------------------------------------------------
    if not test $last_status -eq 0
        set status_fg_color red
    else
        set status_fg_color $right_prompt_fg_color
    end

    #-------------------------------------------------------------------
    if not set -q __fish_prompt_char
        switch (id -u)
            case 0
                set __fish_prompt_char '# '
            case '*'
                set __fish_prompt_char '➤ '
        end
    end

    #-------------------------------------------------------------------
    # user
    set left_prompt (fish_prompt_echo_color -b $bg_color -o ffff00 (whoami))

    # @(at) sign
    fish_prompt_append left_prompt (fish_prompt_echo_color -b $bg_color 99aaaa '@')

    # host
    # set __fish_prompt_hostname (hostname|cut -d . -f 1)
    fish_prompt_append left_prompt (fish_prompt_echo_color -b $bg_color -o aa7744 (hostname -s))

    # colon
    fish_prompt_append left_prompt (fish_prompt_echo_color -b $bg_color -o 99aaaa ':')

    # working directory (toggle b/t implementations, if needed)
    # fish_prompt_append left_prompt (fish_prompt_echo_color -b $bg_color -o aaff7f (prompt_pwd))
    fish_prompt_append left_prompt (fish_prompt_echo_color -b $bg_color -o aaff7f (echo $PWD | sed -e "s|^$HOME|~|"))

    # git
    set git (__terlar_git_prompt)
    if test -n $git
        # Avoid errors from fish_prompt_append when not in git repo
        fish_prompt_append left_prompt (fish_prompt_echo_color -b $bg_color "$git")

        # check for gwip; does last commit log contain --wip--?
        if begin; git log -n 1 2>/dev/null | grep -qc "\-\-wip\-\-"; end
            fish_prompt_append left_prompt (fish_prompt_echo_color -b $bg_color -f ffffff " WIP!")
        end
    end

    # python virtual environment
    set venv (basename "$VIRTUAL_ENV")
    if test -n $venv
        fish_prompt_append left_prompt (fish_prompt_echo_color -b $bg_color -o ff5500 " ($venv)")
    end

    # if test $CMD_DURATION
    #     # Show duration of the last command in seconds
    #     set cmd_duration_prompt (echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')
    # end

    # right prompt
    set status_prompt (fish_prompt_echo_color -b $bg_color -o $status_fg_color $last_status)
    set right_prompt (fish_prompt_echo_color -b $bg_color -o $right_prompt_fg_color\
        (date "+%H%M.%S/%d")" "(basename (tty)) )
#       "($cmd_duration_prompt) "(date "+%H%M.%S/%d")" "(basename (tty)) )

    # spaces
    set left_length (fish_prompt_visual_length $left_prompt)
    set right_length (fish_prompt_visual_length $right_prompt)
    set status_length (fish_prompt_visual_length $status_prompt)
    set spaces_count (math "$COLUMNS -1 - $left_length - $status_length - $right_length - 5")
    if test $spaces_count -gt 0
      set spaces (eval string repeat -n $spaces_count "\" \"" )
    else
      set spaces ""
    end

    set prompt_line_one (string join " " $left_prompt $spaces $status_prompt " " $right_prompt)
    set prompt_line_two (fish_prompt_echo_color -b $bg_color -o $prompt_char_fg_color $__fish_prompt_char)

    #-------------------------------------------------------------------
    # display first line
    echo # blank line
    set_color -b $bg_color
#echo -n -s -E "prompt_line_one > "  (fish_prompt_visual_length $prompt_line_one)
#echo -n -s -E "prompt_line_two > "  (fish_prompt_visual_length $prompt_line_two)
#echo -n -s "test2  " $spaces
    echo -n $prompt_line_one

    # display second line
    echo # new line
    echo -n -s $prompt_line_two
end

# Help functions
function fish_prompt_visual_length --description\
    "Return visual length of string, i.e. without terminal escape sequences"
    # TODO: Use "string replace" builtin in Fish 2.3.0
    printf $argv | perl -pe 's/\x1b.*?[mGKH]//g' | wc -m
end

function fish_prompt_echo_color --description\
    "Echo last arg with color specified by earlier args for set_color"
    set -l s $argv[-1]
    set -e argv[-1]
    set_color $argv
    echo -n -s $s
    set_color normal
    #echo
end


function fish_prompt_append --no-scope-shadowing
    set $argv[1] "$$argv[1]""$argv[2]"
end
