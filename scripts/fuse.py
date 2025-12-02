import sys
import json
import numpy as np
from sklearn.neural_network import MLPRegressor

# read JSON from C++
raw = sys.stdin.read()
data = json.loads(raw)
values = np.array(data["values"], dtype=np.float32)

# ---- AI MODEL (placeholder) ----
# simple neural fusion: train a tiny model on synthetic examples
X_train = np.random.rand(300, len(values))
y_train = X_train.mean(axis=1) + np.random.normal(0, 0.01, 300)

model = MLPRegressor(hidden_layer_sizes=(16,),
                     activation='relu',
                     max_iter=300)
model.fit(X_train, y_train)

# produce fused result
fused = float(model.predict(values.reshape(1, -1))[0])

# print result for C++
result = json.dumps({"fused": fused})
print(result, flush=True)  # Add flush=True to ensure output is sent
sys.stdout.flush()  # Alternative flush method
