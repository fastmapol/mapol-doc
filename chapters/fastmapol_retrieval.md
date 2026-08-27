# FastMAPOL Retrieval Framework

FastMAPOL is an efficient coupled aerosol and ocean color retrieval algorithm that combines neural network (NN) forward models with iterative optimization [@Gao:2021aa; @Gao:2021bb, @Gao:2023aa]. The NN forward models emulate vector radiative transfer calculations for a coupled atmosphere-ocean system based on the PACE simulator [@Zhai:2009aa; @Zhai:2010aa; @Zhai:2022aa]. Please find more details in the NN, automatic differentiaton and aerosol and surface model details in the technical section. 

## Radiative transfer parameterization

The radiative transfer (RT) model used in this work is the PACE simulator [@Zhai:2022aa], which solves the polarized radiance field in a coupled atmosphere-ocean system with flexible solar and viewing geometries, aerosol microphysical properties, and ocean bio-optical models [@Gao:2018aa]. The RT model is used to generate the training datasets for the neural network forward models [@Gao:2021aa; @Gao:2023aa].

The forward radiative transfer simulations use atmospheric molecular vertical distributions from the U.S. Standard Atmosphere profile [@Anderson:1986aa], scaled by surface pressure. Absorption by oxygen, water vapor, methane, carbon dioxide, ozone, and nitrogen dioxide is accounted for using line-by-line calculations and the double-k distribution method [@Duan:2005aa; @Zhai:2022aa]. Surface pressure $P_s$ and ozone column density $n_{\mathrm{O}_3}$ are considered as input parameters, with values obtained from the MERRA-2 reanalysis [@Gelaro:2017aa].

More details are provided in @sec-rt-model.

**Aerosol model**

Aerosols are represented by a multi-modal framework that allows independent characterization of fine- and coarse-mode size distributions, each with its own complex refractive index defined by real ($m_r$) and imaginary ($m_i$) components, assuming flat spectral dependence. The fine mode is represented by three submodes, while the coarse mode is represented by two submodes. Each submode is described by a log-normal size distribution with mean radii of 0.1, 0.1732, 0.3, 1.0, and 2.9 $\mu\mathrm{m}$ and geometric standard deviations of 0.35, 0.35, 0.35, 0.5, and 0.5, respectively, consistent with @Dubovik:2006aa and @Xu:2016aa. The volume density of each submode is denoted by $V_i$.

Both fine and coarse modes allow mixtures of spherical and spheroidal particles to account for particle non-sphericity [@Dubovik:2006aa]. The corresponding spherical fractions are represented by $\mathrm{sph}_f$ and $\mathrm{sph}_c$. The aerosol vertical distribution is parameterized by the aerosol layer height ($z_c$), defined as the center of a Gaussian vertical profile describing aerosol number density.

More details are provided in @sec-aerosol-model.

**Ocean model**

Ocean bio-optical properties, including contributions from pure seawater, phytoplankton, and colored dissolved organic matter (CDOM), are parameterized using chlorophyll-a concentration (Chl-a). The scattering phase functions of phytoplankton are represented by the Fournier-Forand (FF) phase function [@Fournier:1994aa], which is mixed with the pure seawater phase function to describe total scattering in seawater. The Mueller matrix is represented by the product of the mixed phase function and the average normalized Mueller matrix measured by @Voss:1984aa and parameterized by @Kokhanovsky:2003aa.

Ocean surface roughness is described using the Cox-Munk model, parameterized by surface wind speed ($w_s$). The whitecap fraction is parameterized in terms of wind speed, with whitecap reflectance based on @Koepke:1984aa.

The current bio-optical model is best suited for waters optically dominated by phytoplankton and performs well over most global ocean waters [@Gao:2026aa], but it faces challenges in accurately representing optically complex coastal waters, particularly those influenced by non-algal particles and strong CDOM absorption. Ongoing development of more advanced bio-optical models capable of representing complex water types will enable more realistic retrievals in coastal waters, particularly in regions influenced by both complex aerosol properties and bright ocean constituents [@Gao:2018aa; @Aryal:2024aa, @Aryal:2026aa].

More details are provided in @sec-ocean-model.

**Land Model**

We use the land surface reflectance model implemented in the **PACE simulator**, with key components:
- Ross–Li kernel-driven BRDF  
- Polarized bidirectional reflectance distribution function (BPDF)  
- Fresnel reflection physics

Details are provided in @sec-land-model.

**Parameter range**

The forward-model parameters and their ranges are summarized in @tbl-param-ranges using coupled atmosphere-ocean system as example. Solar and viewing geometries are specified by the solar zenith angle ($\theta_0$), viewing zenith angle ($\theta_v$), and relative azimuth angle ($\phi_v$), which are obtained from PACE Level-1C data. Surface pressure and ozone are obtained from ancillary data, while the aerosol, ocean, and surface parameters are retrieved by FastMAPOL.

