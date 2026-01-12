import sys
import json
import numpy as np

def fuse_with_confidence(values, confidences=None):
    """
    Weighted fusion using confidence values.
    If confidences not provided, use equal weights.
    """
    values = np.array(values)

    if confidences is None or len(confidences) == 0:
        # Equal weighting if no confidences
        weights = np.ones_like(values) / len(values)
    else:
        confidences = np.array(confidences)
        # Normalize confidences to get weights
        weights = confidences / confidences.sum()

    # Apply weights
    fused = np.sum(values * weights)

    # Calculate confidence of the fused result
    fused_confidence = np.mean(confidences) if confidences is not None else 1.0

    return float(fused), float(fused_confidence)

if __name__ == "__main__":
    # Read input from C++
    raw = sys.stdin.read()
    data = json.loads(raw)
    values = data["values"]

    confidences = None
    if "confidences" in data:
        confidences = data["confidences"]

    fused_value, fused_confidence = fuse_with_confidence(values, confidences)

    # Return result
    result = {
        "fused": fused_value,
        "confidence": fused_confidence,
        "used_confidences": confidences is not None
    }
    print(json.dumps(result), flush=True)
