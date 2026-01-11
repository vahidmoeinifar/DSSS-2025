
  

  

### Project Progress Report — GDSS Simulator - Final Report

  

  

Name and surname: **Vahid Moeinifar**

Project title: **Group Decision Support System Simulator Based on Information Fusion and AI Methods**

Project number: **06**

Date of report: **Janruary 13, 2026**

  

---

  

## 1. Overall Progress

  

###  **What has already been completed**

-  **Multi-algorithm fusion framework supporting five distinct decision fusion methods:** neural network, weighted average, fuzzy logic, random forest, and consensus-based approaches

  

-  **Interactive user interface** with dual input methods (manual entry and batch CSV-style input), real-time validation, and visual feedback

  

-  **Algorithm comparison system** enabling side-by-side evaluation of different fusion methods with execution time tracking and statistical analysis

  

-  **Robust error handling** with graceful degradation, comprehensive input validation, and user-friendly error reporting

  

-  **Export functionality** for saving comparison results to CSV format with proper file system integration

  

-  **Real-time progress tracking** with visual indicators during algorithm execution

  

-  **Cross-language communication** using JSON serialization between C++, Python, and QML components

  

-  **Comprehensive documentation** including architectural diagrams, and user interface guidelines

  
  

###  **What remains to be done**

- All core functionalities have been implemented and tested. The project has reached production-ready status with stable operation across all components.

  
  
  

---

  

## 2. Problems

  

### 1. Cross-Language Communication Challenges

**Problem:** Ensuring reliable data exchange between C++ (Qt), Python, and QML (JavaScript) with proper type conversion and error handling.

**Solution:** Implemented JSON-based serialization with strict schema validation. Created standardized interface contracts and added comprehensive error reporting through Qt's signal-slot mechanism.

  

### 2. Real-time Progress Tracking Complexity

**Problem:** Maintaining accurate progress indicators during variable-length Python script executions while keeping the UI responsive.

**Solution:** Implemented Qt's QProcess with separate threads, added progress tracking variables (m_comparisonProgressCurrent, m_comparisonProgressTotal), and used Qt's animation framework for smooth UI updates.

  

### 3. File System Integration Issues

**Problem:** Platform-dependent file path handling and permission errors during CSV export operations.

**Solution:** Implemented URL-to-path conversion with platform detection, added directory creation for non-existent paths, and integrated Qt's StandardPaths for appropriate default locations.

  

### 4. Algorithm Comparison Consistency

**Problem:** Ensuring fair comparison across different algorithm types with varying execution times and failure modes.

**Solution:** Created standardized execution environments, implemented timeout mechanisms, added fallback values for failed computations, and developed statistical normalization for result comparison.

  

### 5. Memory Management and Resource Leaks

**Problem:** Proper cleanup of Python processes and memory allocation during repeated comparison operations.

**Solution:** Implemented RAII principles in C++ classes, added process termination in destructors, and created proper cleanup routines in the comparison completion handlers.

  ...
## 3. Additional Notes

### Academic Value:

Beyond its functional implementation, the project serves as an excellent case study in cross-language system integration, algorithm comparison methodologies, and user-centric interface design for complex computational systems.
### Research Applications:

The framework can be extended for psychological studies on group decision-making, cultural bias analysis in consensus formation, or comparative studies of AI-assisted decision support methodologies.

  

**All of the progress is trackable on [GitHub](https://github.com/vahidmoeinifar/DSSS-2025/tree/main)**

  

---

## 4. Some Screenshots of Compare part
After UI polish

![GitHub Logo](https://github.com/vahidmoeinifar/DSSS-2025/blob/main/screenshots/1.png?raw=true)

  ![GitHub Logo](https://github.com/vahidmoeinifar/DSSS-2025/blob/main/screenshots/2.png?raw=true)
  
  

## Project Milestones (Status Overview)

  
___
| Milestone | Description | Tools | Duration | Status |
|----------|-------------|--------|----------|--------|
| **M1: Research & Design** | Literature review, architecture design | Markdown, diagrams | 4 weeks | ✅ **Done** |
| **M2: Data Model & Agent Simulation** | Define agents, uncertainty models, generate synthetic data | Python | 2 weeks | ✅ **Done** |
| **M3: Fusion Algorithm Implementation** | Weighted avg, Bayesian, AI-based fusion | Python / C++ | 3 weeks | ✅ **Done** |
| **M4: Visualization Interface** | Qt Quick dashboard UI | Qt Quick (QML) | 2 weeks | ✅ **Done** |
| **M5: Integration & Testing** | Connect modules, test workflows, performance checks | All | 1 week | ✅ **Done** |
| **M6: Documentation & Report** | Prepare Markdown report and code documentation | Markdown | 1 week | ✅ **Done** | a pure docusaruse ithibpage created for this!
___


## 5. Project Milestones (Architecture Overview)

## Component Status Overview

  
| Component | Status |
|----------------------|---------------|
| Architecture | ✔️ Done |
| Python Fusion Engine | ✔️ Working |
| C++ Backend | ✔️ Working |
| UI Prototype | ✔️ Working |
| Communication | ✔️ Stable |
| Documentation | ✔️ Stable |
  | AI/ML Fusion | ✔️ Stable |
| Scenario Simulation |🔄 Optional (Base structure supports future simulation extensions)|

✅**Note:** Scenario simulation capabilities can be implemented as an extension using the existing architectural foundation, allowing for simulated decision-making scenarios with configurable agent behaviors and environmental factors.

## 6. Acknowledgments

This project represents a comprehensive implementation of theoretical decision support concepts into a practical, usable software system. The successful integration of multiple programming languages, algorithmic approaches, and user interface paradigms demonstrates the viability of cross-disciplinary approaches to complex software engineering challenges. The system stands ready for both academic research applications and practical decision support scenarios.



__END_