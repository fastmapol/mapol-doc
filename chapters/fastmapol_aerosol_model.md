# Aerosol: Model Representation {#sec-aerosol-model}

This chapter describes the aerosol representations used in FastMAPOL and the aerosol properties derived from the retrieved state vector. The mathematical formulation of log-normal size distributions, including conversions between number- and volume-density representations and the calculation of distribution moments, is provided separately in @sec-aerosol-model-math.

## Aerosol Model Overview

FastMAPOL supports several aerosol representations with increasing complexity:

- **Aer-1:** five predefined log-normal modes
- **Aer-2:** six predefined log-normal modes
- **Aer-3:** aerosol components represented by chemical composition

The currently released HARP2 and SPEXone FastMAPOL products (V1--V4) use the five-mode **Aer-1** representation [@Gao:2021aa; @Gao:2023aa; @Gao:2026aa]. The six-mode **Aer-2** representation was developed for retrievals using RSP observations that include shortwave-infrared (SWIR) measurements [@Gao:2018aa]. **Aer-3** represents aerosols through aerosol components and has been applied to HARP2 and SPEXone for advanced retrieval studies [@Aryal:2026aa]. The component-based aerosol model is described separately in @sec-aerosol-component. 

In general, the effective radius and effective variance can be derived from any aerosol size distribution, as described in @sec-aerosol-model-math. Conversely, when the effective radius and other size-distribution parameters are known, the aerosol mode volume densities can be derived by solving a linear system, as discussed in @sec-aerosol-model-inversion. This can be useful for cross-comparisons of data products based on different aerosol size representations.

This chapter focuses primarily on the Aer-1 and Aer-2 representations under the assumption of spherical particles. For PACE HARP2 and SPEXone data product, aerosol particle shape is represented as a mixture of spherical and nonspherical particles, as implemented in the current FastMAPOL V3 and V4 products [@Gao:2026aa]. The treatment of aerosol particle shape and nonsphericity is described in detail in @sec-aerosol-shape. 

## Log-Normal Aerosol Modes

In Aer-1 and Aer-2, the aerosol size distribution is represented as a linear combination of predefined log-normal modes. Each mode has a prescribed characteristic radius and distribution width, while its column volume density is varied in the forward model and retrieval.

The total volume size distribution is

$$
\frac{dV(r)}{d\ln r}
=
\sum_i
\frac{V_{0,i}}{\sqrt{2\pi}\sigma_i}
\exp
\left[
-\frac{(\ln r-\ln r_{v,i})^2}{2\sigma_i^2}
\right],
$$

where $V_{0,i}$ is the column volume density of mode $i$, $r_{v,i}$ is its volume-mean radius, and $\sigma_i$ is the logarithmic standard deviation.

Because the mode radii and widths are prescribed, the retrieved mode volume densities determine the shape and magnitude of the overall aerosol size distribution.

## Aer-1: Five-Mode Aerosol Model

The default FastMAPOL aerosol representation, Aer-1, follows the multimode parameterization adopted from @Dubovik:2011aa and @Xu:2016aa.

The five volume-mode radii are

$$
0.1,\ 0.1732,\ 0.3,\ 1.0,\ 2.9\ \mu\mathrm{m},
$$

with corresponding logarithmic standard deviations

$$
0.35,\ 0.35,\ 0.35,\ 0.5,\ 0.5.
$$

The first three modes represent fine-mode aerosols, while the last two represent coarse-mode aerosols:

- **Fine mode:** $r_v=0.1$, $0.1732$, and $0.3\ \mu\mathrm{m}$
- **Coarse mode:** $r_v=1.0$ and $2.9\ \mu\mathrm{m}$

The relative contributions of these predefined modes allow FastMAPOL to represent a range of aerosol size distributions without directly retrieving the radius and width of individual log-normal modes.

The impact of the number of aerosol modes on retrieval performance is discussed in @Fu:2020aa.

## Aer-2: Six-Mode Aerosol Model

Aer-2 extends Aer-1 by adding an additional large coarse mode. This representation was introduced in @Gao:2018aa for RSP retrievals, where SWIR observations provide additional sensitivity to large aerosol particles.

