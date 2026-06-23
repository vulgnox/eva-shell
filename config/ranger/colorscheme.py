from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import black, blue, cyan, green, magenta, red, white, yellow, bold, normal, reverse, dim

class EVAColorScheme(ColorScheme):
    def use(self, context):
        fg, bg, attr = white, black, normal
        if context.reset:          return fg, bg, attr
        elif context.in_browser:
            fg = white
            if context.selected:   attr = reverse
            if context.directory:  fg = cyan;   attr |= bold
            elif context.executable: fg = green; attr |= bold
            if context.link:       fg = cyan if context.good else red
            if context.main_column and context.selected: attr |= bold
        elif context.in_titlebar:
            attr |= bold
            if context.directory:  fg = yellow
            elif context.tab and context.good: bg = green; fg = black
        elif context.in_statusbar:
            if context.permissions: fg = cyan if context.good else red
            if context.marked:     attr |= bold | reverse; fg = yellow
        return fg, bg, attr
