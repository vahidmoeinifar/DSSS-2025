---
sidebar_position: 7
---

### Loading Data Files:

System can read values from text files, helpful with saved datasets or exports from other software.

**Supported File Types:**

-   Plain text (.txt) - Most reliable
    
-   CSV files (.csv) - Comma-separated values
    
-   Any file with readable text content
    

**File Structure Examples:**

**Single line format:**
````
0.75, 0.82, 0.91, 0.45, 0.67
````

**Multi-line format:**
````
0.75 0.82 0.91
0.45 0.33 0.67
0.12 0.25 0.38
````
**Mixed separators:**
````
0.75, 0.82 0.91; 0.45
0.33,0.67 0.12;0.25
````
**With comments:**
````
 Monday's estimates
0.75, 0.82, 0.91  # Senior agents
0.45, 0.33, 0.67  # Junior agents
Wednesday's estimates
0.60, 0.71, 0.82
````
**Mixed separators:**
````
0.75, 0.82 0.91; 0.45
0.33,0.67 0.12;0.25
````

**Loading Process:**

1.  Click "Open Data" button or menu → "Load Data File"
2.  Navigate to and select your file
3.  System scans file, extracts valid numbers between 0 and 1
4.  Values automatically add to current agent list
5.  Message confirms how many values loaded successfully

**File Import Notes:**
-   System ignores anything not a valid number between 0 and 1
-   Can load multiple files sequentially - each appends to current list
-   Large files (thousands of values) might take a moment to process
-   If no valid values found, you'll see error message
    

**Practical Example:**  
Suppose you have Excel data to analyze:
1.  In Excel, save your column of values as "CSV (Comma delimited)"
2.  In GDSS Simulator, load this CSV file
3.  All valid values import instantly
4.  Run fusion algorithms on your dataset

