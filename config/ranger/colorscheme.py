# ============================================================
# EVA-SHELL — ranger colorscheme
# Phase 7: Bottom Flank file manager theme
# ============================================================

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import (
    black, blue, cyan, green, magenta, red, white, yellow,
    bold, normal, reverse, dim
)

class EVAColorScheme(ColorScheme):
    """
    EVA-01 color scheme for ranger.
    Dark background, green accent, NERV terminal aesthetic.
    """

    def use(self, context):
        fg, bg, attr = white, black, normal

        if context.reset:
            return fg, bg, attr

        elif context.in_browser:
            fg = white
            if context.selected:
                attr = reverse
            else:
                attr = normal

            if context.empty or context.error:
                fg = red
                attr |= bold

            if context.border:
                fg = green

            if context.media:
                fg = cyan

            if context.container:
                fg = yellow

            if context.directory:
                fg = green
                attr |= bold

            elif context.executable and not any((
                context.media, context.container,
                context.fifo, context.socket)):
                fg = green
                attr |= bold

            if context.socket:
                fg = magenta
                attr |= bold

            if context.fifo or context.device:
                fg = yellow

            if context.link:
                fg = cyan if context.good else red

            if context.bad:
                attr |= dim

            if context.tag_marker and not context.selected:
                attr |= bold
                fg = red if fg not in (red, magenta) else white

            if not context.selected and (context.cut or context.copied):
                fg = yellow
                attr |= bold

            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = yellow

            if context.badinfo:
                fg = red if attr & reverse else magenta

            if context.inactive_pane:
                fg = white

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = green if context.good else red
            elif context.directory:
                fg = green
            elif context.tab:
                if context.good:
                    bg = green
                    fg = black
            elif context.link:
                fg = cyan

        elif context.in_statusbar:
            if context.permissions:
                fg = cyan if context.good else red
            if context.marked:
                attr |= bold | reverse
                fg = yellow
            if context.message:
                attr |= bold
                if context.bad:
                    fg = red
            if context.loaded:
                bg = green
                fg = black
            if context.vcsinfo:
                fg = blue
                attr &= ~bold
            if context.vcscommit:
                fg = yellow
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = green
            if context.selected:
                attr |= reverse
            if context.loaded:
                if context.selected:
                    fg = black
                else:
                    fg = green

        return fg, bg, attr
