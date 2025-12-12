---
sidebar_position: 8
---


### Custom Script Integration:

For researchers and developers testing their own fusion algorithms.

**Adding Your Algorithm:**

1.  Write Python script following required format
2.  In simulator, go to Custom Script section (center panel)
3.  Click "Load Script" and select your .py file
4.  Click "Add to Algorithms"
5.  Your algorithm now appears in dropdown menu
**Python Script Template:**
````
import sys, json, numpy as np

def your_fusion_method(values):
    # Your logic here
    # 'values' is a list of numbers
    # Return a single number between 0 and 1
    return result

if __name__ == "__main__":
    data = json.loads(sys.stdin.read())
    values = data["values"]
    result = your_fusion_method(values)
    result = max(0, min(1, result))  # Ensure 0-1 range
    print(json.dumps({"fused": result}))
````

**Script Validation:**  
System checks that your script:

-   Executes without errors
    
-   Returns valid JSON
    
-   Provides "fused" field
    
-   Returns numeric value
    

### Keyboard Shortcuts:

Work faster with keyboard commands.

**Available Shortcuts:**

-   **Enter:** Add value from manual input field
    
-   **Ctrl+Enter:** Parse and add values from batch input area
    
-   **Ctrl+O:** Open file dialog directly
    
-   **Arrow Keys:** Navigate through interface elements when focused
    
-   **Tab:** Move between input fields and buttons
    

### Progress Monitoring:

When running fusion algorithm, watch for indicators:

1.  **Progress Bar:** Moving animation shows system is working
    
2.  **Status Message:** Text updates show what's happening
    
3.  **Button State:** Run button becomes temporarily disabled
    
4.  **Result Update:** When complete, result appears with color coding
    

### Color Coding System:

Results use color to convey meaning at a glance.

**Color Meanings:**

-   **Bright Green (#4CAF50):** High confidence results (0.7-1.0)
    
-   **Gold/Yellow (#FFD166):** Moderate confidence (0.3-0.699)
    
-   **Red/Orange (#FF6B6B):** Low confidence (0-0.299)
    
-   **Default White:** No result yet or exactly zero
    

Visual feedback helps quickly interpret results without reading numbers.

### Multiple Algorithm Testing:

Compare algorithms efficiently.

**Procedure:**

1.  Load your dataset once
    
2.  Select first algorithm, click Run, record result
    
3.  Select second algorithm, click Run, record result
    
4.  Repeat for all algorithms of interest
    
5.  Compare how different methods handle your data
    

### Batch Processing Workaround:

While not automated, can process multiple datasets.

**Procedure:**

1.  Keep text file with each dataset on separate lines
    
2.  Load first line's values, run all algorithms, record results
    
3.  Clear all, load next line's values, repeat
    
4.  Compile results in spreadsheet
    