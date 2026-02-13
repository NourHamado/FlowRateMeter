import threading as thr
import time
import csv
import global_vars
from gpiozero import DigitalInputDevice

FLOW_PIN = 20        
CALIBRATION_FACTOR = 0.54

pulse_count = 0
start_time = time.time()
total_ml = 0

CSV_FILE = "flow_data.csv"

def flow_pulse():
    global pulse_count
    pulse_count += 1


def update_globals(g_lock, flowrate, total_vol, avg_flowrate):
    with g_lock:
        global_vars.g_flowrate = flowrate
        global_vars.g_total_vol = total_vol
        global_vars.g_avg_flowrate = avg_flowrate


def write_csv(flowrate, total_vol, avg_flowrate):
    with open(CSV_FILE, 'a', newline='') as f:
        writer = csv.writer(f)
        writer.writerow([time.time(), flowrate, total_vol, avg_flowrate])


def logger_loop(g_lock):
    global pulse_count, total_ml

    t = thr.currentThread()

    flow_sensor=DigitalInputDevice(FLOW_PIN, pull_up=True)
    flow_sensor.when_activated = flow_pulse

    with open(CSV_FILE, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(["timestamp", "flowrate", "total_volume_ml", "avg_flowrate"])

    last_time = time.time()

    while getattr(t, "running", True):
        time.sleep(5)

        current_time = time.time()
        elapsed = current_time - last_time

        flowrate = (pulse_count / elapsed) / CALIBRATION_FACTOR
        flow_ml = (flowrate / 300) * 1000
        total_ml += flow_ml

        avg_flowrate = total_ml / (current_time - start_time)

        pulse_count = 0
        last_time = current_time

        update_globals(g_lock, flowrate, total_ml, avg_flowrate)
        write_csv(flowrate, total_ml, avg_flowrate)
        
      flow_sensor.close()