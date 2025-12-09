import sys
import json
import numpy as np

def fuzzy_fusion(values):
    """Simple fuzzy logic fusion"""
    values = np.array(values)
    mean_val = np.mean(values)
    std_val = np.std(values)

    # Fuzzy rules
    if mean_val > 0.8 and std_val < 0.1:
        return 0.95  # Strong consensus high
    elif mean_val < 0.2 and std_val < 0.1:
        return 0.05  # Strong consensus low
    elif std_val < 0.2:
        return mean_val  # Good agreement
    else:
        # High conflict - trust the majority
        high_count = np.sum(values > 0.5)
        if high_count > len(values) / 2:
            return np.mean(values[values > 0.5])
        else:
            return np.mean(values[values <= 0.5])

def main():
    raw = sys.stdin.read()
    data = json.loads(raw)
    values = data["values"]

    fused = fuzzy_fusion(values)
    fused = np.clip(fused, 0, 1)

    print(json.dumps({"fused": fused}), flush=True)

if __name__ == "__main__":
    main()
