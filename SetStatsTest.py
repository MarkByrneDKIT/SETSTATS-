import RPi.GPIO as GPIO
from mpu6050 import mpu6050
import threading
import logging
import time


logging.basicConfig(level=logging.INFO)

from pubnub.callbacks import SubscribeCallback
from pubnub.enums import PNStatusCategory, PNOperationType
from pubnub.pnconfiguration import PNConfiguration
from pubnub.pubnub import PubNub

pnconfig = PNConfiguration()
pnconfig.subscribe_key = "sub-c-76598f48-3f26-11ec-b886-526a8555c638"
pnconfig.publish_key = "pub-c-14d668cc-e874-4e1e-a4ab-bcf78c08744e"
pnconfig.uuid = '590f83a0-2b19-4e7f-9cef-09882f022320'
pubnub = PubNub(pnconfig)

my_channel = 'setstats-pi-channel'
sensor_list = ['coords']
data = {}
xAxis = 0
yAxis = 0

mpu = mpu6050(0x68)

GPIO.setmode(GPIO.BOARD)

TRIG = 13
ECHO = 11
BUZZER = 40

GPIO.setwarnings(False)
GPIO.setup(TRIG, GPIO.OUT)
GPIO.output(TRIG, 0)
GPIO.setup(BUZZER, GPIO.OUT)
GPIO.setup(ECHO, GPIO.IN)

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def beep(repeat):
    for i in range(0, repeat):
        for pulse in range(60):
            GPIO.output(BUZZER, True)
            time.sleep(0.001)
            GPIO.output(BUZZER, False)
            time.sleep(0.001)
        time.sleep(.5)

def collectSensorData():
    timer = time.monotonic()
    while True:
        GPIO.output(TRIG, 1)
        time.sleep(0.00001)
        GPIO.output(TRIG, 0)

        while GPIO.input(ECHO) == 0:
            pass
        start = time.time()

        while GPIO.input(ECHO) == 1:
            pass
        stop = time.time()

        xAxis = "{:.2f}".format(mpu.get_gyro_data()['z'])
        yAxis = "{:.2f}".format((stop - start) * 17000)
        print(mpu.get_gyro_data()['z'])
        print((stop - start) * 17000)

        """
        while yAxis > 1000:
            yAxis = "{:.2f}".format(getHeight())
    
        print(bcolors.OKCYAN + xAxis + "cm" + bcolors.ENDC)
        print(bcolors.OKBLUE + yAxis + "cm" + bcolors.ENDC)
        print("")
    
        if (xAxis <= 10 or xAxis >= -10):
            messageColour = bcolors.OKGREEN
        elif (xAxis <= 20 or xAxis >= -20):
            messageColour = bcolors.WARNING
        else:
            messageColour = bcolors.FAIL
    
        if (xAxis >= 60 or xAxis <= -60):
            beep(5)
            print(bcolors.FAIL + bcolors.BOLD + "X value passed threshold" + bcolors.ENDC)
        print(messageColour + xAxis + "cm" + bcolors.ENDC)
        print(messageColour + yAxis + "cm" + bcolors.ENDC)
        print("")
        """
        publish(my_channel, {f"{timer}": f"{xAxis}, {yAxis}"})
        time.sleep(.25)

def publish(channel, msg):
    pubnub.publish().channel(channel).message(msg).pn_async(my_publish_callback)

def my_publish_callback(envelope, status):
    # Check whether request successfully completed or not
    if not status.is_error():
        print("Message successfully published")
        pass  # Message successfully published to specified channel.
    else:
        pass  # Handle message publish error. Check 'category' property to find out possible issue
        # because of which request did fail.
        # Request can be resent using: [status retry];

class MySubscribeCallback(SubscribeCallback):
    def presence(self, pubnub, presence):
        pass  # handle incoming presence data

    def status(self, pubnub, status):
        if status.category == PNStatusCategory.PNUnexpectedDisconnectCategory:
            pass  # This event happens when radio / connectivity is lost

        elif status.category == PNStatusCategory.PNConnectedCategory:
            # Connect event. You can do stuff like publish, and know you'll get it.
            # Or just use the connected event to confirm you are subscribed for
            # UI / internal notifications, etc
            pubnub.publish().channel(my_channel).message('Starting...').pn_async(my_publish_callback)
        elif status.category == PNStatusCategory.PNReconnectedCategory:
            pass
            # Happens as part of our regular operation. This event happens when
            # radio / connectivity is lost, then regained.
        elif status.category == PNStatusCategory.PNDecryptionErrorCategory:
            pass
            # Handle message decryption error. Probably client configured to
            # encrypt messages and on live data feed it received plain text.

    def message(self, pubnub, message):
        # Handle new message stored in message.message
        try:
            msg = message.message
            key = list(msg.keys())
            if key[0] == "event":
                self.handle_event(msg)
        except Exception as e:
            print(message.message)
            print(e)
            pass

    def handle_event(self, msg):
        global data
        event_data = msg["event"]
        key = list(event_data.keys())
        print(key)
        print(key[0])
        if key[0] in sensor_list:
            print(event_data[key[0]])

if __name__ == '__main__':
    sensors_thread = threading.Thread(target=collectSensorData)
    sensors_thread.start()
    pubnub.add_listener(MySubscribeCallback())
    pubnub.subscribe().channels(my_channel).execute()


