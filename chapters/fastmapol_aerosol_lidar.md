# Aerosol: Lidar Ratio and Depolarization {#sec-lidar-ratio}

**Implementation status**

| Model | DITL | PACE V3 | PACE V4 | Evaluation | Planned |
| ----- | :--: | :-----: | :-----: | :--------: | :-----: |
| —     |   —  |    —    |    x    |      —     |    —    |

## Overview

The FastMAPOL aerosol retrieval provides aerosol extinction, scattering, and angular scattering phase-matrix properties. These quantities can be used to derive lidar-relevant aerosol properties, including the **lidar ratio** and **particle linear depolarization ratio**.

In the PACE V4 products, these quantities are reported as `aerosol_lidar_ratio` and `aerosol_depol_ratio`, respectively, as summarized in @sec-data-format.

This chapter describes the relationship between the retrieved aerosol optical properties and these lidar-relevant quantities for the total aerosol as well as the fine- and coarse-mode components.

## Scattering and Phase-Matrix Quantities

Let $\alpha_{\mathrm{ext}}$ and $\alpha_{\mathrm{sca}}$ denote the aerosol volume extinction and scattering coefficients, respectively. The single-scattering albedo is

$$
\omega_0
=
\frac{\alpha_{\mathrm{sca}}}
{\alpha_{\mathrm{ext}}}.
$$

The aerosol angular scattering properties are described by the phase matrix $\mathbf{P}(\Theta)$, where $\Theta$ is the scattering angle. For randomly oriented particles with mirror symmetry, the phase matrix contains elements including

$$
P_{11}(\Theta)
\qquad \text{and} \qquad
P_{22}(\Theta).
$$

For the formulations below, the phase matrix is normalized such that

$$
\int_{4\pi} P_{11}(\Theta,\phi)\,d\Omega
=
4\pi.
$$

Lidar backscatter corresponds to the exact backscattering direction,

$$
\Theta=\pi.
$$

The relevant phase-matrix elements are therefore

$$
P_{11}(\pi)
\qquad \text{and} \qquad
P_{22}(\pi).
$$

## Aerosol Backscatter Coefficient

Under the phase-matrix normalization defined above, the aerosol backscatter coefficient is

