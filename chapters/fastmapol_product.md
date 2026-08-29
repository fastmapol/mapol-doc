# Data Products and Format

## Overview

FastMAPOL (Fast Multi-Angle Polarimetric Ocean and Land algorithm) produces Level-2 (L2) geophysical retrievals of aerosol and surface properties from the multi-angle polarimetric measurements of the **PACE polarimeters**, including **HARP2** and **SPEXone**.

The Level-2 product provides pixel-level estimates of aerosol optical properties, aerosol microphysical parameters, and ocean color quantities derived through atmospheric correction. In addition to the primary geophysical retrievals, the product includes diagnostic quantities describing retrieval performance and quality indicators for downstream processing.

The Level-2 product is distributed in **NetCDF format** and organized into hierarchical data groups to separate geolocation, geophysical variables, diagnostics, and sensor parameters.

The FastMAPOL Level-2 product is designed to support:

- aerosol science applications
- ocean color studies
- land surface studies
- atmospheric correction
- algorithm validation
- Level-3 gridded product generation

---

## File Organization

The FastMAPOL Level-2 product is organized into several top-level groups. Each group contains variables associated with a specific component of the retrieval system.

| Group | Description |
|---|---|
| `geolocation_data` | Pixel geolocation information |
| `geophysical_data` | Primary aerosol, ocean, and land retrieval products |
| `diagnostic_data` | Retrieval diagnostics and performance metrics |
| `sensor_band_parameters` | Instrument spectral and angular parameters |
| `processing_control` | Processing metadata and algorithm configuration |

### Dimensions

The FastMAPOL Level-2 product uses a set of core dimensions describing the spatial, spectral, and angular sampling of the observations and retrieval products.

| Dimension | Description |
|---|---|
| `number_of_lines` | Number of along-track scan lines |
| `pixels_per_line` | Number of cross-track pixels |
| `wavelength` | Spectral wavelengths used in the retrieval products |
| `number_of_views` | Number of viewing angles |
| `intensity_bands_per_view` | Number of intensity bands per viewing angle |
| `polarization_bands_per_view` | Number of polarization bands per viewing angle |


### Instrument Differences

**HARP2**

- ~90 viewing angles  
- 4 spectral bands : 440, 550, 670, 870nm
- wide swath (~2000km)

**SPEXone**

- 5 viewing angles  
- hyperspectral polarimetric measurements 50
- narrow swath (~100km)

A total of 34 specific wavelengths from the hyperspectral measurements for aerosol and surface retrieval.

## Geolocation Data

Group: `/geolocation_data`

| Variable | Dimensions | Description |
|---|---|---|
| `latitude` | (`number_of_lines`, `pixels_per_line`) | Pixel latitude |
| `longitude` | (`number_of_lines`, `pixels_per_line`) | Pixel longitude |

These variables define the geographic location of each retrieval pixel.

## Geophysical Retrieval Products

Group: `/geophysical_data`

The geophysical group contains aerosol optical properties, aerosol microphysical parameters, and ocean color products retrieved by FastMAPOL. Two data suites, MAPOL_OCEAN and MAPOL_LAND, are available for aerosol over ocean and land, respectively.  

### Aerosol Optical Properties 

**Product suites:** `MAPOL_OCEAN` and `MAPOL_LAND`

| Variable | Dimensions | Description |
|---|---|---|
| `aot` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Aerosol optical depth |
| `aot_fine` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Fine-mode aerosol optical depth |
| `aot_coarse` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Coarse-mode aerosol optical depth |
| `ssa` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Aerosol single-scattering albedo |
| `ssa_fine` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Fine-mode single-scattering albedo |
| `ssa_coarse` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Coarse-mode single-scattering albedo |
| `angstrom_440_870` | (`number_of_lines`, `pixels_per_line`) | Ångström exponent (440–870 nm) |
| `angstrom_440_670` | (`number_of_lines`, `pixels_per_line`) | Ångström exponent (440–670 nm) |
| `fmf` | (`number_of_lines`, `pixels_per_line`) | Fine-mode aerosol optical depth fraction |

These parameters describe aerosol optical loading and spectral behavior. Note that Ångström exponent (440-870 nm) is only available for HARP2 data since SPEXone do not have 870nm band. 

