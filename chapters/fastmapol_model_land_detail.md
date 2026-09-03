# Land Surface Reflectance: Mathematical Formulation {#sec-land-model-math}

**Implementation status**

| Model | DITL | PACE V3 | PACE V4 | Evaluation | Planned |
| ----- | :--: | :-----: | :-----: | :--------: | :-----: |
| —     |   —  |    —    |    x    |      —     |    —    |

This chapter provides the detailed mathematical formulation of the land surface reflectance model summarized in @sec-land-model. It describes the geometry conventions, Ross volumetric kernel, Li geometric-optical kernel, Fresnel reflection matrix, and polarized surface reflection kernel used in the RTSOS (@sec-rt-model) and trained into FastMAPOL NN.

## RTSOS Geometry Convention

The model follows the **RTSOS light-ray convention**, in which the zenith and azimuth angles are defined with respect to the direction of light propagation.

Let $\theta_s$ and $\theta_v$ denote the solar and viewing zenith angles, respectively, and $\phi_s$ and $\phi_v$ the corresponding azimuth angles. The relative azimuth angle is defined as

$$
\phi_r = \phi_v-\phi_s.
$$

The RTSOS geometry convention is summarized below:

| Quantity         | RTSOS definition       |
| ---------------- | ---------------------- |
| Solar zenith     | $\theta_s > 90^\circ$  |
| Solar azimuth    | $\phi_s=0$             |
| Viewing zenith   | $\theta_v < 90^\circ$  |
| Relative azimuth | $\phi_r=\phi_v-\phi_s$ |

Under this convention, the relative azimuth corresponds to the following scattering geometries:

| Condition    | Scattering geometry |
| ------------ | ------------------- |
| $\phi_r=0$   | forward scattering  |
| $\phi_r=\pi$ | backscattering      |

### Geometry Variables

For convenience, define the zenith-angle cosines as

$$
\mu_s = \cos\theta_s,
\qquad
\mu_v = \cos\theta_v.
$$

The corresponding sine terms are

$$
\sin\theta_s = \sqrt{1-\mu_s^2},
\qquad
\sin\theta_v = \sqrt{1-\mu_v^2}.
$$


### Scattering and Phase Angles

The scattering angle $\Theta$ between the illumination and viewing directions is

$$
\cos\Theta
=
\mu_s\mu_v
+
\sqrt{1-\mu_s^2}
\sqrt{1-\mu_v^2}
\cos\phi_r.
$$

The corresponding phase angle used in the BRDF formulation is

$$
\Theta_{\mathrm{phase}}
=
\pi-\Theta.
$$

## Ross Volumetric Kernel

The Ross volumetric kernel represents volumetric scattering within vegetation canopies [@Roujean:1992aa; @Wanner:1995aa; @Strahler:1999aa].

The RossThick volumetric kernel is

$$
K_{\mathrm{vol}}
=
\frac{
\left(
\frac{\pi}{2}-\Theta_{\mathrm{phase}}
\right)
\cos\Theta_{\mathrm{phase}}
+
\sin\Theta_{\mathrm{phase}}
}
{
|\mu_s|+|\mu_v|
}
-
\frac{\pi}{4}.
$$

The volumetric contribution to the surface BRDF is

$$
f_{\mathrm{vol}}K_{\mathrm{vol}}.
$$

## Li Geometric-Optical Kernel

The Li geometric-optical kernel represents shadowing and geometric effects associated with three-dimensional surface structures. RTSOS uses the Li-Sparse-Reciprocal formulation.

### Projected Zenith Angles

Define the tangent terms

$$
|\tan\theta_s|
=
\frac{\sqrt{1-\mu_s^2}}{|\mu_s|},
$$

and

$$
|\tan\theta_v|
=
\frac{\sqrt{1-\mu_v^2}}{|\mu_v|}.
$$

The projected zenith angles are

$$
\theta'_s
=
\tan^{-1}
\left(
\frac{B}{R}|\tan\theta_s|
\right),
$$

and

$$
\theta'_v
=
\tan^{-1}
\left(
\frac{B}{R}|\tan\theta_v|
\right),
$$

where $B/R$ is the vertical-to-horizontal crown-shape ratio.

### Projected Phase Angle

The projected phase angle $\xi$ is defined by

$$
\cos\xi
=
\cos\theta'_s\cos\theta'_v
+
\sin\theta'_s\sin\theta'_v
\cos(\phi_r+\pi).
$$

### Projected Distance

The projected distance is

$$
D
=
\sqrt{
\tan^2\theta'_s
+
\tan^2\theta'_v
-
2\tan\theta'_s\tan\theta'_v
\cos(\phi_r+\pi)
}.
$$

Define

