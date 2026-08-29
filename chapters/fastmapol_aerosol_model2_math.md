# Aerosol: More on Size Distributions {#sec-aerosol-model-math}

This chapter provides the mathematical relationships used to convert between number- and volume-based aerosol size distributions and to calculate the moments, effective radius, and effective variance used by the FastMAPOL aerosol model.

The operational aerosol representation and the definitions of the Aer-1 and Aer-2 models are described in @sec-aerosol-model.

## Number and Volume Size Distributions

For a single log-normal aerosol mode, the volume distribution is

$$
\frac{dV(r)}{d\ln r}
=
\frac{V_0}{\sqrt{2\pi}\sigma_v}
\exp
\left[
-\frac{(\ln r-\ln r_v)^2}{2\sigma_v^2}
\right],
$$

and the corresponding number distribution is

$$
\frac{dN(r)}{d\ln r}
=
\frac{N_0}{\sqrt{2\pi}\sigma_n}
\exp
\left[
-\frac{(\ln r-\ln r_n)^2}{2\sigma_n^2}
\right].
$$

Here, $V_0$ and $N_0$ are the integrated volume and number densities, $r_v$ and $r_n$ are the volume-mean and number-mean radii, and $\sigma_v$ and $\sigma_n$ are the corresponding logarithmic standard deviations.

Particle volume and number are related through

$$
dV(r)
=
\frac{4\pi}{3}r^3dN(r).
$$

Therefore,

$$
\frac{dV(r)}{d\ln r}
=
\frac{4\pi}{3}r^3
\frac{dN(r)}{d\ln r}.
$$

## Conversion Between Number and Volume Distributions

The equivalent log-normal number and volume distributions have the same logarithmic width:

$$
\sigma_n=\sigma_v=\sigma.
$$

Their characteristic radii are related by

$$
r_n
=
r_v\exp(-3\sigma^2).
$$

The corresponding integrated number and volume densities satisfy

$$
N_0
=
V_0
\frac{3}{4\pi r_v^3}
\exp(4.5\sigma^2),
$$

or equivalently,

$$
N_0
=
V_0
\frac{3}{4\pi r_n^3}
\exp(-4.5\sigma^2).
$$

These relationships allow FastMAPOL's volume-based retrieval state to be converted into the number-density representation required for calculations of particle extinction and other number-weighted quantities.

## Distribution Convention

A particle size distribution may be expressed with respect to either $r$ or $\ln r$. The two representations are related by

$$
\frac{dN(r)}{dr}
=
\frac{1}{r}
\frac{dN(r)}{d\ln r},
$$

and

$$
\frac{dV(r)}{dr}
=
\frac{1}{r}
\frac{dV(r)}{d\ln r}.
$$

This distinction is important when comparing size-distribution parameters and moment definitions among different references and numerical implementations.

## Moments of the Number Distribution

Define the $k$th moment of the number size distribution as

$$
m_k
=
\int_0^\infty
r^k
\frac{dN(r)}{dr}\,dr.
$$

Equivalently,

$$
m_k
=
\int_{-\infty}^{\infty}
r^k
\frac{dN(r)}{d\ln r}\,d\ln r.
$$

For a log-normal number distribution,

$$
m_k
=
N_0r_n^k
\exp
\left(
\frac{k^2\sigma^2}{2}
\right).
$$

Substituting the number-volume relationships gives an equivalent expression in terms of the volume-distribution parameters:

$$
m_k
=
V_0
\frac{3}{4\pi}
r_v^{k-3}
\exp
\left[
\frac{(k-3)^2\sigma^2}{2}
\right].
$$

For $k=3$,

$$
m_3
=
\frac{3V_0}{4\pi},
$$

showing the direct relationship between the third number-distribution moment and total particle volume.

## Effective Radius

The effective radius is the area-weighted mean particle radius:

$$
r_{\mathrm{eff}}
=
\frac{
\int r^3(dN/dr)\,dr
}{
\int r^2(dN/dr)\,dr
}
=
\frac{m_3}{m_2}.
$$

For a log-normal number distribution,

$$
r_{\mathrm{eff}}
=
r_n
\exp
\left(
\frac{5}{2}\sigma^2
\right).
$$

Using

$$
r_n=r_v\exp(-3\sigma^2),
$$

this can also be written as