### Aerosol Microphysical Properties

**Product suites:** `MAPOL_OCEAN` and `MAPOL_LAND`

| Variable | Dimensions | Description |
|---|---|---|
| `reff_fine` | (`number_of_lines`, `pixels_per_line`) | Fine-mode effective radius |
| `reff_coarse` | (`number_of_lines`, `pixels_per_line`) | Coarse-mode effective radius |
| `veff_fine` | (`number_of_lines`, `pixels_per_line`) | Fine-mode effective variance |
| `veff_coarse` | (`number_of_lines`, `pixels_per_line`) | Coarse-mode effective variance |
| `mr_fine` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Fine-mode real refractive index |
| `mr_coarse` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Coarse-mode real refractive index |
| `mr` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Mode-averaged real refractive index |
| `mi_fine` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Fine-mode imaginary refractive index |
| `mi_coarse` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Coarse-mode imaginary refractive index |
| `mi` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Mode-averaged imaginary refractive index |
| `sph_fine` | (`number_of_lines`, `pixels_per_line`) | Fine-mode spherical particle fraction |
| `sph_coarse` | (`number_of_lines`, `pixels_per_line`) | Coarse-mode spherical particle fraction |
| `sph` | (`number_of_lines`, `pixels_per_line`) | Volume-averaged spherical particle fraction |
| `vd_fine` | (`number_of_lines`, `pixels_per_line`) | Fine-mode aerosol volume density |
| `vd_coarse` | (`number_of_lines`, `pixels_per_line`) | Coarse-mode aerosol volume density |
| `fvf` | (`number_of_lines`, `pixels_per_line`) | Fine-mode volume fraction |
| `alh` | (`number_of_lines`, `pixels_per_line`) | Aerosol layer height |

These variables constrain aerosol particle size distribution, composition, and shape.

### Ocean Products

**Product suites:** `MAPOL_OCEAN`

| Variable | Dimensions | Description |
|---|---|---|
| `Rrs_angular` | (`number_of_lines`, `pixels_per_line`, `number_of_views`, `intensity_bands_per_view`) | Angular remote sensing reflectance before bidirectional reflectance correction |
| `Rrs_nadir` | (`number_of_lines`, `pixels_per_line`, `number_of_views`, `intensity_bands_per_view`) | Nadir-adjusted remote sensing reflectance after bidirectional reflectance correction |
| `Rrs_angular_mean` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Mean of `Rrs_angular` over viewing angles |
| `Rrs_angular_std` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Standard deviation of `Rrs_angular` over viewing angles |
| `Rrs_nadir_mean` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Mean of `Rrs_nadir` over viewing angles |
| `Rrs_nadir_std` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Standard deviation of `Rrs_nadir` over viewing angles |
| `wind_speed` | (`number_of_lines`, `pixels_per_line`) | Retrieved ocean surface wind speed |
| `chla` | (`number_of_lines`, `pixels_per_line`) | Retrieved chlorophyll-*a* concentration |

The dimensions of the angular reflectance products depend on the PACE polarimeter. Example dimensions are:

- **SPEXone:** `number_of_lines = 395`, `pixels_per_line = 29`, `number_of_views = 5`, and `intensity_bands_per_view = 34`.
- **HARP2:** `number_of_lines = 395`, `pixels_per_line = 519`, `number_of_views = 90`, and `intensity_bands_per_view = 1`.

The remote sensing reflectance represents ocean-leaving reflectance after atmospheric correction. To compare with AERONET OC or other dataset for validation purpose after BRDF correction, variable Rrs_nadir_mean is suggested to use. 

Note that V3 data contains **Rrs1** and **Rrs2**, which are renmaed as **Rrs_angular** and **Rrs_nadir** in current V4 data.

### Land surface product

**Product suites:** `MAPOL_LAND`

