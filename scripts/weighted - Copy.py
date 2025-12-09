import sys
import json
import numpy as np

def main():
    raw = sys.stdin.read()
    data = json.loads(raw)
    values = np.array(data["values"], dtype=np.float32)

    # Weighted average with confidence weighting
    weights = values  # Use values as confidence
    weights = weights / weights.sum() if weights.sum() > 0 else np.ones_like(values) / len(values)

    fused = float(np.sum(values * weights))
    fused = np.clip(fused, 0, 1)

    print(json.dumps({"fused": fused}), flush=True)

if __name__ == "__main__":
    main()
