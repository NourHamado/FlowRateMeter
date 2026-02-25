import threading as thr
import time
import csv
import global_vars
from gpiozero import DigitalInputDevice
from datetime import datetime

FLOW_PIN = 20        
CALIBRATION_FACTOR = 10 #check 9.8 latter

pulse_count = 0
start_time = time.time()

CSV_FILE = "flow_data.csv"

def flow_pulse():
    global pulse_count
    pulse_count += 1


def update_globals(g_lock, flowrate, total_vol, avg_flowrate):
    with g_lock:
        global_vars.g_flowrate = round(flowrate, 2)
        global_vars.g_total_vol = round(total_vol, 2)
        global_vars.g_avg_flowrate = round(avg_flowrate, 2)

def write_csv(flowrate, total_vol, avg_flowrate):
    file_exists = False
    try:
        with open(CSV_FILE, 'r') as f: file_exists = True
    except FileNotFoundError: pass

    with open(CSV_FILE, 'a', newline='') as f:
        writer = csv.writer(f)
        if not file_exists:
            writer.writerow(["Timestamp", "FlowRate", "TotalVol", "AvgFlowRate"])
        writer.writerow([
            datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            round(flowrate, 2),
            round(total_vol, 2),
            round(avg_flowrate, 2)
        ])

def logger_loop(g_lock):
    global pulse_count
    total_ml = 0
    interval = 10

    t = thr.currentThread()

    flow_sensor=DigitalInputDevice(FLOW_PIN, pull_up=True)
    flow_sensor.when_activated  = flow_pulse

    last_time = time.time()

    while getattr(t, "running", True):
        current_time = time.time()
        if current_time - last_time >= interval:
            elapsed = current_time - last_time

            current_pulses = pulse_count
            pulse_count = 0
            last_time = current_time

            flowrate = (current_pulses / elapsed) / CALIBRATION_FACTOR
            flow_ml = (flowrate / 60) * elapsed * 1000 
            total_ml += flow_ml

            avg_flowrate = total_ml / (current_time - start_time)

            update_globals(g_lock, flowrate, total_ml, avg_flowrate)
            write_csv(flowrate, total_ml, avg_flowrate)
        time.sleep(0.1)

    flow_sensor.close()