The additional mode has

$$
r_v=8.4\ \mu\mathrm{m},
\qquad
\sigma=0.5.
$$

Aer-2 therefore contains the same three fine modes as Aer-1 but extends the coarse-mode representation to

$$
1.0,\ 2.9,\ 8.4\ \mu\mathrm{m}.
$$

The additional large-particle mode provides greater flexibility for representing coarse aerosols when sufficient SWIR information is available.

## Fine and Coarse Aerosol Partitioning

For Aer-1 and Aer-2, fine- and coarse-mode aerosol properties are calculated by grouping the predefined modes:

- **Fine aerosol:** modes 1--3
- **Coarse aerosol:** modes 4 and above

The total column volume density is

$$
V_0=\sum_i V_{0,i}.
$$

The fine-volume fraction (FVF) is therefore

$$
\mathrm{FVF}
=
\frac{
\sum_{i\in\mathrm{fine}}V_{0,i}
}{
\sum_i V_{0,i}
}.
$$

In contrast, the fine-mode fraction (FMF) is defined using aerosol optical depth:

$$
\mathrm{FMF}(\lambda)
=
\frac{
\tau_{\mathrm{fine}}(\lambda)
}{
\tau_{\mathrm{total}}(\lambda)
}.
$$

FVF and FMF describe different aspects of the aerosol distribution. FVF is a particle-volume fraction, whereas FMF is an optically weighted quantity and therefore depends on wavelength, particle size, and aerosol optical properties.

## Aerosol Optical Depth

The aerosol optical depth is obtained by integrating the extinction contribution from all aerosol modes:

$$
\tau_a(\lambda)
=
\sum_i
C_{\mathrm{ext},i}(\lambda)N_{0,i},
$$

where $C_{\mathrm{ext},i}$ is the size-averaged extinction cross section and $N_{0,i}$ is the column number density of mode $i$.

Because FastMAPOL retrieves column volume density, the corresponding column number density is calculated from

$$
N_{0,i}
=
V_{0,i}
\frac{3}{4\pi r_{v,i}^3}
\exp(4.5\sigma_i^2).
$$

Thus,

$$
\tau_a(\lambda)
=
\sum_i
\left[
C_{\mathrm{ext},i}(\lambda)
\frac{3}{4\pi r_{v,i}^3}
\exp(4.5\sigma_i^2)
\right]
V_{0,i}.
$$

The mathematical derivation of the conversion between volume and number distributions is provided in @sec-aerosol-model-math.

## Effective Radius and Effective Variance

Bulk effective radius and effective variance are calculated from the combined aerosol size distribution. For a multimode aerosol,

$$
r_{\mathrm{eff}}
=
\frac{
\int r^3(dN/dr)\,dr
}{
\int r^2(dN/dr)\,dr
}
$$

and

$$
\nu_{\mathrm{eff}}
=
\frac{
\int
(r-r_{\mathrm{eff}})^2
r^2(dN/dr)\,dr
}{
r_{\mathrm{eff}}^2
\int r^2(dN/dr)\,dr
}.
$$

These quantities can be calculated for the total aerosol distribution or separately for the fine and coarse modes by restricting the mode summation [@sec-aerosol-model-math].

Although the three fine modes in Aer-1 and Aer-2 have the same logarithmic standard deviation, the effective radius and effective variance of the combined fine-mode distribution vary according to the relative retrieved volume densities of the three modes.

Detailed derivations of these expressions are provided in @sec-aerosol-model-math.

## Aerosol Products

The retrieved mode volume densities, together with the retrieved aerosol optical properties, are used to derive a range of aerosol products, including:

- aerosol optical depth (AOD)
- fine-mode and coarse-mode AOD
- fine-mode fraction (FMF)
- fine-volume fraction (FVF)
- effective radius
- effective variance
- single-scattering albedo (SSA)
- spectrally dependent aerosol optical properties

These quantities may be calculated for the total aerosol distribution or separately for the fine and coarse modes.

The predefined multimode representation therefore provides a flexible connection between the FastMAPOL retrieval state vector and physically interpretable aerosol size and optical properties.