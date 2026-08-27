# FastMAPOL at a Glance

FastMAPOL (Fast Multi-Angle Polarimetric Ocean and Land) is a nonlinear least-squares retrieval algorithm developed for the NASA Plankton, Aerosol, Cloud, ocean Ecosystem (PACE) mission. It retrieves aerosol, ocean, and land surface properties from multi-angle polarimetric observations acquired by the PACE polarimeters, HARP2 and SPEXone.

FastMAPOL combines physics-based vector radiative transfer with neural network (NN) emulators and numerical optimization to achieve both physical consistency and computational efficiency, enabling operational-scale processing of PACE polarimetric observations. The algorithm jointly retrieves aerosol and surface properties and provides associated pixel-level uncertainty estimates.

This chapter provides a high-level overview of the FastMAPOL algorithm, retrieval products, product format, and validation. Detailed descriptions of the theoretical basis and individual algorithm components are provided in subsequent chapters and technical sections.

## Algorithm Overview

At a high level, FastMAPOL operates through the following steps:

1. **Forward modeling:** Coupled atmosphere-ocean and atmosphere-land vector radiative transfer models describe the measured multi-angle radiance and polarization as functions of aerosol properties, surface properties, and observation geometry.

2. **Neural network acceleration:** NNs trained using rigorous radiative transfer simulations serve as fast forward-model emulators, enabling efficient calculations of radiance and polarization during iterative retrievals.

3. **Joint optimization:** Aerosol and surface parameters are retrieved simultaneously by minimizing the differences between measured and modeled multi-angle reflectance and degree of linear polarization (DoLP).

4. **Adaptive data screening:** Measurements that cannot be adequately represented by the forward model, for example because of cloud contamination or subpixel heterogeneity, are identified from fitting residuals and can be adaptively excluded from subsequent retrieval iterations.

5. **Uncertainty estimation:** Pixel-level retrieval uncertainties are estimated using measurement and forward-model uncertainties together with the Jacobian matrix. Spectral and angular uncertainty correlations can also be incorporated into the retrieval framework.

6. **Surface reflectance retrieval:** Following aerosol retrieval and atmospheric correction, FastMAPOL derives surface reflectance products, including angular remote sensing reflectance over ocean ($R_{rs}$) and angular surface reflectance over land ($\rho_s$). Bidirectional reflectance corrections can further be applied to provide standardized surface reflectance products.

The resulting framework exploits the information contained in multi-angle polarimetric measurements to jointly constrain atmospheric and surface properties while maintaining consistency among aerosol retrieval, atmospheric correction, and surface reflectance retrieval.

## Major Algorithm Features

The major features of FastMAPOL include:

- Coupled atmosphere-surface vector radiative transfer using the PACE Simulator
- Cascaded neural network forward-model emulators
- Analytical Jacobian calculations using automatic differentiation
- Nonlinear least-squares optimization for joint aerosol and surface retrieval
- Adaptive multi-angle data screening
- Pixel-level retrieval uncertainty estimation
- Treatment of spectral and angular uncertainty correlations
- Atmospheric and bidirectional reflectance correction for angular surface reflectance

## Retrieval Products

FastMAPOL retrieval products include aerosol optical and microphysical properties, aerosol layer height, ocean bio-optical properties, multi-angle remote sensing reflectance over ocean, and surface reflectance properties over land. The products also include associated retrieval diagnostics and pixel-level uncertainty estimates.

## Technical Details

This Algorithm Theoretical Basis Document (ATBD) describes the physical basis, radiative transfer models, neural network forward models, inversion methodology, uncertainty characterization, data products, and validation of FastMAPOL for PACE HARP2 and SPEXone observations.

Appendix provide detailed technical descriptions of:

- Vector radiative transfer, including aerosol, ocean, and land surface models
- Neural network forward-model training
- Analytical NN Jacobian calculation using automatic differentiation
- Multi-angle adaptive data screening
- Pixel-level uncertainty estimation
- Treatment of uncertainty correlations
- Atmospheric and bidirectional reflectance correction
- Angular surface reflectance over ocean and land