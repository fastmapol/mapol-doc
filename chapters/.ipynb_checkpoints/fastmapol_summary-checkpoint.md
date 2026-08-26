# Algorithm Overview

Before diving into the full document, this chapter provides a high-level overview of the FastMAPOL algorithm, data products, product format, and validation results.

FastMAPOL is a physics-based retrieval algorithm designed to retrieve aerosol, ocean color, and land surface properties from multi-angle polarimetric observations. It combines a coupled vector radiative transfer framework with neural network (NN) forward models and numerical optimization to achieve both physical consistency and computational efficiency.

At a high level, FastMAPOL works through the following steps:

1. **Forward modeling:** A coupled atmosphere-ocean or atmosphere-land vector radiative transfer model describes the measured multi-angle radiance and polarization as functions of aerosol properties, surface properties, and observation geometry.

2. **Neural network acceleration:** NNs trained using rigorous radiative transfer simulations serve as fast forward-model emulators, allowing radiance and polarization to be calculated efficiently during iterative retrievals.

3. **Joint optimization:** Aerosol and surface parameters are retrieved simultaneously by minimizing the differences between the measured and modeled multi-angle reflectance and degree of linear polarization (DoLP).

4. **Adaptive data screening:** Measurements that cannot be adequately represented by the forward model, for example because of cloud contamination or other subpixel heterogeneity, can be identified from the fitting residuals and adaptively excluded from subsequent retrieval iterations.

5. **Uncertainty estimation:** Pixel-level retrieval uncertainties are estimated using the measurement uncertainties, forward-model uncertainties, and Jacobian matrix, with uncertainty correlations considered where applicable.

6. **Surface reflectance retrieval:** Following the aerosol retrieval and atmospheric correction, FastMAPOL derives surface reflectance products, including angular remote sensing reflectance ($R_{rs}$) over ocean and angular surface reflectance over land. Bidirectional reflectance corrections can further be applied to provide standardized surface reflectance products.

The resulting framework uses the information contained in multi-angle measurements to jointly constrain atmospheric and surface properties while maintaining consistency between aerosol retrieval, atmospheric correction, and surface reflectance retrieval.

For more technical details, please refer to the subsequent sections, which describe:

* Vector radiative transfer, including aerosol, ocean, and land surface models
* Neural network (NN) forward model training
* Analytical NN Jacobian calculation using automatic differentiation
* Multi-angle adaptive data screening
* Pixel-level uncertainty estimation
* Treatment of uncertainty correlations
* Angular surface reflectance for ocean and land