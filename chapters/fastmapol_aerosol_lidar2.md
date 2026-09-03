# Aerosol: Backscattering Fraction {#sec-lidar-backscattering}

**Implementation status**

| Model | DITL | PACE V3 | PACE V4 | Evaluation | Planned |
| ----- | :--: | :-----: | :-----: | :--------: | :-----: |
| —     |   —  |    —    |    x    |      —     |    —    |

## Overview

The FastMAPOL aerosol retrieval provides aerosol extinction and scattering properties together with lidar-relevant quantities such as the lidar ratio. These properties can also be used to estimate the **backscattering fraction**, which characterizes the fraction of aerosol scattering directed into the backward hemisphere.

Formally, calculation of the hemispheric backscattering fraction requires integration of the aerosol phase function over all backward scattering directions. The full angular phase function, however, is not provided in the FastMAPOL product. Therefore, the backscattering fraction reported here is approximated from the lidar backscatter at $\Theta=180^\circ$ by assuming that the exact-backscatter value is representative of scattering throughout the backward hemisphere.

This chapter describes the formal definition of the backscattering fraction, the approximation used in FastMAPOL, and its relationship to the lidar ratio and single-scattering albedo.

## Backscattering Fraction

Let $\alpha_{\mathrm{sca}}$ denote the aerosol scattering coefficient and $\mathbf{P}(\Theta)$ the aerosol phase matrix, where $\Theta$ is the scattering angle. The phase function $P_{11}$ is normalized such that

$$
\int_{4\pi}P_{11}(\Theta,\phi)\,d\Omega
=
4\pi.
$$

The hemispheric backscattering fraction, denoted here by $B_a$, is the fraction of total scattered radiation directed into the backward hemisphere:

$$$
B_a
=
\frac{1}{4\pi}
\int_{\Omega_{\mathrm{back}}}
P_{11}(\Theta,\phi)\,d\Omega.
$$ {#eq-backscatter-fraction}

For an azimuthally symmetric phase function, this becomes

$$$

# B_a

\frac{1}{2}
\int_{\pi/2}^{\pi}
P_{11}(\Theta)\sin\Theta,d\Theta.

$${#eq-backscatter-fraction-axisymmetric}

The backscattering fraction is dimensionless and ranges from 0 to 1.

## Approximation from Exact Backscatter

Evaluation of @eq-backscatter-fraction requires the complete phase function over the backward hemisphere. Because the full angular phase function is not provided in the FastMAPOL product, the backscattering fraction is approximated using the phase function at exact backscatter.

The approximation assumes that

$$

P_{11}(\Theta)
\approx
P_{11}(\pi),
\qquad
\frac{\pi}{2}\leq\Theta\leq\pi.

$$

Under this assumption,

$$

B_a
\approx
\frac{1}{2}
P_{11}(\pi)
\int_{\pi/2}^{\pi}\sin\Theta,d\Theta,

$$

which gives

$$

B_a
\approx
\frac{P_{11}(\pi)}{2}.

$${#eq-backscatter-fraction-approx}

Equivalently, the backward hemisphere subtends a solid angle of $2\pi$ sr. The approximation therefore treats the exact-backscatter scattering strength as uniform over this $2\pi$-sr hemisphere.

This approximation should be distinguished from the formal hemispheric integration in @eq-backscatter-fraction. Aerosol phase functions are generally not uniform over the backward hemisphere, and the approximation is intended to provide a simple diagnostic based on the available exact-backscatter information.

## Relation to Lidar Ratio

The aerosol backscatter coefficient at exact backscatter is

$$

# \beta_a

\frac{\alpha_{\mathrm{sca}}}{4\pi}
P_{11}(\pi),

$$

where $\alpha_{\mathrm{sca}}$ is the aerosol scattering coefficient.

The aerosol lidar ratio is defined as

$$

# S_a

\frac{\alpha_{\mathrm{ext}}}{\beta_a},

$$

where $\alpha_{\mathrm{ext}}$ is the aerosol extinction coefficient.

The single-scattering albedo is

$$

# \omega_0

\frac{\alpha_{\mathrm{sca}}}
{\alpha_{\mathrm{ext}}}.

$$

Combining these relationships gives

$$

# \frac{\beta_a}{\alpha_{\mathrm{sca}}}

# \frac{1}{S_a\omega_0}

\frac{P_{11}(\pi)}{4\pi}.

$$

Multiplying by the solid angle of the backward hemisphere, $2\pi$, gives the approximate backscattering fraction:

$$

B_a
\approx
2\pi
\frac{\beta_a}{\alpha_{\mathrm{sca}}}.

$$

Therefore,

$$

\boxed{
B_a
\approx
\frac{2\pi}{S_a\omega_0}
========================

\frac{P_{11}(\pi)}{2}
}

$${#eq-backscatter-fraction-lidar}

This relationship allows a dimensionless estimate of the backscattering fraction to be derived from the lidar ratio and single-scattering albedo without requiring the full angular phase function.

## Fine, Coarse, and Total Aerosol

The same approximation can be applied separately to the fine and coarse aerosol modes.

For the fine mode,

$$

B_{a,f}
\approx
\frac{2\pi}
{S_{a,f}\omega_{0,f}},

$$

and for the coarse mode,

$$

B_{a,c}
\approx
\frac{2\pi}
{S_{a,c}\omega_{0,c}}.

$$

For the total aerosol,

$$

B_a
\approx
\frac{2\pi}
{S_a\omega_0}.

$$

Because the backscatter coefficient and scattering coefficient are additive, the total approximate backscattering fraction can also be expressed as a scattering-weighted combination of the fine- and coarse-mode values:

$$

B_a
\approx
\frac{
\alpha_{\mathrm{sca},f}B_{a,f}
+
\alpha_{\mathrm{sca},c}B_{a,c}
}{
\alpha_{\mathrm{sca},f}
+
\alpha_{\mathrm{sca},c}
}.

$$

Thus, the total backscattering fraction is generally not a simple arithmetic average of the fine- and coarse-mode values.

## Interpretation and Limitations

The backscattering fraction $B_a$ is dimensionless and provides a compact measure of the relative amount of aerosol scattering directed toward the backward hemisphere. Larger values indicate relatively stronger backward scattering, whereas smaller values indicate scattering that is more strongly concentrated in other directions.

The FastMAPOL quantity described here is an **approximation** to the hemispheric backscattering fraction. It assumes that the phase function at exact backscatter,

$$

P_{11}(\pi),

$$

is representative of the entire backward hemisphere. In reality, $P_{11}(\Theta)$ can vary substantially between $90^\circ$ and $180^\circ$, depending on aerosol particle size, shape, and refractive index.

Consequently,

$$

B_a
\approx
\frac{2\pi}{S_a\omega_0}

$$

should be interpreted as an **exact-backscatter-based estimate** rather than a phase-function-integrated hemispheric backscattering fraction. Calculation of the latter requires the complete angular phase function over the backward hemisphere.
$$