| **Parameter** | **Unit** | **Min** | **Max** |
|---|---:|---:|---:|
| $\theta_0$ | $^\circ$ | 0 | 80 |
| $\theta_v$ | $^\circ$ | 0 | 80 |
| $\phi_v$ | $^\circ$ | 0 | 180 |
| $n_{\mathrm{O}_3}$ | Dobson | 150 | 450 |
| $P_s$ | mb | 950 | 1050 |
| $m_{r,f}$ | -- | 1.33 | 1.55 |
| $m_{r,c}$ | -- | 1.33 | 1.55 |
| $m_{i,f}$ | -- | 0 | 0.03 |
| $m_{i,c}$ | -- | 0 | 0.001 |
| $V_1$ | $\mu\mathrm{m}^3\,\mu\mathrm{m}^{-2}$ | 0 | 0.14 |
| $V_2$ | $\mu\mathrm{m}^3\,\mu\mathrm{m}^{-2}$ | 0 | 0.11 |
| $V_3$ | $\mu\mathrm{m}^3\,\mu\mathrm{m}^{-2}$ | 0 | 0.07 |
| $V_4$ | $\mu\mathrm{m}^3\,\mu\mathrm{m}^{-2}$ | 0 | 0.20 |
| $V_5$ | $\mu\mathrm{m}^3\,\mu\mathrm{m}^{-2}$ | 0 | 0.62 |
| $\mathrm{sph}_f$ | -- | 0 | 1 |
| $\mathrm{sph}_c$ | -- | 0 | 1 |
| $z_c$ | km | 0.1 | 6.0 |
| $w_s$ | $\mathrm{m}\,\mathrm{s}^{-1}$ | 0.5 | 15 |
| Chl-a | $\mathrm{mg}\,\mathrm{m}^{-3}$ | 0.01 | 10 |