$$$
\beta_a
=
\frac{\alpha_{\mathrm{sca}}}{4\pi}
P_{11}(\pi).
$$ {#eq-aerosol-backscatter}

Using

$$$

# \alpha_{\mathrm{sca}}

\omega_0\alpha_{\mathrm{ext}},

$$

the backscatter coefficient can also be written as

$$

# \beta_a

\frac{
\omega_0\alpha_{\mathrm{ext}}
}{4\pi}
P_{11}(\pi).

$$

Thus, aerosol backscatter depends on both the total scattering strength and the fraction of scattered radiation directed toward exact backscatter.

## Lidar Ratio

The aerosol lidar ratio is defined as the ratio of the aerosol extinction coefficient to the aerosol backscatter coefficient:

$$

# S_a

\frac{\alpha_{\mathrm{ext}}}{\beta_a}.

$$

Using @eq-aerosol-backscatter,

$$

# S_a

\frac{
4\pi\alpha_{\mathrm{ext}}
}{
\alpha_{\mathrm{sca}}P_{11}(\pi)
}.

$$

Equivalently, using the single-scattering albedo,

$$

# S_a

\frac{
4\pi
}{
\omega_0P_{11}(\pi)
}.

$${#eq-lidar-ratio}

The lidar ratio therefore depends on both aerosol absorption through $\omega_0$ and the angular distribution of scattering through $P_{11}(\pi)$. Strong extinction combined with relatively weak backscatter produces a larger lidar ratio.

The lidar ratio has units of steradians (sr).

## Particle Linear Depolarization Ratio

The **particle linear depolarization ratio** describes the polarization change produced by aerosol particles in the exact backscattering direction.

Using the backscatter phase-matrix elements, it is defined as

$$

# \delta_a

\frac{
P_{11}(\pi)-P_{22}(\pi)
}{
P_{11}(\pi)+P_{22}(\pi)
}.

$${#eq-aerosol-depol}

Equivalently,

$$

# \delta_a

\frac{
1-P_{22}(\pi)/P_{11}(\pi)
}{
1+P_{22}(\pi)/P_{11}(\pi)
}.

$$

If

$$

P_{22}(\pi)=P_{11}(\pi),

$$

then

$$

\delta_a=0,

$$

corresponding to no linear depolarization of the backscattered light.

Particle linear depolarization is particularly sensitive to particle nonsphericity. Spherical particles generally produce little depolarization, whereas nonspherical particles, such as mineral dust, can produce substantially larger values. The magnitude also depends on particle size, refractive index, shape, orientation, and aerosol mixing state.

## Fine, Coarse, and Total Aerosol

The same relationships can be applied separately to the fine and coarse aerosol modes.

For mode $m$, where $m=f$ denotes fine mode and $m=c$ denotes coarse mode, the backscatter coefficient is

$$

# \beta_{a,m}

\frac{
\alpha_{\mathrm{sca},m}
}{4\pi}
P_{11,m}(\pi),

$$

and the lidar ratio is

$$

# S_{a,m}

\frac{
4\pi\alpha_{\mathrm{ext},m}
}{
\alpha_{\mathrm{sca},m}P_{11,m}(\pi)
}
=

\frac{
4\pi
}{
\omega_{0,m}P_{11,m}(\pi)
}.

$$

The corresponding particle linear depolarization ratio is

$$

# \delta_{a,m}

\frac{
P_{11,m}(\pi)-P_{22,m}(\pi)
}{
P_{11,m}(\pi)+P_{22,m}(\pi)
}.

$$

For a mixture of fine and coarse aerosol, the total extinction and scattering coefficients are

$$

# \alpha_{\mathrm{ext}}

\alpha_{\mathrm{ext},f}
+
\alpha_{\mathrm{ext},c},

$$

and

$$

# \alpha_{\mathrm{sca}}

\alpha_{\mathrm{sca},f}
+
\alpha_{\mathrm{sca},c}.

$$

The total backscatter coefficient is obtained by summing the fine- and coarse-mode contributions:

$$

# \beta_a

\beta_{a,f}
+
\beta_{a,c},

$$

or equivalently,

$$

# \beta_a

\frac{1}{4\pi}
\left[
\alpha_{\mathrm{sca},f}P_{11,f}(\pi)
+
\alpha_{\mathrm{sca},c}P_{11,c}(\pi)
\right].

$$

The total lidar ratio is therefore

$$

# S_a

\frac{
4\pi
\left(
\alpha_{\mathrm{ext},f}
+
\alpha_{\mathrm{ext},c}
\right)
}{
\alpha_{\mathrm{sca},f}P_{11,f}(\pi)
+
\alpha_{\mathrm{sca},c}P_{11,c}(\pi)
}.

$$

Similarly, the total particle linear depolarization ratio is obtained by combining the scattering-weighted phase-matrix contributions from the two modes:

$$

# \delta_a

\frac{
\alpha_{\mathrm{sca},f}
\left[
P_{11,f}(\pi)-P_{22,f}(\pi)
\right]
+
\alpha_{\mathrm{sca},c}
\left[
P_{11,c}(\pi)-P_{22,c}(\pi)
\right]
}{
\alpha_{\mathrm{sca},f}
\left[
P_{11,f}(\pi)+P_{22,f}(\pi)
\right]
+
\alpha_{\mathrm{sca},c}
\left[
P_{11,c}(\pi)+P_{22,c}(\pi)
\right]
}.

$$

Thus, the lidar ratio and particle linear depolarization ratio of the total aerosol are generally **not simple averages** of the corresponding fine- and coarse-mode quantities. Instead, they are determined from the combined extinction and scattering properties of the aerosol mixture.
$$
