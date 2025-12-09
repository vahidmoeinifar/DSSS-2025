import sys
import json
import numpy as np

def main():
    raw = sys.stdin.read()
    data = json.loads(raw)
    values = np.array(data["values"], dtype=np.float32)

    # Consensus-based fusion
    threshold = 0.2
    mean_val = np.mean(values)

    # Check if consensus exists
    within_threshold = np.abs(values - mean_val) < threshold
    consensus_ratio = np.sum(within_threshold) / len(values)

    if consensus_ratio > 0.7:  # Strong consensus
        fused = mean_val
    else:  # Weak consensus, be conservative
        fused = np.median(values)

    fused = np.clip(fused, 0, 1)

    print(json.dumps({"fused": fused}), flush=True)

if __name__ == "__main__":
    main()