: Parameters and ranges used in the neural network forward model. The minimum and maximum values define the bounds used to sample the NN training dataset and serve as constraints in the retrieval algorithm. {#tbl-param-ranges}

Note that aerosol retrieval over land has also been implemented for HARP2, with the corresponding product available as MAPOL_LAND. The retrieval follows the same coupled atmosphere-surface radiative transfer framework. Additional technical details are provided in later sections.

## Neural network forward models

Neural network models are employed to represent TOA reflectance ($\rho_t$) and degree of linear polarization (DoLP) with two levels of accuracy. A smaller, computationally efficient neural network is used to generate an initial first guess, while a larger and more accurate neural network is applied in subsequent refinement steps of the retrieval. This two-stage strategy balances computational efficiency with retrieval accuracy [@Gao:2023aa].

In addition to the TOA forward models, separate neural network models are developed to support atmospheric correction. These include NNs trained to represent atmospheric and surface path reflectance ($\rho_{\mathrm{atm+surface}}$), total transmittance ($1/(T_d t_u)$), and a combined transmittance and BRDF correction term ($C_{\mathrm{BRDF}}/(T_d t_u)$). These components enable efficient decomposition of the TOA signal and facilitate the retrieval of water-leaving reflectance.

Additional neural network models are trained to compute AOD and SSA for both fine and coarse modes, allowing consistent treatment of aerosol optical and microphysical properties within the coupled retrieval framework. All NN models, architectures, and associated uncertainties are summarized in @tbl-nn-arch.

| **Quantity** | **Neural network architecture** | **Uncertainty** |
|---|---|---:|
| $\rho_t$ | $19\times256\times256\times256\times34$ | 0.5% |
| $\rho_t$ (first guess) | $19\times128\times128\times128\times34$ | 0.6% |
| $\rho_{\mathrm{atm+surface}}$ | $18\times256\times256\times256\times34$ | 0.5% |
| DoLP | $19\times512\times512\times512\times34$ | 0.0007 |
| DoLP (first guess) | $19\times256\times256\times256\times34$ | 0.0012 |
| $C_{\mathrm{BRDF}}/(T_d t_u)$ | $19\times256\times256\times34$ | 0.006 |
| $1/(T_d t_u)$ | $19\times256\times256\times34$ | 0.005 |
| AOD (fine) | $6\times64\times64\times34$ | 0.003 |
| AOD (coarse) | $5\times64\times64\times34$ | 0.001 |
| SSA (fine) | $6\times64\times64\times34$ | 0.003 |
| SSA (coarse) | $5\times64\times64\times34$ | 0.01 |

: Neural network architectures and associated uncertainties used in FastMAPOL for SPEXone (34 spectral bands). For HARP2 the output bands are 4 with similar structures [@Gao:2023aa]. {#tbl-nn-arch}

More details are provided in @sec-nn-model.

## Retrieval and optimization

FastMAPOL determines the optimal values of the state parameters by minimizing the difference between the measurements and NN forward model predictions. An iterative optimization approach is used. The NN forward model computes the reflectance and degree of linear polarization (DoLP), defined as

$$
\rho_t
=
\frac{\pi L_t}{\mu_0 F_0}
$$ {#eq-rho}

and

$$
P_t
=
\frac{\sqrt{Q_t^2+U_t^2}}{L_t},
$$ {#eq-DoLP}

where $L_t$, $Q_t$, and $U_t$ are the Stokes parameters at the sensor altitude, $F_0$ is the extraterrestrial solar irradiance, and $\mu_0$ is the cosine of the solar zenith angle.

The differences between the measurements and model predictions are represented by a cost function, $\chi^2$, based on Bayesian theory [@Rodgers:2000aa]:

$$
\chi^2({\mathbf x})
=
\frac{1}{N}
\sum_i
\left(
\frac{[\rho_t(i)-\rho_t^f({\mathbf x};i)]^2}{\sigma_\rho^2(i)}
+
\frac{[P_t(i)-P_t^f({\mathbf x};i)]^2}{\sigma_P^2(i)}
\right).
$$ {#eq-cost}

Here, $\rho_t^f$ and $P_t^f$ are the reflectance and DoLP computed by the NN forward model. The state vector ${\mathbf x}$ contains the retrieved aerosol, ocean, and surface parameters described in @tbl-param-ranges. The subscript $i$ denotes the measurement index, where one measurement is defined as a pair of reflectance and DoLP values at a given viewing angle and wavelength, and $N$ is the total number of measurements used in the retrieval.

The total uncertainties of reflectance and DoLP used in the cost function are denoted by $\sigma_\rho$ and $\sigma_P$, respectively. These include contributions from instrument uncertainties $\sigma_{\mathrm{ins}}$, NN forward model uncertainties $\sigma_{\mathrm{NN}}$, and radiative transfer simulation uncertainties $\sigma_{\mathrm{RT}}$ used to train the NN:

$$
\sigma_\rho^2
=
\sigma_{\rho,\mathrm{ins}}^2
+
\sigma_{\rho,\mathrm{NN}}^2
+
\sigma_{\rho,\mathrm{RT}}^2,
$$ {#eq-sigma-rho}

$$
\sigma_P^2
=
\sigma_{P,\mathrm{ins}}^2
+
\sigma_{P,\mathrm{NN}}^2
+
\sigma_{P,\mathrm{RT}}^2.
$$ {#eq-sigma-P}

The NN forward-model uncertainties are determined during NN training and evaluation [@Gao:2021aa; @Gao:2023aa], with the current NN architectures and associated uncertainties summarized in @tbl-nn-arch. At present, uncertainties are assumed to be spectrally and angularly uncorrelated.

During FastMAPOL retrievals, with each iteration, the state vector ${\mathbf x}$ is updated, and the NN forward model is used to compute $\rho_t^f$ and $P_t^f$, from which a new value of the cost function is calculated. The Jacobian matrix is used to determine the magnitude and direction of the update to ${\mathbf x}$. The NN forward model and analytical calculation of the Jacobian matrix through automatic differentiation are described in the following section.

This iterative process continues until the convergence criterion is met:

$$
\frac{|\chi_i^2-\chi_{i-1}^2|}
{\chi_i^2}
<
\eta,
$$ {#eq-delta-chi}

where $i$ is the iteration index and $\eta$ is the convergence tolerance, taken as 0.01.

The convergence and overall quality of the retrieval can be evaluated using the cost function. For an ensemble of retrievals, if the residuals are consistent with the assumed uncertainties, the normalized cost-function distribution can be compared with the theoretical probability density function (PDF) of the $\chi^2$ distribution:

$$
f(\chi^2,k)
=
\frac{(\chi^2)^{k/2-1} k^{k/2} e^{-\chi^2 k/2}}
{2^{k/2}\Gamma(k/2)}.
$$ {#eq-chi2-pdf}

Here, $\chi^2$ is the cost function defined in @eq-cost, $k$ is the number of degrees of freedom (DOF), and $\Gamma(k/2)$ denotes the gamma function [@Gao:2021bb]. Neglecting potential correlations among measurement uncertainties, the DOF can be approximated by the total number of measurements, $N$. More rigorously, the effective DOF depends on the number and information content of the retrieved parameters and can be evaluated using the Jacobian and error covariance matrices [@Gao:2021bb, @Gao:2023bb].
