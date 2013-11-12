class Volume:
    def exec_cmd(self, cmd, arg):
        """Take a system command and its argument, then return the result.

        Arguments:
        - `cmd`: system command.
        - `arg`: argument.
        """
        import subprocess
        result = subprocess.check_output([cmd, arg])
        return result.decode()

    def is_muted(self):
        return self.exec_cmd("cvol", "-p").strip() == "off"

class Py3status:
    def print_mute(self, json, i3status_config):
        import time

        # Default options
        position = 3
        response = {'full_text': '', 'name': 'battery'}
        response['cached_until'] = time.time() + 10 # refresh every 10s
        response['separator_block_width'] = 20 

        vol = Volume()
        
        if vol.is_muted(): 
            response['color'] = i3status_config['color_degraded']
            response['full_text'] = "Muted"

        return position, response
