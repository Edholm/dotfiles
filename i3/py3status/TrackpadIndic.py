class Trackpad(object):
    def exec_cmd(self, cmd, arg):
        """Take a system command and its argument, then return the result.

        Arguments:
        - `cmd`: system command.
        - `arg`: argument.
        """
        import subprocess
        result = subprocess.check_output([cmd, arg])
        return result.decode()

    def is_enabled(self):
        """ Return whether or not the trackpad is enabled. """
        state = self.exec_cmd("trackpad-toggle.sh", "state").strip()
        return state.startswith("1")

class Py3status(object):

    def print_mute(self, json, i3status_config):
        import time

        # Default options
        position = 0
        response = {'full_text': '', 'name': 'trackpad'}
        response['cached_until'] = time.time() + 600
        response['separator_block_width'] = 20

        t = Trackpad()

        if not t.is_enabled():
            response['color'] = i3status_config['color_bad']
            response['full_text'] = "Trackpad"

        return position, response