| Variable | Dimensions | Description |
|---|---|---|
| `rhos_angular` | (`number_of_lines`, `pixels_per_line`, `number_of_views`, `intensity_bands_per_view`) | Angular land surface reflectance before bidirectional reflectance correction |
| `rhos_nadir` | (`number_of_lines`, `pixels_per_line`, `number_of_views`, `intensity_bands_per_view`) | Nadir-adjusted land surface reflectance after bidirectional reflectance correction |
| `rhos_angular_mean` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Mean of `rhos_angular` over viewing angles |
| `rhos_angular_std` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Standard deviation of `rhos_angular` over viewing angles |
| `rhos_nadir_mean` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Mean of `rhos_nadir` over viewing angles |
| `rhos_nadir_std` | (`number_of_lines`, `pixels_per_line`, `wavelength`) | Standard deviation of `rhos_nadir` over viewing angles |


The land surface reflectance represents reflectance after atmospheric correction. To compare with validation dataset after BRDF correction, variable rhos_nadir_mean is suggested to use. 

## Diagnostic Data

**Product suites:** `MAPOL_OCEAN` and `MAPOL_LAND`

Group: `/diagnostic_data`

These variables describe retrieval convergence and performance.

| Variable | Dimensions | Description |
|---|---|---|
| `chi2` | (`number_of_lines`, `pixels_per_line`) | Retrieval cost function |
| `chi2_first_guess` | (`number_of_lines`, `pixels_per_line`) | Cost function at the initial state |
| `nv_ref` | (`number_of_lines`, `pixels_per_line`) | Number of reflectance measurements used in the retrieval |
| `nv_dolp` | (`number_of_lines`, `pixels_per_line`) | Number of DoLP measurements used in the retrieval |
| `nfev` | (`number_of_lines`, `pixels_per_line`) | Number of forward-model evaluations |
| `njev` | (`number_of_lines`, `pixels_per_line`) | Number of Jacobian evaluations |
| `timing` | (`number_of_lines`, `pixels_per_line`) | Retrieval runtime |
| `quality_flag` | (`number_of_lines`, `pixels_per_line`) | Retrieval quality indicator |
| `ozone` | (`number_of_lines`, `pixels_per_line`) | Total column ozone |
| `surface_pressure` | (`number_of_lines`, `pixels_per_line`) | Surface pressure |

### Retrieval Quality Metrics

FastMAPOL retrievals are performed using an optimal estimation framework that minimizes the cost function

$$
\chi^2 = \frac{1}{N}\sum \frac{(f-m)^2}{\sigma^2}
$$

where

- $m$ is the measurement  
- $f$ is the forward model simulation
- $\sigma$ is measurement uncertainty  
- $N$ is the number of measurements used in the retrieval.

Lower values of $\chi^2$ indicate better agreement between measurements and forward model simulations.

### Retrieval Quality Flag

A quality flag is provided to facilitate filtering and Level-3 processing.

| quality_flag | Description |
|--------------|-------------|
| `0` | highest retrieval quality |
| `1` | good retrieval quality |
| `>1` | reduced quality |

The quality flag is determined from combinations of:

- cost function value
- number of reflectance measurements
- number of polarization measurements.

### Angular Measurement Screening Masks

**Product suites:** `MAPOL_OCEAN` and `MAPOL_LAND`

FastMAPOL performs adaptive measurement screening during the retrieval to identify measurements excluded from the inversion.

| Variable | Dimensions | Description |
|---|---|---|
| `mask_ref` | (`number_of_lines`, `pixels_per_line`, `number_of_views`, `intensity_bands_per_view`) | Reflectance measurement screening mask |
| `mask_dolp` | (`number_of_lines`, `pixels_per_line`, `number_of_views`, `polarization_bands_per_view`) | DoLP measurement screening mask |

The screening masks are interpreted as follows:

| Value | Meaning |
|---|---|
| `0` | Measurement used in the retrieval |
| `1` or `NaN` | Measurement excluded from the retrieval |

These masks allow users to identify the measurements retained or excluded at each viewing angle and wavelength.

## Sensor Band Parameters

**Product suites:** `MAPOL_OCEAN` and `MAPOL_LAND`

**Group:** `/sensor_band_parameters`

| Variable | Dimensions | Description |
|---|---|---|
| `wavelength` | (`wavelength`) | Retrieval wavelengths |
| `sensor_view_angle` | (`number_of_views`) | Sensor viewing angles |
| `intensity_wavelength` | (`number_of_views`, `intensity_bands_per_view`) | Intensity field center wavelengths at each view |