class Wifi:
    def exec_cmd(self, cmd, arg):
        """Take a system command and its argument, then return the result.

        Arguments:
        - `cmd`: system command.
        - `arg`: argument.
        """
        import subprocess
        result = subprocess.check_output([cmd, arg])
        return result.decode()

    def info(self):
        import re
        out = self.exec_cmd("iwconfig", "wlan0")
        
        # If we can't match a MAC-address, then we're not connected
        ap_p = r'Access Point: (([0-9A-F]{2}[:]){5}([0-9A-F]{2}))'
        connected = re.search(ap_p, out) != None
        
        if connected:
            essid_p = r'ESSID:"(.*)"'
            essid = re.search(essid_p, out).group(1)

            qual_p = r'Link Quality=((?P<Left>[0-9][0-9])/(?P<Right>[0-9][0-9]))'
            quality = re.search(qual_p, out)
            left = int(quality.group("Left")) 
            right = int(quality.group("Right")) 
            return essid, int((left/right) * 100)
        else:
            return None, None

class Py3status:
    def output(self, json, i3status_config):
        import time
        position = 0
        response = {'full_text': 'wifi', 'name': 'wifi'}
        response['cached_until'] = time.time() + 20 # refresh every 10s
        response['separator_block_width'] = 20 
 
        wifi = Wifi() 
        essid, quality = wifi.info()

        if essid is None:
            response['full_text'] = "Disconnected" 
            response['color'] = i3status_config['color_bad']
            response['icon'] = "/home/eda/.i3/icons/net_down_01.xbm"
        else:
            response['icon'] = self._get_icon(quality)
            response['full_text'] = " " + essid
            if quality < 45:
                if quality <= 20:
                    response['color'] = i3status_config['color_bad'] 
                else:
                    response['color'] = i3status_config['color_degraded'] 
                response['full_text'] += " (" + str(quality) + "%)"
        return position, response 
        
    def _get_icon(self, quality):
        import math
        icon_path = "/home/eda/.i3/icons/"
        return icon_path + "wlan" + str(math.ceil(quality/20)) + ".xbm"
