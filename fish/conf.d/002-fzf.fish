if type -q fzf
    fzf --fish | source
    
    # Unbind default Ctrl+T (used by sesh-launcher)
    bind --erase \ct
    bind -M insert --erase \ct
    
    # Unbind Alt+C (not needed, have zoxide)
    bind --erase \ec
    bind -M insert --erase \ec
    
    # Bind Ctrl+F to fzf file widget
    bind \cf fzf-file-widget
    bind -M insert \cf fzf-file-widget
end
