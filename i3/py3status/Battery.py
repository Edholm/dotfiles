import dbus
class Battery:
    def get_state(self):
        possible = { 
        0: 'Unknown',
        1: 'Charging',
        2: 'Discharging',
        3: 'Empty',
        4: 'Fully charged',
        5: 'Pending charge',
        6: 'Pending discharge'} 
        state = int(self._get_property('State'))
        return {state, possible[state]} 

    def get_percentage(self):
        return float(self._get_property('Percentage'))

    def time_to_full(self):
        left = self._get_property('TimeToFull')
        return int(left) # In seconds

    def time_to_empty(self):
        left = self._get_property('TimeToFull')
        return int(left) # In seconds

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

        icon_dir = "/home/eda/.i3/icons/"

        response = {'full_text': '', 'name': 'battery'}
        response['cached_until'] = time.time() + 5 # refresh every 5s
        response['color'] = i3status_config['color_degraded']
        response['separator_block_width'] = 20 
        postion = 0
        return (postion, response)

if __name__ == "__main__":
    batt = Battery()
    print(batt.capacity())
