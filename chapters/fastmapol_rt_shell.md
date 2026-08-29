# Radiative Transfer Model: Spherical shell correction {#sec-rt-shell}

As discussed in @sec-rt-model, theforward model are generated using a PACE-tailored vector radiative transfer model based on the successive orders of scattering method [@Zhai:2022bb]. An improved pseudo-spherical shell (IPSS) correction is applied to improve simulation fidelity at large solar and viewing zenith angles [@Zhai:2022aa].

Reflectance and degree of linear polarization (DoLP) are simulated at the PACE satellite altitude of approximately 676 km above Earth's surface. The solar and viewing geometries are defined at the Earth's surface following PACE L1C format definition (all geometries in the L1C file follllows the same convention), as illustrated in @fig-system, using the geometric transformations derived in @Zhai:2022aa.

![Spherical-shell geometry of the Earth–atmosphere system. Radiative transfer simulations are performed for the geometry defined at the satellite by the solar and viewing zenith angles $\theta'_0$ and $\theta'_v$, respectively. These angles are transformed to the corresponding geometry at the Earth's surface, with solar and viewing zenith angles $\theta_0$ and $\theta_v$. Solar and viewing azimuth angles also depend on the reference frame but are not shown.](figure/fig_rt_shell.png){#fig-system width=10cm}



