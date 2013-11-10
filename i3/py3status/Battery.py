import dbus
class Battery:
    def get_state(self):
        phrase = { 
             0: 'Unknown',
             1: 'Charging',
             2: 'Discharging',
             3: 'Empty',
             4: 'Fully charged',
             5: 'Pending charge',
             6: 'Pending discharge'}
        
        state = int(self._get_property('State'))
        return state, phrase[state]

    def get_percentage(self):
        return float(self._get_property('Percentage'))

    def _time_to_full(self):
        left = self._get_property('TimeToFull')
        return int(left) # In seconds

    def _time_to_empty(self):
        left = self._get_property('TimeToEmpty')
        return int(left) # In seconds

    def time_left(self):
        to_empty = self._time_to_empty()
        to_full  = self._time_to_full()
        return max(to_empty, to_full)
        
    def sec_to_hms(self, secs=0):
        """ Returns a tuple with (hours, minutes, seconds)"""
        from datetime import timedelta
        d = timedelta(seconds=secs)
        hours, remainder = divmod(d.seconds, 3600)
        minutes, seconds = divmod(remainder, 60)
        return (hours, minutes, seconds)

    def capacity(self):
        """The capacity of the power source expressed as a percentage between 
        0 and 100. The capacity of the battery will reduce with age. 
        A capacity value less than 75% is usually a sign that you should renew 
        your battery. Typically this value is the same as 
        (full-design / full) * 100. However, some primitive power sources are 
        not capable reporting capacity and in this case the capacity property 
        will be unset."""
        return float(self._get_property('Capacity'))

    def _get_property(self, prop):
        bus = dbus.SystemBus() 
        upower = bus.get_object('org.freedesktop.UPower', 
                '/org/freedesktop/UPower/devices/battery_BAT0')
        return upower.Get('org.freedesktop.DBus.Properties', 
                prop, dbus_interface=dbus.PROPERTIES_IFACE)

class Py3status:
    def battery(self, json, i3status_config):
        import time

        # Default options
        postion = 0
        response = {'full_text': '', 'name': 'battery'}
        response['cached_until'] = time.time() + 10 # refresh every 10s
        response['separator_block_width'] = 20 

        batt          = Battery()
        percentage    = batt.get_percentage()
        state, phrase = batt.get_state()
        h, m, s       = batt.sec_to_hms(batt.time_left())

        response['icon'] = self._get_icon(percentage, state) 

        # Choose color based on battery level left.
        if percentage <= 15:
            response['color']      = i3status_config['color_bad'] 
            response['icon_color'] = response['color']
        elif percentage <= 50:
            response['color'] = i3status_config['color_degraded'] 
        elif state == 2:
            response['color'] = i3status_config['color_good'] 

        # Format
        if (state != 1 and state != 4) or percentage < 95:
            response['full_text'] = ' {}%'.format(int(percentage))
            if h > 0 and m > 0 and s > 0:
                response['full_text'] += ' {}h {}m {}s left'.format(h, m, s)
        return (postion, response)

    def _get_icon(self, percentage, state):
        import math
        icon_path = "/home/eda/.i3/icons/"
        if state == 1 or state == 4: 
            # Charging or Fully Charged
            return icon_path + "ac.xbm"
        elif percentage <= 80:
            # Round up to nearest tenth.
            return icon_path + "battery" + str(math.ceil(percentage/10)*10) + ".xbm"
        else:
            return icon_path + "battery80.xbm" 

