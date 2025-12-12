---
sidebar_position: 5
---

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
    