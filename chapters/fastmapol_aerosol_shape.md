# Aerosol Particle Shape and Nonspherical Representation {#sec-aerosol-shape}

FastMAPOL accounts for aerosol particle nonsphericity by allowing each aerosol size mode to contain a mixture of spherical and nonspherical particles [@Gao:2026aa]. Nonspherical particles can be represented using the spheroidal particle model following @Dubovik:2006aa or the irregular hexahedral particle model following @Saito:2021aa. This treatment is particularly important for mineral dust and other irregular particles, whose polarized scattering properties can differ substantially from those of equivalent spherical particles. For the current FastMAPOL V3 and V4 operational products, the spheroidal model is used by default to represent variations in aerosol particle shape.

The particle-shape representation is applied independently of the aerosol size-mode representation described in @sec-aerosol-model. Thus, both fine- and coarse-mode aerosols can contain mixtures of spherical and nonspherical particles.

## Spherical Fraction

FastMAPOL defines the **spherical fraction**, denoted here as $f_{\mathrm{sph}}$, as the fraction of the aerosol particle volume represented by spherical particles:

$$$
f_{\mathrm{sph}}
=
\frac{V_{\mathrm{sph}}}
{V_{\mathrm{sph}}+V_{\mathrm{nonsph}}},
$$ {#eq-spherical-fraction}

where $V_{\mathrm{sph}}$ and $V_{\mathrm{nonsph}}$ are the column volume densities of spherical and nonspherical particles, respectively.

The total aerosol volume density is therefore

$$$

# V_{\mathrm{tot}}

V_{\mathrm{sph}}+V_{\mathrm{nonsph}},

$$

and the two particle-shape components can be written as

$$

# V_{\mathrm{sph}}

f_{\mathrm{sph}}V_{\mathrm{tot}},

$$
$$

# V_{\mathrm{nonsph}}

(1-f_{\mathrm{sph}})V_{\mathrm{tot}}.

$$

The spherical fraction ranges from

$$

0\le f_{\mathrm{sph}}\le1.

$$

The limiting cases have straightforward interpretations:

- $f_{\mathrm{sph}}=1$: all aerosol particle volume is represented by spherical particles;
- $f_{\mathrm{sph}}=0$: all aerosol particle volume is represented by nonspherical particles;
- $0<f_{\mathrm{sph}}<1$: the aerosol mode is represented by a volume-weighted mixture of spherical and nonspherical particles.

Because $f_{\mathrm{sph}}$ is defined as a **volume fraction**, it should not be interpreted as the fraction of the number of particles that are spherical. The corresponding number fractions can differ substantially because particle number depends strongly on particle size.

## Spherical and Nonspherical Particle Models

The spherical component is modeled using spherical-particle scattering calculations. The nonspherical component is represented by an ensemble of spheroidal particles following @Dubovik:2006aa and irregular hexahedral particle model following @Saito:2021aa.

For a given aerosol mode, the spherical and nonspherical components use the same aerosol microphysical state, including the prescribed size distribution and complex refractive index, while differing in their particle-shape representation.

For each component, the single-particle calculations provide the quantities required by the vector radiative transfer model, including extinction, scattering, absorption, and the scattering phase matrix.

Either spheroidal or hexadedral representation provides an approximation for the ensemble-averaged optical properties of naturally occurring nonspherical aerosols without considering the detailed shape of each individual particle to be specified.

## Mixing Spherical and Nonspherical Aerosols

The optical properties of the spherical and nonspherical components are combined according to their aerosol loading. Because the FastMAPOL aerosol state is represented using particle volume, the shape partitioning is first performed in volume space using @eq-spherical-fraction.

For aerosol mode $i$,

$$

# V_{i,\mathrm{sph}}

f_{\mathrm{sph},i}V_i,

$$

and

$$

# V_{i,\mathrm{nonsph}}

(1-f_{\mathrm{sph},i})V_i.

$$

The extinction optical depth of the mixed mode is consequently

$$

# \tau_{\mathrm{ext},i}

\tau_{\mathrm{ext},i}^{\mathrm{sph}}
+
\tau_{\mathrm{ext},i}^{\mathrm{nonsph}}.

$$

If the spherical and nonspherical components share the same conversion between volume and number density, this can be expressed as

$$

# \tau_{\mathrm{ext},i}

V_i
\left[
f_{\mathrm{sph},i},
\alpha_{\mathrm{ext},i}^{\mathrm{sph}}
+
(1-f_{\mathrm{sph},i}),
\alpha_{\mathrm{ext},i}^{\mathrm{nonsph}}
\right],

$${#eq-shape-extinction}

where $\alpha_{\mathrm{ext}}$ represents extinction per unit aerosol volume.

Similarly, the scattering optical depth is

$$

# \tau_{\mathrm{sca},i}

V_i
\left[
f_{\mathrm{sph},i},
\alpha_{\mathrm{sca},i}^{\mathrm{sph}}
+
(1-f_{\mathrm{sph},i}),
\alpha_{\mathrm{sca},i}^{\mathrm{nonsph}}
\right].

$${#eq-shape-scattering}

Thus, the aerosol loading is partitioned by volume, while the resulting optical properties reflect the different extinction and scattering efficiencies of spherical and nonspherical particles.

## Mixing of the Scattering Phase Matrix

For polarized radiative transfer, the scattering phase matrix must also be combined consistently with the scattering contribution from each particle-shape component.

Let $\mathbf{P}_{\mathrm{sph}}(\Theta)$ and $\mathbf{P}_{\mathrm{nonsph}}(\Theta)$ represent the scattering phase matrices of the spherical and nonspherical components at scattering angle $\Theta$. The phase matrix of the mixture is scattering-weighted:

$$

# \mathbf{P}_{\mathrm{mix}}(\Theta)

\frac{
\tau_{\mathrm{sca}}^{\mathrm{sph}}
\mathbf{P}*{\mathrm{sph}}(\Theta)
+
\tau*{\mathrm{sca}}^{\mathrm{nonsph}}
\mathbf{P}*{\mathrm{nonsph}}(\Theta)
}{
\tau*{\mathrm{sca}}^{\mathrm{sph}}
+
\tau_{\mathrm{sca}}^{\mathrm{nonsph}}
}.

$${#eq-shape-phase-matrix}

This distinction is important. Although the spherical fraction is defined from **particle volume**, the phase matrix cannot in general be obtained by simply applying the same volume-weighted average,

$$

f_{\mathrm{sph}}\mathbf{P}*{\mathrm{sph}}
+
(1-f*{\mathrm{sph}})\mathbf{P}_{\mathrm{nonsph}},

$$

because spherical and nonspherical particles can have different scattering efficiencies. The volume partition is therefore converted into the corresponding optical contributions before the scattering properties are combined.

The resulting mixed aerosol optical properties are then used by the vector radiative transfer model to calculate total and polarized radiances.

## Relationship to the Multimode Aerosol Model

The particle-shape treatment can be applied to each of the predefined aerosol size modes described in @sec-aerosol-model. In the general formulation,

$$

# V_i

V_{i,\mathrm{sph}}
+
V_{i,\mathrm{nonsph}},

$$

with

$$

# V_{i,\mathrm{sph}}

f_{\mathrm{sph},i}V_i,
\qquad
V_{i,\mathrm{nonsph}}
=====================

(1-f_{\mathrm{sph},i})V_i.

$$

The total aerosol optical properties are obtained by first combining the spherical and nonspherical contributions within each size mode and then summing the optical contributions from all aerosol modes.

This separates two aspects of aerosol characterization:

1. the **size-mode volume densities** determine how aerosol volume is distributed across particle sizes; and
2. the **spherical fraction** determines how the volume within a size mode is partitioned between spherical and nonspherical particle representations.

The combination allows FastMAPOL to vary aerosol size and particle shape independently within the constraints of the adopted aerosol model.

## Summary

FastMAPOL represents aerosol particle shape using a mixture of spherical and nonspherical particles, with the nonspherical component described by a spheroidal model following @Dubovik:2006aa. The spherical fraction $f_{\mathrm{sph}}$ is defined as the fraction of total aerosol particle volume assigned to spherical particles.

For each aerosol mode,

$$

V_{\mathrm{sph}}=f_{\mathrm{sph}}V_{\mathrm{tot}},
\qquad
V_{\mathrm{nonsph}}=(1-f_{\mathrm{sph}})V_{\mathrm{tot}}.

$$

The volume partition is subsequently converted into the corresponding extinction and scattering contributions. Optical depths are additive, while polarized scattering properties and phase matrices are combined according to their scattering contributions. This formulation provides a consistent connection between the volume-based FastMAPOL aerosol model and the spherical/spheroidal particle-shape representation required for vector radiative transfer.
$$
