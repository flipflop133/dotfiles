import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk


def getHexColor(colorCode):
    tv = Gtk.TextView()
    color = tv.get_style_context().lookup_color(colorCode)
    color = color[1].to_string().replace("(", "")
    color = color.replace(")", "")
    color = color.replace("rgb", "")
    color = color.replace("a", "")
    color = color.split(",")
    color = '#%02x%02x%02x' % (int(color[0]), int(color[1]), int(color[2]))
    return color


def getThemeColors():
    gtkColorsCodes = {
        "theme_fg_color": "",
        "theme_text_color": "",
        "theme_bg_color": "",
        "theme_selected_fg_color": "",
        "theme_selected_bg_color": "",
        "error_color": ""
    }

    for colorCode in gtkColorsCodes:
        gtkColorsCodes[colorCode] = getHexColor(colorCode)
    return gtkColorsCodes

print(getThemeColors())