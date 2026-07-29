#### COLOUR THEME (Omarchy)
# Generated from the active Omarchy palette. Statusline layout lives in
# ~/.config/tmux/tmux.statusline.conf.

# Status bar colors
set-option -g status-style bg=default,fg={{ color8 }},default
set-option -g status-fg "{{ foreground }}"
set-option -g status-bg default

# Window title colors
set-window-option -g window-status-style fg={{ color8 }},bg={{ color0 }},dim
set-window-option -g window-status-current-style fg={{ accent }},bg=default,bright
set-window-option -g window-status-activity-style underscore,fg={{ foreground }},bg={{ color0 }}

# Pane borders
set-option -g pane-border-style fg={{ color8 }}
set-option -g pane-active-border-style fg={{ accent }},bg=default

# Window styles
set-option -g window-style fg={{ color8 }},bg=default
set-option -g window-active-style fg={{ foreground }},bg=default

# Message/command text
set-option -g message-style bg={{ color0 }},fg={{ accent }}
set-option -g message-command-style fg={{ foreground }},bg={{ color0 }}

# Mode style (copy mode, etc.)
set-option -g mode-style fg={{ foreground }},bg={{ color0 }}

# Pane number display
set-option -g display-panes-active-colour "{{ accent }}"
set-option -g display-panes-colour "{{ color8 }}"

# Clock
set-window-option -g clock-mode-colour "{{ accent }}"

# Statusline colors (used by tmux.statusline.conf)
set-option -g @theme-status-bg "default"
set-option -g @theme-status-fg "{{ color8 }}"
set-option -g @theme-status-left-primary-bg "{{ accent }}"
set-option -g @theme-status-left-primary-fg "{{ background }}"
set-option -g @theme-status-left-secondary-bg "{{ color0 }}"
set-option -g @theme-status-left-secondary-fg "{{ foreground }}"
set-option -g @theme-status-right-bg "{{ color8 }}"
set-option -g @theme-status-right-fg "{{ background }}"
set-option -g @theme-window-status-fg "{{ color8 }}"
set-option -g @theme-window-status-current-fg "{{ accent }}"
set-option -g @theme-window-status-current-bg "{{ foreground }}"
