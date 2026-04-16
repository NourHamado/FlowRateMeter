from tkinter import *
from tkinter import ttk
import threading as thr
from data_logger import *
import global_vars
import server

import time
import requests


def create_widgets(flowrate, total_vol, avg_flowrate):
  ttk.Label(frame, text="Water Flow Sensor").grid(column=1, row=0, padx=10, pady=10)

  ttk.Label(frame, textvariable=flowrate).grid(column=0, row=1, padx=10, pady=10)
  ttk.Label(frame, textvariable=total_vol).grid(column=1, row=1, padx=10, pady=10)
  ttk.Label(frame, textvariable=avg_flowrate).grid(column=2, row=1, padx=10, pady=10)

  ttk.Button(frame, text="Quit", command=lambda: shutdown_app(root, t)).grid(column=2, row=2)

  flowrate.set("Flow Rate: N/A")
  total_vol.set("Total Volume: N/A")
  avg_flowrate.set("Average Flow Rate: N/A")


def refresh_data():
    with g_lock:
        flowrate.set(f"Flow Rate: {global_vars.g_flowrate}")
        total_vol.set(f"Total Volume: {global_vars.g_total_vol}")
        avg_flowrate.set(f"Average Flow Rate: {global_vars.g_avg_flowrate}")

    root.after(3000, refresh_data)


def shutdown_app(root, t):
  t.running = False
  t.join()
  root.after(0, root.destroy)


# initialize global variables
global_vars.init()
g_lock = thr.Lock()

# TKinter Window
root = Tk()
root.title('Project FlowMeter')

frame = ttk.Frame(root, padding=15)
frame.grid()

flowrate = StringVar()
total_vol = StringVar()
avg_flowrate = StringVar()

create_widgets(flowrate, total_vol, avg_flowrate)

# Logger thread
t = thr.Thread(target=logger_loop, args=(g_lock,))
t.start()

# Flask thread
flask_thread = thr.Thread(target=server.start_server)
flask_thread.daemon = True
flask_thread.start()

root.after(3000, refresh_data)

root.mainloop()