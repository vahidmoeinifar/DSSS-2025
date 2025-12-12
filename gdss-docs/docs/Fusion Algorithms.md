---
sidebar_position: 6
---

Five built-in fusion algorithms, each with different approach to combining agent inputs.

### 1. Weighted Average Algorithm

**What it does:**
-   Most intuitive method
-   Treats each agent's value as both estimate and confidence
-   Agents with higher values assumed more confident
-   Their opinions carry more weight
    

**When to use it:**
-   Start here when learning the system
-   When agents with higher estimates are generally more reliable
-   When you want straightforward, easily explainable result

**Example:**
-   Inputs: [0.8, 0.6, 0.4]
-   Agent with 0.8 gets most influence
-   Agent with 0.6 gets moderate influence
-   Agent with 0.4 gets least influence
    
### 2. Neural Network Algorithm

**What it does:**
-   Uses machine learning to find complex patterns
-   Creates small artificial brain
-   Learns from example data how to best combine inputs
    
**When to use it:**
-   When relationships between agents might be complicated
-   When two agents who usually agree suddenly disagree
-   When you have historical data showing how agents' estimates relate to outcomes

**Technical Note:**
-   Generates training examples each time it runs
-   Results might vary slightly between runs
-   Mimics real neural networks learning patterns from data

### 3. Fuzzy Logic Algorithm

**What it does:**
-   Uses rules instead of strict mathematics
-   Rules like "if most agents agree, trust the average"
-   Handles uncertainty and conflicting information
-   Uses principles from fuzzy set theory
    
**When to use it:**
-   When dealing with subjective estimates
-   When agent reliability varies
-   When some agents might be outliers
-   When you need robust handling of conflicting opinions

**Example Rules:**
-   If average is high AND agreement is strong → result is very high
-   If average is medium AND disagreement is high → result is conservative
-   If opinions are evenly split → result is middle-ground

### 4. Random Forest Algorithm

**What it does:**
-   Creates multiple decision trees
-   Each tree learns how to combine agent values
-   Averages their predictions
-   Like asking several experts independently, then averaging recommendations

**When to use it:**
-   For stable, reliable fusion
-   When you have enough agents (typically 5+)
-   Reduces chance of odd results from unusual patterns
-   Good for production systems where consistency matters

### 5. Consensus Algorithm

**What it does:**
-   First checks how much agents agree
-   If they generally agree (values close together), uses their average
-   If they strongly disagree, becomes more conservative
-   Often chooses middle value in case of strong disagreement
**When to use it:**
-   When group agreement matters more than individual confidence
-   Useful for jury-like decisions
-   Ethical reviews
-   Any situation where consensus building is important
    
**Threshold Behavior:**
-   Built-in agreement threshold (around 20% difference)
-   If agents' values within this range, assumes consensus exists
-   If outside range, assumes disagreement

### Comparing Algorithms:

**Experiment to See Differences:**
1.  Add these values: 0.9, 0.1, 0.9, 0.1, 0.9 
2.  Run each algorithm and record results
3.  Notice how different algorithms handle extreme disagreement

**Expected Results:**
-   **Weighted Average:** Leans toward high values (more "confident" agents)
-   **Fuzzy Logic:** Might give middle-ground result due to high conflict
-   **Consensus:** Could give conservative result due to lack of agreement
    

### Custom Algorithms:

Advanced users can add their own Python scripts.

**Steps:**
1.  Click "Load Script" in Custom Script section
2.  Select your Python file (.py extension)
3.  Click "Add to Algorithms" to include in dropdown menu
4.  Your script now appears alongside built-in algorithms

**Script Requirements:**

-   Must read JSON from standard input
-   Must output JSON with "fused" field
-   Must handle any number of input values
-   Should return results between 0 and 1
## 7. Working with Files

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

