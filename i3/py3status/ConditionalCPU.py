# Requires psutil (https://code.google.com/p/psutil/)
# pacman -S python-psutil if using Arch Linux
class Py3status:
    def __init__(self):
        self.threshold          = 15  # CPU Below this value vill not be shown.
        self.threshold_good     = 10  # In percent
        self.threshold_degraded = 65

    def cond_top(self, json, i3status_config):
        """ Only show cpu-usage when over certain limit """
        import time
        position = 2
        response = {'full_text': '', 'name': 'cpu_usage'}
        response['cached_until'] = time.time() + 5
        response['separator_block_width'] = 20

        import psutil
        cpu = psutil.cpu_percent(interval=2)

        if cpu >= self.threshold:
            if cpu <= self.threshold_good:
                response['color'] = i3status_config['color_good']
            elif cpu <= self.threshold_degraded:
                response['color'] = i3status_config['color_degraded']
            else:
                response['color'] = i3status_config['color_bad']
            response['full_text'] = "CPU: {}%".format(cpu)

        return (position, response)
