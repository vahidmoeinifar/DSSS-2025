---
sidebar_position: 10
---

### System Architecture:

Three-layer architecture:

**Presentation Layer (QML):**

-   Visual interface built with Qt Quick
    
-   Handles user interactions, displays data, provides visual feedback
    
-   Communicates with logic layer through defined interfaces
    

**Logic Layer (C++):**

-   Decision engine written in C++ with Qt framework
    
-   Manages data flow between components
    
-   Executes Python scripts as separate processes
    
-   Handles JSON serialization/deserialization
    
-   Manages errors and exceptions
    
-   Provides business logic for fusion operations
    

**Algorithm Layer (Python):**

-   Fusion algorithms as standalone Python scripts
    
-   Each script:
    
    -   Receives JSON input via standard input
        
    -   Performs specific fusion calculation
        
    -   Returns JSON output via standard output
        
    -   Operates independently for security and stability
        

### Data Flow:

1.  User inputs values through interface
    
2.  QML sends values to C++ engine as list
    
3.  C++ engine converts to JSON format
    
4.  Python script receives JSON via stdin
    
5.  Script processes data and returns JSON via stdout
    
6.  C++ engine parses result and updates interface
    
7.  QML displays final fused value
    

### Communication Protocol:

Simple JSON-based protocol.

**To Python script:**
````
{
  "values": [0.75, 0.5, 0.25],
  "agent_count": 3
}
````
**From Python script:**
````
{
  "fused": 0.583
}
````
Error messages from Python captured and displayed in interface.

### Algorithm Details:

**Weighted Average:**

-   Formula: result = Σ(value_i × weight_i) / Σ(weight_i)
    
-   Weight_i = value_i (confidence assumption)
    
-   Ensures result stays in [0,1] range
    

**Neural Network:**

-   Uses scikit-learn MLPRegressor
    
-   16 hidden neurons, ReLU activation
    
-   Trained on 300 synthetic examples
    
-   Input scaling: values used directly
    
-   Output scaling: clipped to [0,1]
    

**Fuzzy Logic:**

-   Implements rule-based system
    
-   Rules based on mean and standard deviation
    
-   Three fuzzy sets: low, medium, high
    
-   Defuzzification: weighted average method
    

**Random Forest:**

-   100 decision trees (n_estimators=100)
    
-   Default scikit-learn parameters
    
-   Trained on synthetic data matching input dimensions
    
-   Ensemble averaging for final result
    

**Consensus:**

-   Agreement threshold: 0.2 (20%)
    
-   Consensus exists if standard deviation < threshold
    
-   With consensus: result = mean
    
-   Without consensus: result = median
    

### System Requirements:

**Minimum:**

-   64-bit processor
    
-   4 GB RAM
    
-   500 MB disk space
    
-   Python 3.7+
    
-   Windows 10, macOS 10.14, or Ubuntu 18.04
    

**Recommended:**

-   8 GB RAM or more
    
-   SSD storage
    
-   Python 3.9+
    
-   Modern operating system
    

**Python Dependencies:**

-   numpy (numerical computations)
    
-   scikit-learn (machine learning algorithms)
    
-   Standard library modules: json, sys, random
    

### Installation Verification:

Verify installation:

1.  Open command prompt/terminal
    
2.  Type: `python --version` (should show Python 3.x)
    
3.  Type: `python -c "import numpy; import sklearn; print('OK')"`
    
4.  If see "OK", dependencies installed correctly
    
