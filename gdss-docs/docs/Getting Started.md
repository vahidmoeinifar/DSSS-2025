---
sidebar_position: 4
---

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