# Land: Surface Reflectance Model {#sec-land-model}

**Implementation status**

| Model | DITL | PACE V3 | PACE V4 | Evaluation | Planned |
| ----- | :--: | :-----: | :-----: | :--------: | :-----: |
| —     |   —  |    —    |    x    |      —     |    —    |

FastMAPOL NNs are trained from the RTSOS (@sec-rt-model) with the land surface reflectance model represents both the angular dependence and polarization of reflected radiation from the land surface. The model combines:

* the Ross–Li kernel-driven bidirectional reflectance distribution function (BRDF);
* a polarized bidirectional reflectance distribution function (BPDF); and
* Fresnel reflection physics.

The resulting surface reflection is represented by a **4 × 4 Mueller matrix** and is implemented in the PACE simulator for radiative transfer simulations.

Detailed geometry conventions and mathematical formulations of the individual kernels are provided in @sec-land-model-math.

## Surface Reflectance Representation

The bidirectional reflectance distribution matrix $\mathbf{R}$ converts the downwelling irradiance vector $\mathbf{F}_s$ to the reflected radiance vector $\mathbf{I}$:

$$
\mathbf{I}(\theta_v,\phi_v)
=
\frac{1}{\pi}
\mathbf{R}(\theta_s,\theta_v,\phi_r)
|\cos\theta_s|
\mathbf{F}_s(\theta_s,\phi_s),
$$

where $\theta$ and $\phi$ denote zenith and azimuth angles, respectively; subscripts $s$ and $v$ denote the incident and viewing directions; and

$$
\phi_r = \phi_v-\phi_s
$$

is the relative azimuth angle.

The surface reflection matrix is represented as

$$
\mathbf{R}(\theta_s,\theta_v,\phi_r)
=
\left[
f_{\mathrm{iso}}
+
f_{\mathrm{vol}}K_{\mathrm{vol}}
+
f_{\mathrm{geo}}K_{\mathrm{geo}}
\right]\mathbf{E}
+
B_{\mathrm{pol}}\mathbf{K}_{\mathrm{pol}},
$$

where

$$
\mathbf{E}
=
\begin{bmatrix}
1 & 0 & 0 & 0 \\
0 & 0 & 0 & 0 \\
0 & 0 & 0 & 0 \\
0 & 0 & 0 & 0
\end{bmatrix}.
$$

The first term represents the scalar Ross–Li BRDF and consists of three components:

* $f_{\mathrm{iso}}$: isotropic reflectance;
* $f_{\mathrm{vol}}K_{\mathrm{vol}}$: volumetric scattering, primarily representing vegetation-canopy effects; and
* $f_{\mathrm{geo}}K_{\mathrm{geo}}$: geometric-optical scattering associated with surface structure and shadowing.

The second term,

$$
B_{\mathrm{pol}}\mathbf{K}_{\mathrm{pol}},
$$

represents polarized surface reflection. The polarization kernel $\mathbf{K}_{\mathrm{pol}}$ is based on Fresnel reflection following @Maignan:2009aa, while $B_{\mathrm{pol}}$ controls its magnitude.

## FastMAPOL Parameterization

For parameter sampling and neural-network training, FastMAPOL uses a scaled representation that reduces the number of independent surface parameters:

$$
\mathbf{R}(\theta_s,\theta_v,\phi_r)
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

The corresponding Ross–Li coefficients are

$$
f_{\mathrm{vol}}(\lambda)
=
f_{\mathrm{iso}}(\lambda)k_{\mathrm{vol}},
$$

and

$$
f_{\mathrm{geo}}(\lambda)
=
f_{\mathrm{iso}}(\lambda)k_{\mathrm{geo}}.
$$

In this representation, $f_{\mathrm{iso}}(\lambda)$ is spectrally dependent, whereas $k_{\mathrm{vol}}$ and $k_{\mathrm{geo}}$ are assumed to be spectrally invariant.

The primary FastMAPOL surface parameters are:

| Parameter                   | Product variable | Description                              |
| --------------------------- | ---------------- | ---------------------------------------- |
| $f_{\mathrm{iso}}(\lambda)$ | `land_fiso`      | isotropic reflectance coefficient        |
| $k_{\mathrm{vol}}$          | `land_kvol`      | scaled volumetric-scattering coefficient |
| $k_{\mathrm{geo}}$          | `land_kgeo`      | scaled geometric-scattering coefficient  |
| $B_{\mathrm{pol}}$          | `land_bp`        | polarization scaling parameter           |

This parameterization allows the spectral magnitude of the land reflectance to vary through $f_{\mathrm{iso}}(\lambda)$ while describing its angular dependence using the spectrally invariant $k_{\mathrm{vol}}$ and $k_{\mathrm{geo}}$ parameters.

## White-Sky Albedo

The **white-sky albedo (WSA)**, also referred to as bihemispherical reflectance, represents the surface albedo under completely diffuse illumination. For the RossThick–LiSparse-Reciprocal BRDF model, WSA can be derived directly from the three BRDF kernel coefficients [@Strahler:1999aa]:

$$$
\alpha_{\mathrm{WSA}}
=
f_{\mathrm{iso}}
+
0.189184\,f_{\mathrm{vol}}
-
1.377622\,f_{\mathrm{geo}}.
$$ {#eq-white-sky-albedo}

The numerical factors represent hemispherical integrals of the corresponding Ross–Li kernels.

Unlike black-sky albedo, which depends on solar zenith angle, white-sky albedo is integrated over all illumination directions and therefore does not depend on a specific solar geometry. In the FastMAPOL MAPOL_LAND product suite, WSA is reported as `land_white_sky_albedo`.

## Polarized Surface Reflectance

The polarized component of land surface reflection is represented by a BPDF based on Fresnel reflection. The model uses the Fresnel Mueller matrix together with transformations between the incident meridian plane, scattering plane, and viewing meridian plane.

The current implementation assumes a surface refractive index of

$$$

n = 1.5 + 0i.

$$

For this refractive index, the normal-incidence Fresnel reflectance is approximately

$$

\left(\frac{n-1}{n+1}\right)^2 \approx 0.04.

$$

The magnitude of the polarized contribution is controlled by the retrieved parameter $B_{\mathrm{pol}}$.

The complete Fresnel formulation, Mueller matrix, polarization kernel, and reference-plane transformations are described in @sec-land-model-math.

For scalar radiative transfer simulations, only the $R_{11}$ element of the surface reflection matrix is used.
$$
