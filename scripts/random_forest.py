import sys
import json
import numpy as np
import pickle
import os
from sklearn.ensemble import RandomForestRegressor

def main():
    raw = sys.stdin.read()
    data = json.loads(raw)
    values = np.array(data["values"], dtype=np.float32).reshape(1, -1)

    # Generate training data
    n_samples = 500
    n_agents = len(values[0])

    X_train = np.random.rand(n_samples, n_agents)
    y_train = X_train.mean(axis=1)  # Simple target

    model = RandomForestRegressor(n_estimators=100, random_state=42)
    model.fit(X_train, y_train)

    fused = float(model.predict(values)[0])
    fused = np.clip(fused, 0, 1)

    print(json.dumps({"fused": fused}), flush=True)

if __name__ == "__main__":
    main()
