# Technical Details

This section provides detailed mathematical formulations, derivations, and supporting information for the FastMAPOL algorithm. The material presented here complements the main chapters and is intended for readers who require a deeper understanding of the underlying theory, assumptions, and implementation details.

The appendices include:
- Details in radiative transfer model
- Details in the NN and automatic differentation
- Detailed formulations of aerosol size distributions and their moments  
<!-- - Derivations of lidar-related quantities, including lidar ratio and depolarization  -->
<!-- - Inversion methods connecting bulk aerosol properties to submode representations  -->
<!-- - Treatment of aerosol mixing and component partitioning  
- Pixel-level and correlated uncertainty analysis   -->
- Surface reflectance models for ocean and land
- Multi-angle atmospheric correction

These technical details are not required for general use or interpretation of the FastMAPOL products but are essential for algorithm development, validation, and advanced scientific analysis.

All equations and formulations follow the conventions introduced in the main text unless otherwise noted.

Each chapter provides an **implementation status** indicating where the described methodology has been applied or its current stage of development. The status categories include the pre-launch **Day-In-The-Life (DITL)** test, with data available through OB.DAAC; the operational **PACE V3** and **PACE V4** products, available through the Earthdata Cloud; methodologies currently under **Evaluation**; and **Planned** future developments.

For example:

**Implementation status**

| DITL | PACE V3 | PACE V4 | Evaluation | Planned |
|:---:|:---:|:---:|:---:|:---:|
| ✓ | ✓ | ✓ | — | — |