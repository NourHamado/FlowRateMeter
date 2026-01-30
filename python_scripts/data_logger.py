import RPi.GPIO as GPIO
import threading as thr
import time
import requests
import global_vars

thingspeakKey = '0E4NVRSW981M90O9'
FLOW_SENSOR_PIN = 17
CALIBRATION_FACTOR = 1.0

pulse_count = 0
start_time = time.time()

def pulse_callback(channel):
    global pulse_count
    pulse_count += 1
def read_data():
    global pulse_count
    new_data = {'flowrate': 0.0, 'total_vol': 0.0, 'avg_flowrate': 0.0, 'null_input': False}

    duration = 5 
    time.sleep(duration) 
    
    flowRate = (pulse_count / duration) / CALIBRATION_FACTOR
    
    total_vol_increment = (flowRate / 60.0) * 1000.0 * duration
    global_vars.g_total_vol += total_vol_increment
    
    # avg_flowrate
    elapsed = time.time() - start_time
    avg_flow = global_vars.g_total_vol / elapsed if elapsed > 0 else 0
    
    new_data['flowrate'] = flowRate
    new_data['total_vol'] = global_vars.g_total_vol
    new_data['avg_flowrate'] = avg_flow
    
    pulse_count = 0 
    return new_data

def update_globals(g_lock, flowrate, total_vol, avg_flowrate):
    with g_lock:
        global_vars.g_flowrate = flowrate
        global_vars.g_total_vol = total_vol
        global_vars.g_avg_flowrate = avg_flowrate

# update_database(): connects to Thingspeak
def update_database(flowrate, total_vol, avg_flowrate):
    url = 'https://api.thingspeak.com/update.json'
    params = {
        'api_key': thingspeakKey,
        'field1': flowrate
    }
    try:
        response = requests.post(url, data=params, timeout=2)
        print(response.text)
    except:
        print("Database update failed")
    print(f"Data: {flowrate} L/min, {total_vol} mL, {avg_flowrate} mL/s")

# Main Thread loop
def logger_loop(g_lock):
    # Setup GPIO
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(FLOW_SENSOR_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    GPIO.add_event_detect(FLOW_SENSOR_PIN, GPIO.FALLING, callback=pulse_callback)
    
    t = thr.current_thread()
    
    try:
        while(getattr(t, "running", True)):
            new_data = read_data()
            if(new_data['null_input'] == False):
                update_globals(g_lock, new_data['flowrate'], new_data['total_vol'], new_data['avg_flowrate'])
                update_database(new_data['flowrate'], new_data['total_vol'], new_data['avg_flowrate'])
    finally:
        GPIO.cleanup()