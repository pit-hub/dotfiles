if status --is-login #--is-interactive
    if test -d ~/bin
        set -x PATH ~/bin $PATH
    end
    if test -d ~/.local/bin
        set -x PATH ~/.local/bin $PATH
    end
end

function on_exit --on-event fish_exit
    echo fish is now exiting
end
