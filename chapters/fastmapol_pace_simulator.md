# Radiative Transfer: PACE Simulator {#sec-rt-model}

**Implementation status**

| Model | DITL | PACE V3 | PACE V4 | Evaluation | Planned |
| --- |:---:|:---:|:---:|:---:|:---:|
| — | x | x | x | — | — |

## Overview

The physical forward model underlying FastMAPOL is the **Radiative Transfer model based on the Successive Order of Scattering (RTSOS)** method [@Zhai:2009aa; @Zhai:2010aa]. RTSOS is a vector radiative transfer model developed for coupled atmosphere–ocean and atmosphere-land systems. For ocean applications, the atmosphere, rough air–sea interface, and ocean body are treated as a physically coupled system so that multiple scattering among these components is explicitly included.

Key features:
- RTSOS is capable of solving polarized radiative transfer for both atmosphere-ocean and atmosphere-land systems. 
- In atmosphere-ocean systems, it can also simulate inelastic scattering processes, including Raman scattering and fluorescence by chlorophyll and colored dissolved organic matter [@Zhai:2015aa; @Zhai:2017aa].
- An improved pseudos-spherical shell (IPSS) algorithm is used to improve the simulation of radiance field over polar regions [@Zhai:2022aa]. More details are in @sec-rt-shell. 

For this work, RTSOS is configured to simulate polarized radiance fields for randomly generated Earth systems for the PACE instruments [@Zhai:2022aa]. The data are then used to train neural network forward models, which emulates the behavior of the radiative transfer system.

## The physics of RTSOS
The model computes the polarized radiation field represented by the Stokes vector

$$
\mathbf{L}=(I,Q,U,V)^T,
$$

where $I$ is the total radiance, $Q$ and $U$ describe linear polarization, $V$ describes circular polarization; the superscript T stands for vector transpose. 

In the RTSOS formulation, the total radiation field is expressed as the sum of contributions from successive scattering orders,

$$
\mathbf{L} = \sum_{n=0}^{N_s}\mathbf{L}^{(n)} + \mathbf{L}_{geo},
$$

where $\mathbf{L}^{(n)}$ represents the contribution from the $n$th order of scattering and $N_s$ is the maximum scattering order retained in the numerical calculation. The first-order scattering solution is evaluated directly, and each subsequent order is obtained by integrating the radiation field from the preceding order over optical depth and propagation direction [@Zhai:2009aa; @Zhai:2010aa]. $\mathbf{L}_{geo}$ is all the contributions beyond order $N_s$, which can be approximated by a geometric series.

## Coupled atmosphere–ocean system

For FastMAPOL ocean retrievals, RTSOS fully accounts for photons which undergo multiple interactions among atmospheric molecules and aerosols, the rough ocean surface, and optically active constituents within the ocean [@Zhai:2009aa; @Zhai:2010aa; @Zhai:2017aa]. The configuration of atmosphere, surface, and ocean water body is described below.

### Atmosphere

Atmospheric optical properties are specified vertically in terms of layer optical depth, single-scattering albedo, and scattering phase matrix. Molecular Rayleigh scattering, gas absorption, aerosol scattering and absorption are included. RTSOS can also be used to simulate cloud radiative transfer, which is however not used in FastMAPOL.

The molecular atmosphere is characterized using vertical profiles of the total atmospheric molecular number density and the mixing ratios of absorbing gases. Gas absorption from major species relevant to the PACE spectral range, including H$_2$O, CO$_2$, O$_2$, CH$_4$, O$_3$, and NO$_2$, are included. In the PACE simulator, high-resolution absorption cross sections for several gases are generated using molecular spectroscopic information from HITRAN, with additional spectral databases used for ozone and NO$_2$ [@Zhai:2022bb].

Aerosol single-scattering properties, including extinction coefficients, single scattering albedos, and Mueller scattering matrices are supplied to RTSOS. The radiative transfer solver itself is therefore not restricted to a particular aerosol particle model. Optical properties obtained from Mie calculations, T-matrix methods, discrete-dipole calculations, or other electromagnetic scattering models can be used as inputs. This flexibility is important for FastMAPOL, where aerosol properties are parameterized differently in different generations of the retrieval algorithm.

### Air–sea interface

The air–sea interface is represented as a wind-roughened surface. Reflection and transmission of polarized radiation across the interface are treated using reflection and transmission matrices, including repeated interactions between the atmosphere, ocean surface, and water body [@Zhai:2010aa].

Surface roughness is parameterized primarily through wind speed using a Cox–Munk wave-slope distribution [@Cox:1954aa]. Consequently, RTSOS explicitly represents the angular structure of ocean glint rather than masking the glint region by default. This feature is useful for FastMAPOL because measurements close to the glint direction contain information about surface wind speed and absorbing aerosols [@Aryal:2024aa].

Foam and whitecap fraction on rough ocean surface and their reflectance are parameterized in terms of wind speed following [@Koepke:1984aa] in the FastMAPOL simulation configuration. 

### Ocean body

In the FastMAPOL/component implementation [@Aryal:2024aa], ocean inherent optical properties include contributions from pure seawater, phytoplankton, non-algal particles, and colored dissolved and detrital material. Particle scattering is represented through the Fourier-Forand phase function [@Fournier:1994aa] and the average Mueller matrix measured [Voss:1984aa], while absorption and scattering coefficients are parameterized through retrievable bio-optical quantities [@Aryal:2024aa]. The expanded representation allows the radiative transfer training database to cover waters for which IOPs do not covary uniquely with chlorophyll-a concentration.

In the FastMAPOL open ocean algorithm [@Gao:2026aa], the absorption and scattering of ocean waters are parameterized in terms of chlorophyll-a concentration, in order to achieve efficiency while maintaining accuracy.

## Numerical treatment

