---
sidebar_position: 9
---

### Common Issues and Solutions:

**Problem:** "Python failed to start" error  
**Solution:**

-   Ensure Python installed and added to system PATH
    
-   Test by opening command prompt: `python --version`
    
-   If doesn't work, reinstall Python with "Add to PATH" option checked
    

**Problem:** "Script file not found" error  
**Solution:**

-   Built-in scripts must remain in "scripts" folder next to application
    
-   Don't move or delete this folder
    
-   If moved, place back in original location
    

**Problem:** No result appears after clicking Run Fusion  
**Solution:**

1.  Check you have at least one agent value loaded
    
2.  Verify algorithm selected from dropdown
    
3.  Look at status message for error information
    
4.  Try Weighted Average algorithm first (most reliable)
    

**Problem:** File won't load or shows "No valid values"  
**Solution:**

1.  Open file in text editor to check content
    
2.  Ensure values between 0 and 1
    
3.  Check numbers use decimal points (.) not commas (,)
    
4.  Try simplifying file to one value per line
    
5.  Remove any headers or non-numeric content
    

**Problem:** Custom script doesn't appear in algorithm list  
**Solution:**

1.  Verify script follows required format
    
2.  Check loads without errors in Custom Script section
    
3.  Click "Add to Algorithms" after loading
    
4.  If appears with (Custom) suffix, successfully added
    

**Problem:** Results seem inconsistent between runs  
**Solution:**

-   Some algorithms (like Neural Network) use random elements during training
    
-   For completely consistent results, use deterministic algorithms like Weighted Average or Consensus
    

### Performance Tips:

-   **Large datasets** (100+ values): Some algorithms may run slower. Progress bar shows activity.
    
-   **Unresponsive interface:** During processing, wait a moment - should recover when Python script completes.
    
-   **Memory usage:** Increases with very large datasets. If crashes with thousands of values, work with smaller subsets.
    

### Recovery Procedures:

**Data Loss Prevention:**

-   Before clearing all values, consider copying from batch input area
    
-   When testing new algorithms, record results before changing settings
    
-   Keep source data files as backups
    

**Application Recovery:**  
If application freezes or crashes:

1.  Close application completely
    
2.  Restart it
    
3.  Last dataset won't be saved unless exported
    
4.  Reload from source file if needed
    