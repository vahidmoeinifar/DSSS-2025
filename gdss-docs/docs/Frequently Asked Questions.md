---
sidebar_position: 11
---

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