RTSOS discretizes the zenith-angle dependence of the radiation field using Gaussian quadrature and represents azimuthal dependence using a Fourier expansion. Strongly forward-peaked aerosol and hydrosol scattering functions can otherwise require a large number of angular quadrature points. RTSOS therefore includes phase-function truncation techniques, including the $\delta$-M, $\delta$-fit, and related approaches, to improve computational efficiency while preserving radiometric accuracy [@Zhai:2009aa; @Zhai:2022bb].

For geometries with large solar or viewing zenith angles, the plane-parallel approximation becomes less accurate because of the curvature of the atmosphere. RTSOS therefore incorporates an **improved pseudo-spherical shell (IPSS)** correction [@Zhai:2022aa]. The IPSS treatment calculates the exact single scattering solution with spherical geometry while using the computationally efficient plane-parallel multiple-scattering solution to estimate the higher-order contribution. This substantially improves accuracy at large zenith angles and is particularly relevant to high-latitude observations. Additional details are provided in @sec-rt-shell.

## PACE instrument simulator

RTSOS forms the monochromatic radiative transfer core of a more general PACE simulator developed to reproduce the measurements of the three PACE instruments: OCI, HARP2, and SPEXone [@Zhai:2022bb]. The simulator couples the wavelength-dependent atmosphere and ocean optical properties with instrument spectral and viewing characteristics to generate synthetic TOA observations.

The full PACE simulator supports hyperspectral radiance simulations for OCI and multi-angle polarized radiance simulations for HARP2 and SPEXone. Instrument spectral response is important near strong molecular absorption bands, where using only the absorption coefficient at the nominal center wavelength can introduce substantial radiance errors. The PACE simulator therefore includes spectral integration procedures for resolving gas absorption within instrument bands [@Zhai:2022bb].

FastMAPOL does not necessarily use every wavelength available from the instruments. Instead, instrument-dependent wavelength subsets are selected to balance information content and computational cost. For example, the FastMAPOL/component study used 13 wavelengths,

$$
\lambda =
(385,400,410,441,470,490,510,530,549,620,670,740,873)\ {\rm nm},
$$

covering the UV, visible, and near-infrared spectral regions of SPEXone and HARP2 [@Aryal:2024aa]. The wavelength configuration may change between algorithm versions.

## Radiometric quantities generated for FastMAPOL

RTSOS can calculate the complete Stokes vector at the TOA, within the atmosphere, immediately above or below the ocean surface, and at specified depths within the ocean. FastMAPOL primarily uses several derived quantities from these simulations.

The TOA reflectance is defined as

$$
\rho_t =
\frac{\pi I_t}{\mu_0 F_0},
$$

where $I_t$ is the TOA radiance, $\mu_0$ is the cosine of the solar zenith angle, and $F_0$ is the extraterrestrial solar irradiance.

The degree of linear polarization is

$$
P_t =
\frac{\sqrt{Q_t^2+U_t^2}}{I_t}.
$$

In addition to the total TOA signal, RTSOS can perform simulations with the ocean-body contribution removed. This produces the reflectance associated with the atmosphere and ocean surface, $\rho_{a+s}$. The water-leaving contribution reaching the sensor can therefore be obtained from

$$
\rho_w = \rho_t-\rho_{a+s}.
$$

This ability to explicitly label and separate photon contributions is a useful property of the RTSOS formulation and provides a physically consistent method for atmospheric correction [@Zhai:2009aa; @Zhai:2017aa; @Aryal:2024aa].

FastMAPOL also uses RTSOS to calculate quantities required for bidirectional reflectance correction. Rather than relying exclusively on an empirical BRDF correction, simulations can be performed for the retrieved atmosphere–ocean system at both the actual observation geometry and a reference geometry. This permits the angular dependence of the water-leaving radiance to be derived consistently from the same radiative transfer physics used in the retrieval [@Aryal:2024aa; @Gao:2026aa].

## Additional RTSOS capabilities

RTSOS contains capabilities that extend beyond those required by the current elastic-scattering FastMAPOL retrieval. In ocean waters, the model can solve the inelastic vector radiative transfer equation and simulate Raman scattering by water as well as fluorescence by phytoplankton and dissolved organic matter [@Zhai:2015aa; @Zhai:2017ve; @Zhai:2018hc]. These processes couple radiation at different excitation and emission wavelengths and are evaluated using the elastic RTSOS radiation field to construct the corresponding inelastic source terms.

These capabilities are useful for hyperspectral ocean-color studies and future extensions of FastMAPOL, but they should be distinguished from the elastic radiative transfer simulations currently used to generate the primary FastMAPOL neural-network training datasets.

## Model heritage and application to FastMAPOL

RTSOS has evolved from the original coupled atmosphere–ocean model with a flat ocean surface [@Zhai:2009aa] to the treatment of a rough ocean interface [@Zhai:2010aa], from elastic scattering only to inelastic ocean processes [@Zhai:2015aa; @Zhai:2017ve], from plane-parallel to improved spherical-shell geometry [@Zhai:2022aa], and monochromatic simulation to the complete PACE instrument simulator [@Zhai:2022bb].

Within FastMAPOL, RTSOS provides the high-fidelity physical reference from which the neural-network forward models are constructed. The resulting framework therefore combines a rigorous coupled atmosphere–ocean and atmosphere–land vector radiative transfer model with computationally efficient machine-learning emulators, enabling simultaneous aerosol, ocean-color, and surface retrievals from PACE multi-angle polarimetric observations [@Gao:2023aa; @Aryal:2024aa; @Aryal:2026aa; @Gao:2026aa].

**Code availability.** The RTSOS source code and example configurations are publicly available through the AOOG/UMBC RTSOS repository: https://github.com/aoog-umbc/rtsos-public
