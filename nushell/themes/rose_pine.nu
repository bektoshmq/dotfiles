# Retrieve the theme settings
export def main [] {
    let command_color = '#ffffff'

    return {
        binary: '#c4a7e7'
        block: { fg: $command_color attr: 'b' }
        cell-path: '#908caa'
        closure: '#9ccfd8'
        custom: { fg: $command_color attr: 'b' }
        duration: '#f6c177'
        float: '#eb6f92'
        glob: '#e0def4'
        int: '#c4a7e7'
        list: '#9ccfd8'
        nothing: '#eb6f92'
        range: '#f6c177'
        record: '#9ccfd8'
        string: '#ebbcba'

        bool: {|| if $in { '#9ccfd8' } else { '#f6c177' } }

        datetime: {|| (date now) - $in |
            if $in < 1hr {
                { fg: '#eb6f92' attr: 'b' }
            } else if $in < 6hr {
                '#eb6f92'
            } else if $in < 1day {
                '#f6c177'
            } else if $in < 3day {
                '#ebbcba'
            } else if $in < 1wk {
                { fg: '#ebbcba' attr: 'b' }
            } else if $in < 6wk {
                '#9ccfd8'
            } else if $in < 52wk {
                '#31748f'
            } else { 'dark_gray' }
        }

        filesize: {|e|
            if $e == 0b {
                '#908caa'
            } else if $e < 1mb {
                '#9ccfd8'
            } else {{ fg: '#31748f' }}
        }

        shape_and: { fg: '#c4a7e7' attr: 'b' }
        shape_binary: { fg: '#c4a7e7' attr: 'b' }
        shape_block: { fg: $command_color attr: 'b' }
        shape_bool: '#9ccfd8'
        shape_closure: { fg: '#9ccfd8' attr: 'b' }
        shape_custom: { fg: $command_color attr: 'b' }
        shape_datetime: { fg: '#9ccfd8' attr: 'b' }
        shape_directory: '#9ccfd8'
        shape_external: { fg: $command_color attr: 'b' }
        shape_external_resolved: { fg: $command_color attr: 'b' }
        shape_externalarg: { fg: '#ebbcba' attr: 'b' }
        shape_filepath: '#9ccfd8'
        shape_flag: { fg: '#31748f' attr: 'b' }
        shape_float: { fg: '#eb6f92' attr: 'b' }
        shape_garbage: { fg: '#e0def4' bg: '#eb6f92' attr: 'b' }
        shape_glob_interpolation: { fg: '#9ccfd8' attr: 'b' }
        shape_globpattern: { fg: '#9ccfd8' attr: 'b' }
        shape_int: { fg: '#c4a7e7' attr: 'b' }
        shape_internalcall: { fg: $command_color attr: 'b' }
        shape_keyword: { fg: '#c4a7e7' attr: 'b' }
        shape_list: { fg: '#9ccfd8' attr: 'b' }
        shape_literal: '#31748f'
        shape_match_pattern: '#ebbcba'
        shape_matching_brackets: { attr: 'u' }
        shape_nothing: '#eb6f92'
        shape_operator: '#f6c177'
        shape_or: { fg: '#c4a7e7' attr: 'b' }
        shape_pipe: { fg: '#c4a7e7' attr: 'b' }
        shape_range: { fg: '#f6c177' attr: 'b' }
        shape_raw_string: { fg: '#e0def4' attr: 'b' }
        shape_record: { fg: '#9ccfd8' attr: 'b' }
        shape_redirection: { fg: '#c4a7e7' attr: 'b' }
        shape_signature: { fg: '#ebbcba' attr: 'b' }
        shape_string: '#ebbcba'
        shape_string_interpolation: { fg: '#9ccfd8' attr: 'b' }
        shape_table: { fg: '#31748f' attr: 'b' }
        shape_vardecl: { fg: '#31748f' attr: 'u' }
        shape_variable: '#c4a7e7'

        foreground: '#e0def4'
        background: '#000000'
        cursor: '#e0def4'

        empty: '#31748f'
        header: { fg: '#ebbcba' attr: 'b' }
        hints: '#6e6a86'
        leading_trailing_space_bg: { attr: 'n' }
        row_index: { fg: '#ebbcba' attr: 'b' }
        search_result: { fg: '#191724' bg: '#f6c177' }
        separator: '#908caa'
    }
}

export def --env "set color_config" [] {
    $env.config.color_config = (main)
}

export def "update terminal" [] {
    let theme = (main)

    let osc_screen_foreground_color = '10;'
    let osc_screen_background_color = '11;'
    let osc_cursor_color = '12;'

    $"
    (ansi -o $osc_screen_foreground_color)($theme.foreground)(char bel)
    (ansi -o $osc_screen_background_color)($theme.background)(char bel)
    (ansi -o $osc_cursor_color)($theme.cursor)(char bel)
    "
    | str replace --all "\n" ''
    | print -n $"($in)\r"
}

export module activate {
    export-env {
        set color_config
        update terminal
    }
}

use activate

