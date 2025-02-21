# utils/file_manager.py
import json

def save_simulation(master_state, filename):
    with open(filename, "w") as f:
        json.dump(master_state.to_dict(), f, indent=4)

def load_simulation(master_state, filename):
    with open(filename, "r") as f:
        data = json.load(f)
        master_state.load_from_dict(data)
