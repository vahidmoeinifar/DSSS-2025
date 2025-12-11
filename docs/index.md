### GDSS Simulator Version 1.0

**User Manual and System Documentation**

---

## Table of Contents
1. [Introduction and Purpose](#1-introduction-and-purpose)
2. [System Overview](#2-system-overview)
3. [Installation and Setup](#3-installation-and-setup)
4. [Getting Started](#4-getting-started)
5. [Data Input Methods](#5-data-input-methods)
6. [Fusion Algorithms](#6-fusion-algorithms)
7. [Working with Files](#7-working-with-files)
8. [Advanced Features](#8-advanced-features)
9. [Troubleshooting](#9-troubleshooting)
10. [Technical Reference](#10-technical-reference)
11. [Frequently Asked Questions](#11-frequently-asked-questions)

---

## 1. Introduction and Purpose
The **Group Decision Support System (GDSS) Simulator** provides a platform for testing and comparing different **decision fusion techniques**. When multiple agents or experts provide input on a decision, this software combines their inputs using various mathematical and artificial intelligence methods to produce a single, unified result.

Think of it this way: imagine several people estimating the probability of an event happening. Each person gives a number between 0 and 1, where 0 means "**definitely won't happen**" and 1 means "**definitely will happen**." The GDSS Simulator takes all these estimates and combines them into one final probability using different combination strategies.

This tool serves researchers, students, and professionals who need to understand how different fusion techniques affect group decisions. Whether you're studying decision theory, building consensus systems, or comparing algorithm performance, this simulator provides a practical testing environment.

---

## 2. System Overview

The simulator has three main components working together:

* **Visual Interface:** The user sees and interacts with a window divided into three main areas. On the left side, you input agent values and manage your data list. The center section lets you choose which fusion algorithm to use. The right panel displays results and controls the fusion process.
* **Processing Engine:** Hidden behind the scenes, a **C++ engine** manages all computations. It prepares your data, launches the selected algorithm, and handles communication between different parts of the system. Think of it as the coordinator that makes sure everything works together smoothly.
* **Algorithms:** Five different **Python scripts** implement the actual fusion logic. Each script uses a different mathematical approach to combine the input values. The system can also load additional custom scripts if you want to test your own algorithms.

The software follows a clean workflow: you provide input values, select a fusion method, run the calculation, and examine the results. Everything happens in real time with visual feedback at each step.

---

## 3. Installation and Setup

### System Requirements:

* **Operating System:** Windows 10/11, macOS 10.14+, or modern Linux distribution
* **Memory:** Minimum 4 GB RAM (8 GB recommended)
* **Storage:** 500 MB free space
* **Prerequisites:** **Python 3.7** or newer must be installed separately
* **Required Python packages:** `numpy`, `scikit-learn`

### Installation Steps:

1.  **Extract the Software:** If you received a compressed file (.zip or .tar.gz), extract it to a folder of your choice. Avoid system-protected folders like Program Files unless you have administrative rights.
2.  **Python Installation:**
    * Visit [python.org](https://python.org/) and download the latest Python 3 release
    * During installation, check the option "**Add Python to PATH**"
    * After installation, open a command prompt or terminal
    * Type: `pip install numpy scikit-learn`
    * Wait for the packages to download and install
3.  **Script Setup:** The software comes with five Python scripts in a "**scripts**" folder. These should remain in their original location relative to the main application. If you move them, you'll need to update the script path in the application settings.
4.  **First Launch:** Double-click the **GDSS executable file**. The first launch might take a few moments as the system initializes. If you see security warnings about unknown publishers, you may need to click "**Run anyway**" or adjust your security settings.
5.  **Verification:** Once the main window appears, try adding a few test values (like 0.5, 0.7, 0.3) and clicking "**Run Fusion**." If you see a result appear, the installation is successful.

---

## 4. Getting Started

### Understanding the Interface:

When you first open the GDSS Simulator, you'll notice three distinct colored panels:

* The **left panel (Input Agents)** is where you work with your data. Here you can add individual values, view your current agent list, and clear data when needed. The agent count at the top shows how many values you're currently working with.
* The **center panel (Fusion Algorithm)** controls how your data gets processed. The dropdown menu lets you select from different fusion methods. Below this, you can load custom Python scripts if you've developed your own algorithms.
* The **right panel (Fusion Results)** displays outcomes and controls the fusion process. The large number shows the current fusion result, **color-coded** based on its value. The run button becomes active when you have at least one agent value loaded.

### Quick Start Tutorial:

1.  Start by adding a few test values. In the "**Enter value (0-1)...**" field, type `0.75` and press **Enter** or click **Add**. Do this again with `0.50` and `0.25`.
2.  Notice how these values appear in the agent list below, each with its own remove button. The agent count should now show "**3**."
3.  In the center panel, click the dropdown menu and select "**Weighted Average**." This is a good starting algorithm that's easy to understand.
4.  Move to the right panel and click the "**Run Fusion**" button. You'll see a progress animation followed by a result appearing in large numbers.
5.  The **result color** gives immediate feedback: **green** means high confidence (above 0.7), **yellow** means moderate (0.3-0.7), and **red** means low (below 0.3).
6.  Try changing algorithms and running fusion again with the same values. Notice how different algorithms produce slightly different results from the same inputs.

---

## 5. Data Input Methods

### Method 1: Manual Single Entry

Use this method when you want to add values one at a time, perhaps as they come in from different sources.

1.  Locate the text field labeled "**Enter value (0-1)...**" in the left panel.
2.  Type any number between **0 and 1**. You can use up to three decimal places (like 0.125 or 0.75).
3.  Press the **Enter** key or click the "**Add**" button beside the field.
4.  The value appears in your agent list with a sequential number (Agent 1, Agent 2, etc.).
5.  To remove any value, click the "**×**" button beside it.

> **Tips:** You can quickly enter multiple values by typing a number, pressing Enter, typing the next number, pressing Enter, and so on. The field automatically clears after each addition so you can keep typing without clicking.

### Method 2: Batch Text Input

When you have multiple values from a spreadsheet or text document, this method saves time.

1.  Find the text area labeled "**Enter comma-separated values...**" in the lower part of the left panel.
2.  Type or paste your values separated by **commas**. For example: `0.75, 0.5, 0.25, 0.9, 0.1`
3.  You can also use spaces, tabs, or semicolons as separators.
4.  Click "**Parse & Add**" to process all values at once.
5.  The system validates each value, adds valid ones to your list, and reports any invalid entries.

> **Example formats that work:**
> * `0.1,0.2,0.3,0.4`
> * `0.75 0.50 0.25` (spaces)
> * `0.9;0.8;0.7;0.6` (semicolons)
> * Mixed: `0.1, 0.2 0.3; 0.4`

### Method 3: File Import

For large datasets or when working with saved data files.

1.  Click the "**Open Data**" button in the left panel or use the menu icon (three horizontal lines) in the top right.
2.  Select "**Load Data File**" from the menu.
3.  Navigate to your data file (supports **.txt** and **.csv** formats).
4.  The system reads the file, extracts all valid numbers between 0 and 1, and adds them to your agent list.

 **File Format Guidelines:**
> * Plain text files work best
> * Numbers can be separated by commas, spaces, tabs, or semicolons
> * Each line can contain multiple values
> * Empty lines are ignored
> * Lines starting with `#` are treated as comments and ignored
> * Only numbers between 0 and 1 are processed
> 
#### Sample agent confidence values
``````
0.75, 0.82, 0.91
0.45 0.33 0.67
0.12;0.25;0.38
``````

### Managing Your Data:

**Viewing:**

-   All current agent values display with four decimal precision
-   See at a glance what data you're working with
    
**Removing:**
-   Click × button beside any agent to remove it individually

**Clearing:**
-   "Clear All" button removes every agent value at once
-   Use when starting new experiment or dataset
    
**Counting:**
-   System continuously shows how many agent values loaded
-   Helps ensure working with right dataset size
    

## 6. Fusion Algorithms

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



## 8. Advanced Features

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
    

## 9. Troubleshooting

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
    

## 10. Technical Reference

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
    

## 11. Frequently Asked Questions

**Q: What exactly does "fusion" mean in this context?**  
A: Fusion refers to mathematical combination of multiple inputs into single output. In decision support, means taking several people's estimates or opinions and creating one unified estimate considering all inputs.

**Q: Why would I use different algorithms?**  
A: Different situations call for different approaches:

-   Simple, explainable results: Weighted Average
    
-   Complex patterns or historical data: Neural Network
    
-   Uncertainty and disagreement: Fuzzy Logic
    
-   Match method to specific needs
    

**Q: Can I use this for real decision making?**  
A: Simulator designed for testing, education, and research. While algorithms mathematically sound, real-world decisions should consider additional factors beyond numerical fusion. Use as tool to inform decisions, not as sole decision maker.

**Q: How many agent values can I process?**  
A: System handles dozens to hundreds of values comfortably. Extremely large datasets (thousands of values) might slow down some algorithms. No hard limit, but practical performance depends on computer's memory.

**Q: Are the results reproducible?**  
A: Most algorithms give identical results with identical inputs. Neural Network algorithm includes random elements in training, so results might vary slightly between runs with same data. For completely reproducible results, use deterministic algorithms.

**Q: Can I add my own algorithms?**  
A: Yes, through custom script feature. Need basic Python programming knowledge. Follow template provided in Section 8, algorithm integrates seamlessly with system.

**Q: What if my data has values outside 0-1?**  
A: System ignores values outside this range during loading. If need to work with different ranges (like 0-100 or 1-10), need to scale data before loading.

**Q: Is there a way to save my complete session?**  
A: Not in current version. Save source data files and record results manually. Future versions may include session saving capabilities.

**Q: Why do I need Python installed separately?**  
A: System executes Python scripts as external processes for security and flexibility. Allows algorithm developers to use any Python libraries needed without affecting main application's stability.

**Q: Can I run this on a network or with multiple users?**  
A: Current version designed for single-user, desktop use. Network or multi-user capabilities would require significant architectural changes.

**Q: How accurate are the algorithms compared to academic literature?**  
A: Implementations follow standard approaches from decision theory and machine learning literature. Simplified for educational purposes but maintain mathematical correctness. For research purposes, might need more sophisticated implementations.

**Q: What's the difference between "confidence" and "probability" in this context?**  
A: System treats all inputs as confidence values between 0 and 1. Can interpret as probabilities, confidence scores, agreement levels, or any normalized measure. Algorithms work same regardless of interpretation.

**Q: Can I modify the built-in algorithms?**  
A: Yes, Python scripts in "scripts" folder. Can edit with any text editor. Make backups before modifying, and be aware updates might overwrite changes.

### Getting Help:

If encounter issues not covered:

1.  Check error messages displayed in application
    
2.  Verify Python installation and dependencies
    
3.  Ensure data files contain properly formatted values
    
4.  Try Weighted Average algorithm as baseline test
    

**For persistent problems, document:**

-   Exact error message
    
-   Operating system and version
    
-   Python version (from command: `python --version`)
    
-   Steps to reproduce issue
    

----------

**Version History:**

-   1.0 (Current): Initial release with five fusion algorithms, file loading, and custom script support
    

**Acknowledgments:**  
This software demonstrates principles from decision theory, consensus building, and machine learning. Designed for educational and research purposes to help users understand how different fusion techniques affect group decisions.

**Contact:**  
For questions about software or suggestions for improvement, refer to documentation provided with distribution.

----------

_This documentation covers GDSS Simulator Version 1.0. Features and capabilities may change in future versions. Always refer to documentation specific to your version._

----------

## Download Instructions

To save this documentation as an MD file:

1.  **Copy the entire content** of this document
    
2.  **Open a text editor** (Notepad++, VS Code, or any plain text editor)
    
3.  **Paste the content** into a new file
    
4.  **Save the file** with extension `.md` (e.g., `GDSS_Manual.md`)
    
5.  **Use with markdown viewers** or convert to PDF/HTML if needed
    

For best formatting:

-   Use a markdown viewer like Typora, MarkText, or VS Code with markdown preview
    
-   For PDF conversion, use Pandoc or online markdown to PDF converters
    
-   For printing, convert to PDF first for proper page formatting
    

**File Information:**

-   **Filename:** GDSS_Simulator_Manual.md
    
-   **Last Updated:** Version 1.0 Documentation
    
-   **Pages:** Approximately 15-20 pages when converted to PDF
    
-   **File Size:** ~25KB as plain text
- ----------

**Quick Reference Card (Printable):**

**Basic Workflow:**

1.  Input → 2. Select Algorithm → 3. Run → 4. Analyze Result
    

**Input Methods:**

-   Manual: Type value, press Enter
    
-   Batch: Paste comma-separated values, click Parse
    
-   File: Click Open Data, select file
    

**Algorithms:**

1.  Weighted Average - Simple weighted mean
    
2.  Neural Network - AI pattern recognition
    
3.  Fuzzy Logic - Rule-based uncertainty handling
    
4.  Random Forest - Ensemble learning
    
5.  Consensus - Agreement-focused
    

**Result Colors:**

-   Green (0.7-1.0): High confidence
    
-   Yellow (0.3-0.7): Moderate confidence
    
-   Red (0-0.3): Low confidence
    

**Shortcuts:**

-   Enter: Add value
    
-   Ctrl+Enter: Parse batch
    
-   Ctrl+O: Open file
    

----------

_End of Documentation_

----------

Developrd by **Vahid Moeinifar**
vmoeinifar@agh.edu.pl

