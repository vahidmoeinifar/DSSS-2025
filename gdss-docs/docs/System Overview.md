---
sidebar_position: 2
---

The simulator has three main components working together:

* **Visual Interface:** The user sees and interacts with a window divided into three main areas. On the left side, you input agent values and manage your data list. The center section lets you choose which fusion algorithm to use. The right panel displays results and controls the fusion process.
* **Processing Engine:** Hidden behind the scenes, a **C++ engine** manages all computations. It prepares your data, launches the selected algorithm, and handles communication between different parts of the system. Think of it as the coordinator that makes sure everything works together smoothly.
* **Algorithms:** Five different **Python scripts** implement the actual fusion logic. Each script uses a different mathematical approach to combine the input values. The system can also load additional custom scripts if you want to test your own algorithms.

The software follows a clean workflow: you provide input values, select a fusion method, run the calculation, and examine the results. Everything happens in real time with visual feedback at each step.
