class Py3status:
    """ Only show cpu-usage when over certain limit """
    def cond_top(self, json, i3status_config):
        import time
        threshold = 35 # In percent
        threshold_degraded = 65

        position = 0
        response = {'full_text': '', 'name': 'cpu_usage'}
        response['cached_until'] = time.time() + 1 # refresh every 10
        response['separator_block_width'] = 20 

        cpu = 0 

        if cpu >= threshold:
            if cpu <= threshold_degraded:
                response['color'] = i3status_config['color_degraded']
            else:
                response['color'] = i3status_config['color_bad']
            response['full_text'] = "CPU: {}%".format(cpu)
        
        return (position, response)
