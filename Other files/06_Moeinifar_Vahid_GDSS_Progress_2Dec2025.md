
  

### Project Progress Report — GDSS Simulator

  

Name and surname: **Vahid Moeinifar**
Project title: **Group Decision Support System Simulator Based on Information Fusion and AI Methods**
Project number: **06**
Date of report: **December 2, 2025**

---

## 1. Overall Progress

### **What has already been completed**
- Implemented the core UI with QML, including:
  - Two separate numerical input fields  
  - Application menu (Help, About, ... )  
  - An About page
  - Integrated custom fonts and icons for a more polished interface
- Completed the QML ↔ C++ ↔ Python pipeline:
  - Fixed unstable stdout handling  
  - Ensured Python returns clean, valid JSON  
  - Added robust error handling and message propagation through QML
- Updated the Python fusion script:
  - Cleaned structure  


### **What remains to be done**
- Add more DSS algorithms (multi-model fusion, voting, confidence weighting)__ These may change in future.
- Final design polish and performance testing
- Importing data from CSV files or Text files

---

## 2. Activities & Achievements (Last Week)

- Fixed repeated QML error: *“Python returned invalid JSON”*
- Rebuilt the communication flow so QML only parses complete JSON lines
- Introduced proper buffering in C++ to eliminate race conditions
- Added a second value input field based on improved system design
- Implemented About page, menu bar, and UI re-organization
- Integrated custom fonts and icons to stabilize the UI style
- Successfully ran the updated fusion script with verified output:
  - Example: `{"fused": 1.24...}`  
- Ensured correct propagation of fused values back into QML bindings
---
## 3. Problems

### **1. Python output arriving in fragments (Solved)**
- **Cause:** QProcess reading stdout before Python finished writing  
- **Fix:** Buffering logic + flush + single-line JSON

### **2. Missing Python modules (Solved)**
- `sklearn` missing → installed via pip  
- Re-tested script after installation

### **3. QML signal deprecated parameter injection (Solved)**
- Updated handlers to JavaScript functions with explicit parameters

### **4. Occasional “no output” messages (Resolved)**
- Caused by newline-only output; fixed after enforcing clean JSON printing

---

## 4. Additional Notes

- The app has reached a stable stage where new DSS algorithms can be added safely.  
- UI structure is now future-proof; additional pages or charts can be added without major restructuring.  
- Communication logic is now robust enough for real-time sensor fusion if required later.
- More than 800 line code added to project

**All of the progress is trackable on  [GitHub](https://github.com/vahidmoeinifar/DSSS-2025/tree/main)**

---
## 4. Some Screenshots of project
![GitHub Logo](https://github.com/vahidmoeinifar/DSSS-2025/blob/main/screenshots/1.png?raw=true)

![GitHub Logo](https://github.com/vahidmoeinifar/DSSS-2025/blob/main/screenshots/2.png?raw=true)

![GitHub Logo](https://github.com/vahidmoeinifar/DSSS-2025/blob/main/screenshots/3.png?raw=true)


## Project Milestones (Status Overview)

  | Milestone | Description | Tools | Duration | Status |

|----------|-------------|--------|----------|--------|

| **M1: Research & Design** | Literature review, architecture design | Markdown, diagrams | 4 weeks | ✅ **Done** |

| **M2: Data Model & Agent Simulation** | Define agents, uncertainty models, generate synthetic data | Python | 2 weeks | ✅ **Done** |

| **M3: Fusion Algorithm Implementation** | Weighted avg, Bayesian, AI-based fusion | Python / C++ | 3 weeks | ✅ **Done** |

| **M4: Visualization Interface** | Qt Quick dashboard UI | Qt Quick (QML) | 2 weeks | ⚠️ In Progress |

| **M5: Integration & Testing** | Connect modules, test workflows, performance checks | All | 1 week | ✅ **Done** |

| **M6: Documentation & Report** | Prepare Markdown report and code documentation | Markdown | 1 week | ⚠️ In Progress |
 
---
## 5. Project Milestones (Architecture Overview)
  
## Component Status Overview

  
| Component | Status |

|----------------------|---------------|

| Architecture | ✔️ Done |

| Python Fusion Engine | ✔️ Working |

| C++ Backend | ✔️ Working |

| UI Prototype | ✔️ Working |

| Communication | ✔️ Stable |

| Documentation | ⚠️ In Progress |

| AI/ML Fusion | ⏳ Planned |

| Scenario Simulation | ⏳ Planned |
 



