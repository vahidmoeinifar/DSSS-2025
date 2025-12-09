import sys
import json
import numpy as np
from sklearn.neural_network import MLPRegressor

def main():
    raw = sys.stdin.read()
    data = json.loads(raw)
    values = np.array(data["values"], dtype=np.float32)

    # Neural network fusion
    X_train = np.random.rand(300, len(values))
    y_train = X_train.mean(axis=1) + np.random.normal(0, 0.01, 300)

    model = MLPRegressor(hidden_layer_sizes=(16,), activation='relu', max_iter=300)
    model.fit(X_train, y_train)

    fused = float(model.predict(values.reshape(1, -1))[0])
    fused = np.clip(fused, 0, 1)

    print(json.dumps({"fused": fused}), flush=True)

if __name__ == "__main__":
    main()
