---
title: "FastMAPOL Algorithm Theoretical Basis Document"
subtitle: "PACE Multi-Angle Polarimetric Aerosol, Ocean, and Land Retrieval"
author: Meng Gao, Pengwang Zhai, Kamal Aryal, Kirk Knobelspiesse, Bryan Franz
date: "2026"
version: "v2026.8.26"
format:
  html:
    toc: true
  pdf:
    toc: true
---

# Executive Summary

FastMAPOL (Fast Multi-Angle Polarimetric Ocean and Land) is a nonlinear least-squares retrieval algorithm developed for the NASA Plankton, Aerosol, Cloud, ocean Ecosystem (PACE) mission. It retrieves aerosol and surface properties from multi-angle polarimetric observations acquired by the PACE polarimeters, HARP2 and SPEXone.

FastMAPOL combines physics-based vector radiative transfer with neural network (NN) emulators to achieve both retrieval accuracy and computational efficiency, enabling operational-scale processing of PACE polarimetric observations. The algorithm jointly retrieves aerosol and surface properties and provides associated pixel-level uncertainty estimates.

Major features of FastMAPOL include:

- Coupled atmosphere-surface vector radiative transfer using the PACE Simulator
- Cascaded neural network forward-model emulators with analytical Jacobians
- Nonlinear least-squares optimization for joint aerosol and surface retrieval
- Adaptive multi-angle data screening
- Pixel-level retrieval uncertainty estimation
- Treatment of spectral and angular uncertainty correlations
- Atmospheric and bidirectional reflectance correction for angular surface reflectance

FastMAPOL retrieval products include aerosol optical and microphysical properties, aerosol layer height, ocean bio-optical properties, multi-angle remote sensing reflectance over ocean, and surface reflectance properties over land.

This Algorithm Theoretical Basis Document (ATBD) describes the physical basis, radiative transfer models, neural network forward models, inversion methodology, uncertainty characterization, data products, and validation of FastMAPOL for PACE HARP2 and SPEXone observations.

---

# Introduction

The PACE mission includes three primary instruments:

- Ocean Color Instrument (OCI)
- Hyper-Angular Rainbow Polarimeter-2 (HARP2)
- SPEXone polarimeter

Multi-angle polarimetric observations provide enhanced sensitivity to aerosol optical and microphysical properties while improving the separation of atmospheric and surface contributions. FastMAPOL is designed to exploit this information through a coupled atmosphere-surface, physics-based inversion framework accelerated by neural network forward models.

FastMAPOL is applied to PACE HARP2 and SPEXone observations for aerosol retrieval over ocean. Aerosol retrieval over land has also been implemented for HARP2, with the corresponding product available as MAPOL_LAND. The land retrieval follows the same coupled atmosphere-surface radiative transfer framework, with a land surface model replacing the ocean surface and bio-optical models.

---

# Scope of Document

This Algorithm Theoretical Basis Document (ATBD) describes the methodology used by FastMAPOL to retrieve aerosol, ocean, and land surface properties from PACE multi-angle polarimetric measurements.

The document covers the following major components:

- FastMAPOL algorithm architecture and retrieval framework
- Coupled atmosphere-surface vector radiative transfer
- Aerosol optical and microphysical models
- Ocean bio-optical and surface models
- Land surface reflectance model
- Neural network forward-model training and architecture
- Analytical Jacobian calculation using automatic differentiation
- Nonlinear least-squares retrieval methodology
- Adaptive multi-angle data screening
- Pixel-level uncertainty estimation and uncertainty correlations
- Atmospheric and bidirectional reflectance correction
- Level-2 data product definitions and formats
- Validation using PACE HARP2 and SPEXone observations

---

# Document Organization

The remainder of this document is organized into chapters describing the FastMAPOL algorithm, forward models, retrieval methodology, data products, and validation results. A high-level overview is first provided in **FastMAPOL in a Nutshell** for readers who want a concise description of the algorithm and products before proceeding to the detailed technical sections.

---

# Document Information

| Item | Description |
|---|---|
| Document Title | FastMAPOL Algorithm Theoretical Basis Document |
| Version | v2026.8.26 |
| Date | 2026-08-26 |
| Authors | Meng Gao, Pengwang Zhai, Kamal Aryal, Kirk Knobelspiesse, Bryan Franz |
| Institution | NASA Goddard Space Flight Center (GSFC) |
| Project | PACE Mission |

---