$$
\sec\theta'_s
=
\frac{1}{\cos\theta'_s},
$$

and

$$
\sec\theta'_v
=
\frac{1}{\cos\theta'_v}.
$$

### Overlap Function

The auxiliary angle $t$ is determined from

$$
\cos t
=
\frac{H}{B}
\frac{
\sqrt{
D^2
+
\left[
\tan\theta'_s
\tan\theta'_v
\sin(\phi_r+\pi)
\right]^2
}
}{
\sec\theta'_s+\sec\theta'_v
}.
$$

If

$$
|\cos t|>1,
$$

the overlap function is set to

$$
O=0.
$$

Otherwise,

$$
O
=
\frac{1}{\pi}
(t-\sin t\cos t)
(\sec\theta'_s+\sec\theta'_v).
$$

### Li Geometric Kernel

The final geometric-optical kernel is

$$
K_{\mathrm{geo}}
=
O
-
\sec\theta'_s
-
\sec\theta'_v
+
\frac{1}{2}
(1+\cos\xi)
\sec\theta'_s
\sec\theta'_v.
$$

The geometric contribution to the surface BRDF is

$$
f_{\mathrm{geo}}K_{\mathrm{geo}}.
$$

## Polarized Surface Reflectance

The polarized bidirectional reflectance distribution function is based on Fresnel reflection following @Maignan:2009aa.

### Specular Incidence Angle

Using the scattering angle $\Theta$ defined above, the incidence angle corresponding to reflection from a locally flat surface is

$$
\theta_1
=
\frac{\pi-\Theta}{2}.
$$

This angle is used to evaluate the Fresnel reflection coefficients.

## Fresnel Reflection

Let the complex refractive index be

$$
n=n_r+i n_i.
$$

The amplitude reflection coefficient for parallel polarization is

$$
r_p
=
\frac{
n^2\cos\theta_1
-
\sqrt{n^2-\sin^2\theta_1}
}{
n^2\cos\theta_1
+
\sqrt{n^2-\sin^2\theta_1}
},
$$

and that for perpendicular polarization is

$$
r_s
=
\frac{
\cos\theta_1
-
\sqrt{n^2-\sin^2\theta_1}
}{
\cos\theta_1
+
\sqrt{n^2-\sin^2\theta_1}
}.
$$

The current implementation assumes

$$
n=1.5+0i.
$$

At normal incidence, the Fresnel reflectance can therefore be approximated as

$$
\left(\frac{n-1}{n+1}\right)^2
\approx 0.04.
$$

The Brewster-angle behavior is associated with the maximum polarization contrast represented by

$$
\frac{|A-B|}{A+B}.
$$

## Fresnel Mueller Matrix

Define

$$
A=\frac{1}{2}|r_p|^2,
$$

$$
B=\frac{1}{2}|r_s|^2,
$$

and

$$
\gamma=r_p^*r_s,
$$

where $r_p^*$ denotes the complex conjugate of $r_p$.

The Fresnel reflection Mueller matrix is

$$
\mathbf{F}
=
\begin{bmatrix}
A+B & A-B & 0 & 0 \\
A-B & A+B & 0 & 0 \\
0 & 0 & \operatorname{Re}(\gamma) & -\operatorname{Im}(\gamma) \\
0 & 0 & \operatorname{Im}(\gamma) & \operatorname{Re}(\gamma)
\end{bmatrix}.
$$

The element $F_{11}=A+B$ represents the scalar Fresnel reflectance.

## Polarization Kernel

The polarization kernel follows the formulation of @Maignan:2009aa:

$$
\mathbf{K}_{\mathrm{pol}}
=
\frac{
e^{-\tan\theta_1}
e^{-v_{\mathrm{fac}}}
}{
4(|\mu_s|+|\mu_v|)
}
\mathbf{L}(\pi-i_2)
\mathbf{F}(n,\theta_1)
\mathbf{L}(i_1),
$$

where $\mathbf{L}(i_1)$ rotates the Stokes vector from the incident meridian plane to the scattering plane, and $\mathbf{L}(\pi-i_2)$ rotates it from the scattering plane to the viewing meridian plane. The quantities $i_1$ and $i_2$ are the corresponding Stokes reference-plane rotation angles.

The empirical factor used in the current implementation is

$$
v_{\mathrm{fac}}=0.1.
$$

The magnitude of the polarized surface contribution is controlled by $B_{\mathrm{pol}}$:

$$
\mathbf{R}_{\mathrm{pol}}
=
B_{\mathrm{pol}}\mathbf{K}_{\mathrm{pol}}.
$$

The NDVI-dependent scaling included in the original BPDF formulation is absorbed into $B_{\mathrm{pol}}$ in the RTSOS implementation.

## Complete Surface Reflection Matrix

Combining the scalar Ross–Li BRDF and polarized BPDF components gives

$$
\mathbf{R}
=
\left[
f_{\mathrm{iso}}
+
f_{\mathrm{vol}}K_{\mathrm{vol}}
+
f_{\mathrm{geo}}K_{\mathrm{geo}}
\right]\mathbf{E}
+
B_{\mathrm{pol}}\mathbf{K}_{\mathrm{pol}}.
$$

Equivalently, using the scaled parameterization,

$$
\mathbf{R}
=
f_{\mathrm{iso}}(\lambda)
\left[
1
+
k_{\mathrm{vol}}K_{\mathrm{vol}}
+
k_{\mathrm{geo}}K_{\mathrm{geo}}
\right]\mathbf{E}
+
B_{\mathrm{pol}}\mathbf{K}_{\mathrm{pol}}.
$$

For scalar radiative transfer simulations, only the $R_{11}$ element is used.
