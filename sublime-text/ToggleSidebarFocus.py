import sublime
import sublime_plugin


class ToggleSidebarFocusCommand(sublime_plugin.WindowCommand):
    def run(self):
        if self.window.is_sidebar_visible():
            self.window.set_sidebar_visible(False)
        else:
            self.window.set_sidebar_visible(True)
            self.window.run_command("focus_side_bar")
