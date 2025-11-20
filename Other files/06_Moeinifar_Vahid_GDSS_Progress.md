
# Project Progress Report — GDSS Simulator

Vahid Moeinifar

  

---

  

## 1. Overview

The​‍​‌‍​‍‌ GDSS Simulator is a conceptual system that demonstrates the case of how different agents lead to a common group decision. It melds:

  

- Qt Quick (QML) for the visual dashboard

- C++ for backend and main functions logic

- Python or Matlab scripts for AI/ML fusion logic (Currently, I have only a python script, but the software can also have matlab scripts in the future.)

---

  

## 2. Achieved Milestones

  

### 2.1 System Architecture Defined

  

The team has agreed on a hybrid architecture as their final decision:

  

- Frontend: QML - Backend: C++

- AI Engine: Python

- Communication: JSON via QProcess The system is modular and scalable abd due to the model it can be revised many times. ​‍​‌‍​‍‌

  

The​‍​‌‍​‍‌ system is modular and scalable and can be changed numerous times because of the model.

---

  

### 2.2 Working Data Flow Implemented

The entire data pipeline is functional:

1. Values are entered in QML

2. C++ stores and packages the data

3. JSON data type was sent to Python

4. Python performs fusion computation

5. Results are returned to C++

6. UI displays the final fused result (I am correctly working on the UI to make it better)

  

---

  

### 2.3 Python Fusion Logic Working

A Python script now:

- Reads JSON input

- Runs mean/median/weighted fusion

- Returns JSON output

  

This will be expanded later to AI/ML models.

  

---

  

## 3. Challenges Faced

  

### 3.1 C++/QML Integration Complexity

Problems at the beginning of the integration were:

- Undefined identifiers

- Incorrect class declarations

- Wrong object exposure to QML

  

It was fixed with the right includes and interface ​‍​‌‍​‍‌cleanup.

  

---

  

### 3.2 Input Validation Issues

  

- Initially,​‍​‌‍​‍‌ the system permitted non-numeric text to be entered, which caused Python to crash. At present, the system is validating inputs very strictly.

---

  

## 4. Next Steps

  

### 4.1 Add Advanced Fusion Algorithms

Planned:

  

- Weighted neural fusion

  

- Bayesian models

  

- Dempster–Shafer theory

  

- Multi-agent uncertainty ​‍​‌‍​‍‌modeling

  

---

  

### 4.2 Improve UI and Visualization

Planned improvements:

  

- Agent list table

- Real-time plots

- Confidence indicators

- Better error messages

  

---

  

### 4.3 Add Real-World Scenarios

Examples:

  

- Risk assessment

- Emergency management

- Investment decisions

- Medical triage scenarios

  

These​‍​‌‍​‍‌ features will bring the system closer to reality and will also make it available for ​‍​‌‍​‍‌companies.

---

  

### 4.4 Add Data Import/Export (Optional)

Upcoming:

  

- CSV import

- Save/Load session

- Export fusion report

  

---

  

### 4.5 Extend Documentation

To be added:

  

- System diagrams

- Code structure explanation

- Final academic report

- User manual

  

---
## Project Milestones (Status Overview)

| Milestone | Description | Tools | Duration | Status |
|----------|-------------|--------|----------|--------|
| **M1: Research & Design** | Literature review, architecture design | Markdown, diagrams | 4 weeks | ✅ **Done** |
| **M2: Data Model & Agent Simulation** | Define agents, uncertainty models, generate synthetic data | Python | 2 weeks | ✅ **Done** |
| **M3: Fusion Algorithm Implementation** | Weighted avg, Bayesian, AI-based fusion | Python / C++ | 3 weeks | ⚠️ In Progress |
| **M4: Visualization Interface** | Qt Quick dashboard UI | Qt Quick (QML) | 2 weeks | ⚠️ In Progress |
| **M5: Integration & Testing** | Connect modules, test workflows, performance checks | All | 1 week | ⚠️ In Progress |
| **M6: Documentation & Report** | Prepare Markdown report and code documentation | Markdown | 1 week | ⚠️ In Progress |

  
  ---
## 5.  Project Milestones (Architecture Overview)

## Component Status Overview

| Component            | Status        |
|----------------------|---------------|
| Architecture         | ✔️ Done       |
| Python Fusion Engine | ✔️ Working    |
| C++ Backend          | ✔️ Working    |
| UI Prototype         | ⚠️ In Progress |
| Communication        | ✔️ Stable     |
| Documentation        | ⚠️ In Progress |
| AI/ML Fusion         | ⏳ Planned     |
| Scenario Simulation  | ⏳ Planned     |

  ---

  

## 6. Conclusion

Everything​‍​‌‍​‍‌ is going according to plan with the project.

  

At present, the essential structure and multi-language communication have been fixed and are functioning smoothly.

  

It will be the following stage to concentrate on broadening fusion algorithms, UI features, and scenario-based ​‍​‌‍​‍‌simulations.

  

---
