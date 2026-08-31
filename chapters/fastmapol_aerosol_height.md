# Aerosol: Layer Height {#sec-aerosol-height}

::: {.implementation-status}

**Implementation status**

| Model | DITL | PACE V3 | PACE V4 | Evaluation | Planned |
|---|:---:|:---:|:---:|:---:|:---:|
| — | x | x | x | — | — |

:::

This chapter describes the aerosol vertical distribution assumed in FastMAPOL and defines the aerosol layer height (ALH) used in the retrieval. The ALH retrieval and its uncertainty, including the dependence on aerosol loading, are discussed in detail in @Gao:2023aa.

As described in previous chapters, the FastMAPOL forward radiative transfer simulations are performed for a coupled atmosphere–surface system, including coupled atmosphere–ocean simulations for ocean retrievals. The vertical distribution of atmospheric molecules follows the U.S. Standard Atmosphere [@Anderson:1986aa]. Aerosols are represented by a single layer with a Gaussian vertical number-density distribution.

## Gaussian Aerosol Vertical Profile

Using the conventional Gaussian notation, the aerosol vertical profile can be written as

$$
n(z) =
A\exp\left[
-\frac{(z-z_{\mathrm{c}})^2}{2\sigma^2}
\right],
$$

where $n(z)$ is the aerosol number-density profile, $z_{\mathrm{c}}$ is the center or peak height of the aerosol layer, and $\sigma$ is the standard deviation of the Gaussian distribution. For an unbounded Gaussian profile, the normalization factor is

$$
A = \frac{N_t}{\sigma\sqrt{2\pi}},
$$

where $N_t$ is the total aerosol column number density.

The relationship between the Gaussian standard deviation and the full width at half maximum (FWHM) is

$$
\mathrm{FWHM}
=
2\sqrt{2\ln 2}\,\sigma.
$$

FastMAPOL V3 and V4 processing assumes an aerosol-layer FWHM of 2 km. Therefore,

$$
\sigma =
\frac{\mathrm{FWHM}}
{2\sqrt{2\ln 2}}
=
\frac{2}
{2\sqrt{2\ln 2}}
\approx 0.85~\mathrm{km}.
$$

Thus, the Gaussian aerosol profile used in FastMAPOL has a fixed width, while the layer center height $z_{\mathrm{c}}$ is varied in the forward model and retrieved as the aerosol layer height parameter.

## Definition of Aerosol Layer Height

Aerosol layer height can be defined in different ways depending on the measurement and retrieval methodology. For example, lidar-based quantities are often expressed as extinction- or backscatter-weighted mean heights.

For the FastMAPOL aerosol model, the aerosol microphysical and optical properties are assumed to be vertically homogeneous within the prescribed Gaussian distribution. A corresponding profile-weighted mean height can therefore be defined as

$$
\bar{z} =
\frac{\displaystyle\int_{z_1}^{z_2} z\,n(z)\,dz}
{\displaystyle\int_{z_1}^{z_2} n(z)\,dz},
$$

where $z$ is altitude in kilometers and $n(z)$ is the prescribed aerosol vertical profile, here we choose $z_1$ and $z_2$ as 0, and 50km.

For a Gaussian profile sufficiently far from the lower and upper atmospheric boundaries, $\bar{z}$ is approximately equal to the Gaussian center height $z_{\mathrm{c}}$. However, differences can occur when the Gaussian distribution is truncated by the surface, particularly for aerosol layers close to the ground as show in Table @tbl-alh-height.

| $z_{\mathrm{c}}$ (km) |  $\bar{z}$ (km) |
|---:|---:|
| 0.0 | 0.68 |
| 0.5 | 0.89 |
| 1.0 | 1.19 |
| 2.0 | 2.02 |

: Relationship between the Gaussian center height $z_{\mathrm{c}}$ and the profile-weighted mean aerosol height $\bar{z}$ for the FastMAPOL aerosol vertical profile. {#tbl-alh-height}

This distinction is important when comparing FastMAPOL-retrieved ALH with validation datasets, such as HSRL-2 or ATLID aboard EarthCARE, particularly for cases with substantial aerosol loading near the surface. In such cases, the retrieved Gaussian center height $z_{\mathrm{c}}$ and the profile-weighted mean height $\bar{z}$ may differ appreciably and should therefore be interpreted consistently when performing validation.

## Relationship to the Wu et al. Parameterization

We follow the definition of aerosol vertical profile from @Wu:2015aa, however, an important notation difference exists between the Gaussian profile used in the FastMAPOL formulation and that introduced by @Wu:2015aa.

Wu et al. expressed the aerosol vertical distribution as

$$
n(z) =
A\exp\left[
-4\ln(2)
\frac{(z-z_{\mathrm{c}})^2}{\sigma'^2}
\right],
$$

where $A$ is a normalization factor, $z_{\mathrm{c}}$ is the center height of the aerosol layer, and $\sigma'$ describes the width of the aerosol height distribution.

Although $\sigma'$ was used as the width parameter, it is **not the standard deviation of a conventional Gaussian distribution**. From the form of the exponent, $\sigma'$ corresponds directly to the FWHM:

$$
\sigma' = \mathrm{FWHM} = 2~\mathrm{km}.
$$

This distinction is a caveat regarding the notation used for the Gaussian width; the two mathematical formulations are equivalent when the width parameters are interpreted consistently. **FastMAPOL V3 and V4 adopt the aerosol-layer FWHM of 2 km, equivalent to a Gaussian standard deviation of approximately 0.85 km.** Thus, the two formulations describe the same aerosol vertical profile despite the different definitions of the width parameter.
