import RPi.GPIO as GPIO
from mpu6050 import mpu6050
# import matplotlib.pyplot as plt
import time

mpu = mpu6050(0x68)

GPIO.setmode(GPIO.BOARD)

TRIG = 13
ECHO = 11
BUZZER = 40

GPIO.setup(TRIG,GPIO.OUT)
GPIO.output(TRIG,0)
GPIO.setup(BUZZER, GPIO.OUT)
GPIO.setup(ECHO,GPIO.IN)

def beep(repeat):
    for i in range(0, repeat):
        for pulse in range(60):
            GPIO.output(BUZZER, True)
            time.sleep(0.001)
            GPIO.output(BUZZER, False)
            time.sleep(0.001)
        time.sleep(1)

time.sleep(0.1)

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

print ("starting")

while True:

    GPIO.output(TRIG,1)
    time.sleep(0.00001)
    GPIO.output(TRIG,0)

    while GPIO.input(ECHO) == 0:
        pass
    start = time.time()

    while GPIO.input(ECHO) == 1:
        pass
    stop = time.time()
    
    accelerometer_data = mpu.get_gyro_data()
    xAxis = "{:.2f}".format(accelerometer_data['y'])
    yAxis = "{:.2f}".format((stop - start) * 17000)

    print(bcolors.OKCYAN + xAxis + "cm" + bcolors.ENDC)
    print(bcolors.OKBLUE + yAxis + "cm" + bcolors.ENDC)
    print("")
    # plt.plot(xAxis, yAxis)
    # plt.title('SetStats')
    # plt.xlabel('Sway')
    # plt.ylabel('Height')
    # plt.show()

    if(accelerometer_data['y'] >= 30 or accelerometer_data['y'] <= -30):
        beep(5)


    time.sleep(.75)
    
    

