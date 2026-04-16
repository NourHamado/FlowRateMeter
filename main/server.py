from flask import Flask, jsonify
from flask_cors import CORS
import csv
import global_vars

app = Flask(__name__)
CORS(app)

CSV_FILE = "flow_data.csv"

@app.route("/live")
def live_data():
    return jsonify({
        "flowrate": global_vars.g_flowrate,
        "total_volume": global_vars.g_total_vol,
        "avg_flowrate": global_vars.g_avg_flowrate
    })


@app.route("/history")
def history():
    data = []
    try:
        with open(CSV_FILE, 'r') as f:
            reader = csv.DictReader(f)
            for row in reader:
                data.append(row)
    except FileNotFoundError:
        pass

    return jsonify(data)


def start_server():
    app.run(host="0.0.0.0", port=5000)