$$
r_{\mathrm{eff}}
=
r_v
\exp
\left(
-\frac{1}{2}\sigma^2
\right).
$$

Thus,

$$
r_n < r_{\mathrm{eff}} < r_v
$$

for a distribution with finite width.

## Effective Variance

The effective variance is defined as

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

Using the distribution moments,

$$
\nu_{\mathrm{eff}}
=
\frac{m_4m_2}{m_3^2}-1.
$$

For a log-normal distribution,

$$
\nu_{\mathrm{eff}}
=
\exp(\sigma^2)-1.
$$

For sufficiently narrow distributions,

$$
\nu_{\mathrm{eff}}
\approx
\sigma^2,
$$

and

$$
r_{\mathrm{eff}}
\approx
r_v.
$$

## Moments of the Volume Distribution

Because FastMAPOL uses volume density in the retrieval state vector, the same quantities can be expressed directly using volume-distribution moments.

Define

$$
m'_k
=
\int
r^k
\frac{dV(r)}{d\ln r}
\,d\ln r.
$$

The effective radius is then

$$
r_{\mathrm{eff}}
=
\frac{m'_0}{m'_{-1}},
$$

and the effective variance is

$$
\nu_{\mathrm{eff}}
=
\frac{
m'_{-1}m'_1
}{
(m'_0)^2
}
-1.
$$

For a log-normal volume distribution,

$$
m'_k
=
V_0
r_v^k
\exp
\left(
\frac{k^2\sigma^2}{2}
\right).
$$

These expressions are mathematically equivalent to those derived from the number distribution.

## Multimode Aerosol Distributions

For a multimode aerosol,

$$
\frac{dV(r)}{d\ln r}
=
\sum_i
\frac{V_{0,i}}{\sqrt{2\pi}\sigma_i}
\exp
\left[
-\frac{(\ln r-\ln r_{v,i})^2}
{2\sigma_i^2}
\right].
$$

The corresponding total moment is obtained by summing the moments of the individual modes:

$$
m_k
=
\sum_i m_{k,i}.
$$

Therefore,

$$
r_{\mathrm{eff}}
=
\frac{
\sum_i m_{3,i}
}{
\sum_i m_{2,i}
},
$$

and

$$
\nu_{\mathrm{eff}}
=
\frac{
\left(\sum_i m_{4,i}\right)
\left(\sum_i m_{2,i}\right)
}{
\left(\sum_i m_{3,i}\right)^2
}
-1.
$$

Using volume-distribution moments, the equivalent expressions are

$$
r_{\mathrm{eff}}
=
\frac{
\sum_i m'_{0,i}
}{
\sum_i m'_{-1,i}
},
$$

and

$$
\nu_{\mathrm{eff}}
=
\frac{
\left(\sum_i m'_{1,i}\right)
\left(\sum_i m'_{-1,i}\right)
}{
\left(\sum_i m'_{0,i}\right)^2
}
-1.
$$

The same expressions can be applied to the fine or coarse aerosol distributions by restricting the summation to the corresponding modes.

## Relationship Between Volume and Optical Weighting

The distinction between volume and number weighting is important when interpreting multimode aerosol properties. For the same total particle volume, smaller particles correspond to a substantially larger number of particles than larger particles.

For two aerosol modes, the extinction contribution can be expressed as

$$
\tau
=
C_{\mathrm{ext},f}N_f
+
C_{\mathrm{ext},c}N_c.
$$

Using volume density,

$$
\tau
=
C_{\mathrm{ext},f}
\frac{3V_f}{4\pi r_{v,f}^3}
\exp(4.5\sigma_f^2)
+
C_{\mathrm{ext},c}
\frac{3V_c}{4\pi r_{v,c}^3}
\exp(4.5\sigma_c^2).
$$

Thus, the relative optical contribution of two modes depends not only on their volume fractions but also on particle size and extinction efficiency.

This distinction explains why the fine-volume fraction and fine-mode optical-depth fraction are not equivalent and why both quantities provide useful but different information about the retrieved aerosol distribution.

## Summary

The mathematical formulation presented here provides the connection between the volume-based aerosol representation used in the FastMAPOL state vector and the number-, area-, and optically weighted quantities used to characterize aerosol properties. The same moment framework applies to individual log-normal modes, multimode distributions, and fine/coarse aerosol partitions.