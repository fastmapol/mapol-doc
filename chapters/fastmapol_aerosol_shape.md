# Aerosol: Shape and Nonsphericity {#sec-aerosol-shape}

::: {.implementation-status}

**Implementation status**

| Model | DITL | PACE V3 | PACE V4 | Evaluation | Planned |
|---|:---:|:---:|:---:|:---:|:---:|
| Spheroidal | — | — | x | — | — |
| Hexahedral | — | — | - | x | — |

:::

FastMAPOL accounts for aerosol particle nonsphericity by allowing each aerosol size mode to contain a mixture of spherical and nonspherical particles [@Gao:2026aa]. Nonspherical particles can be represented using the spheroidal particle model following @Dubovik:2006aa or the irregular hexahedral particle model following @Saito:2021aa. This treatment is particularly important for mineral dust and other irregular particles, whose polarized scattering properties can differ substantially from those of equivalent spherical particles.

For the current FastMAPOL V3 and V4 operational products, the spheroidal model is used by default. The particle-shape representation is applied independently of the aerosol size-mode representation described in @sec-aerosol-model.

## Spherical and Nonspherical Particle Models

The spherical aerosol component is modeled using spherical-particle scattering calculations, while the nonspherical component can be represented by an ensemble of spheroidal particles [@Dubovik:2006aa] or irregular hexahedral particles [@Saito:2021aa].

For a given aerosol mode, the spherical and nonspherical components share the same prescribed size distribution and complex refractive index but differ in their particle-shape representation. The resulting single-particle optical properties, including extinction, scattering, absorption, and the scattering phase matrix, are used by the vector radiative transfer model.

These nonspherical representations approximate the ensemble-averaged optical properties of irregular aerosol particles without explicitly describing the detailed morphology of individual particles.

## Spherical Fraction

FastMAPOL characterizes particle shape using the **spherical fraction**, $f_{\mathrm{sph}}$, defined as the fraction of aerosol particle volume represented by spherical particles:

$$
f_{\mathrm{sph}}
=
\frac{V_{\mathrm{sph}}}
{V_{\mathrm{sph}}+V_{\mathrm{nonsph}}}.
$$ {#eq-spherical-fraction}

Here, $V_{\mathrm{sph}}$ and $V_{\mathrm{nonsph}}$ are the column volume densities of the spherical and nonspherical components, respectively.

For a total aerosol volume density $V_{\mathrm{tot}}$,

$$
V_{\mathrm{sph}}
=
f_{\mathrm{sph}} V_{\mathrm{tot}},
\qquad
V_{\mathrm{nonsph}}
=
(1-f_{\mathrm{sph}})V_{\mathrm{tot}}.
$$ {#eq-shape-volume}

The spherical fraction is bounded by

$$
0 \le f_{\mathrm{sph}} \le 1,
$$

where $f_{\mathrm{sph}}=1$ represents completely spherical particles and $f_{\mathrm{sph}}=0$ represents completely nonspherical particles.

The spherical fraction is defined as a **volume fraction**, rather than a particle number fraction.

## Mixing Spherical and Nonspherical Aerosols

Because the FastMAPOL aerosol state is represented using particle volume, spherical and nonspherical components are first partitioned according to their volume fractions.

For aerosol mode $i$,

$$
V_{i,\mathrm{sph}}
=
f_{\mathrm{sph},i}V_i,
\qquad
V_{i,\mathrm{nonsph}}
=
(1-f_{\mathrm{sph},i})V_i.
$$ {#eq-shape-mode-volume}

The corresponding extinction optical depth is additive:

$$
\tau_{\mathrm{ext},i}
=
\tau_{\mathrm{ext},i}^{\mathrm{sph}}
+
\tau_{\mathrm{ext},i}^{\mathrm{nonsph}}.
$$ {#eq-shape-extinction}

Expressed in terms of extinction per unit aerosol volume,

$$
\tau_{\mathrm{ext},i}
=
V_i
\left[
f_{\mathrm{sph},i}\alpha_{\mathrm{ext},i}^{\mathrm{sph}}
+
(1-f_{\mathrm{sph},i})
\alpha_{\mathrm{ext},i}^{\mathrm{nonsph}}
\right],
$$ {#eq-shape-extinction-volume}

where $\alpha_{\mathrm{ext}}$ represents extinction per unit aerosol volume.

The same approach is applied to the scattering optical depth and other additive optical quantities.

## Scattering Phase Matrix

For polarized radiative transfer, the phase matrix of the spherical and nonspherical components is combined according to their scattering contributions rather than directly according to their volume fractions.

The mixed phase matrix can be written as

$$
\mathbf{P}_{\mathrm{mix}}(\Theta)
=
\frac{
\tau_{\mathrm{sca}}^{\mathrm{sph}}
\mathbf{P}_{\mathrm{sph}}(\Theta)
+
\tau_{\mathrm{sca}}^{\mathrm{nonsph}}
\mathbf{P}_{\mathrm{nonsph}}(\Theta)
}{
\tau_{\mathrm{sca}}^{\mathrm{sph}}
+
\tau_{\mathrm{sca}}^{\mathrm{nonsph}}
}.
$$ {#eq-shape-phase-matrix}

Here, $\mathbf{P}_{\mathrm{sph}}$ and $\mathbf{P}_{\mathrm{nonsph}}$ are the scattering phase matrices of the spherical and nonspherical components, respectively.

Thus, although particle shape is partitioned using **aerosol volume**, the resulting optical properties are weighted according to the corresponding extinction or scattering contributions. This distinction accounts for differences in optical efficiency between spherical and nonspherical particles.

## Application to the Multimode Aerosol Model

The particle-shape treatment can be applied to the predefined aerosol modes described in @sec-aerosol-model. Aerosol size and particle shape therefore represent two separate aspects of the aerosol model:

- **mode volume density** determines the distribution of aerosol volume among particle sizes; and
- **spherical fraction** determines the partitioning between spherical and nonspherical particles.

The optical properties are first combined between the spherical and nonspherical components within each mode and then summed across aerosol modes.

This formulation allows FastMAPOL to represent variations in aerosol size and particle shape within a consistent volume-based aerosol framework.