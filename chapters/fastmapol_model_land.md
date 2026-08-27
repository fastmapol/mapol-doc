# Land Surface Reflectance Model (Ross–Li BRDF and Polarized BPDF)

This document describes the mathematical formulation of the land surface reflectance model implemented in the **PACE simulator**. 

The model combines:
- Ross–Li kernel-driven BRDF  
- Polarized bidirectional reflectance distribution function (BPDF)  
- Fresnel reflection physics  

The output is a **4×4 Mueller matrix** describing polarized surface reflection.

## Surface Reflectance Model

The bidirectional reflectance distribution matrix $\mathbf{R}$ of land surface converts the downwelling irradiance vector $\mathbf{F}_s$ to upwelling radiance vector $\mathbf{I}$ by:

$$
\mathbf{I}(\theta_v,\phi_v)= \frac{1}{\pi}\mathbf{R}(\theta_s,\theta_v,\phi_r) \\, |\cos\theta_s| \\, \mathbf{F}_s(\theta_s,\phi_s) 
$$

where $\theta$ and $\phi$ are the zenith and azimuth angles, respectively; the subscripts $s$ and $v$ denote the incident and reflected directions, respectively; $\phi_r=\phi_v-\phi_s$ is the relative azimuth angle of the reflected and incident directions.

In the FastMAPOL algorithm the matrix $\mathbf{R}$ is modeled by:

$$
\mathbf{R}(\theta_s,\theta_v,\phi_r) =
\left[
f_{iso}
+
f_{vol} K_{vol}(\theta_s,\theta_v,\phi_r)
+
f_{geo} K_{geo}(\theta_s,\theta_v,\phi_r)
\right]\mathbf{E}
+
B_{pol}\mathbf{K}_{pol}
$$

where $\mathbf{E}$ is the 4 $\times$ 4 null matrix except for $E_{11}=1$,

$$
\mathbf{E} =
\begin{bmatrix}
1 & 0 & 0 & 0 \\
0 & 0 & 0 & 0 \\
0 & 0 & 0 & 0 \\
0 & 0 & 0 & 0
\end{bmatrix}
$$

$\mathbf{K}_{pol}$ is the polarization Kernel proportional to the Fresnel reflection matrix.

<!-- **Questions: why $|\cos\theta_s|$ is used here, how $\mathbf{R}$ is defined?**
## **I inserted a definition of R to explain the factor $|\cos\theta_s|$. pwzhai 03/26/2026 **
-->

### Scaled Parameter Formulation (Training Representation)

For parameter sampling (e.g., in neural network training), a scaled formulation is used to reduce the number of free parameters and capture main physics:

$$
\mathbf{R}(\theta_s,\theta_v,\phi_r) =
\left[
f_{iso}(\lambda)
\left(
1
+
k_{vol} K_{vol}
+
k_{geo} K_{geo}
\right)
\right]\mathbf{E}
+
B_{pol}\mathbf{K}_{pol}
$$

where 
- $f_{iso}(\lambda)$ is spectrally dependent, and
- $k_{vol}$ and $k_{geo}$ are spectrally invariant  

The relationship to the physical parameters is:

$$
f_{vol}(\lambda) = f_{iso}(\lambda) \times k_{vol}
$$

$$
f_{geo}(\lambda) = f_{iso}(\lambda) \times k_{geo}
$$

### Parameter Definitions

| Parameter | Description |
|---|---|
| $\theta_s$ | solar zenith angle |
| $\phi_s$ | solar azimuth angle |
| $\theta_v$ | viewing zenith angle |
| $\phi_v$ | viewing azimuth angle |
| $\phi_r=\phi_v-\phi_s$ | relative azimuth angle |
| $f_{iso}(\lambda)$ | isotropic reflectance coefficient |
| $f_{vol}(\lambda)$ | volumetric scattering coefficient |
| $f_{geo}(\lambda)$ | geometric scattering coefficient |
| $k_{vol}$ | scaled volumetric scattering coefficient |
| $k_{geo}$ | scaled geometric scattering coefficient |
| $B_{pol}$ | polarization scaling parameter |



### Geometry Definition

Define cosine terms:

$$
\mu_s = \cos\theta_s
$$

$$
\mu_v = \cos\theta_v
$$

Sine terms:

$$
\sin\theta_s = \sqrt{1-\mu_s^2}
$$

$$
\sin\theta_v = \sqrt{1-\mu_v^2}
$$

Relative azimuth:

$$
\phi_r = \phi_v - \phi_s
$$

### RTSOS Geometry Convention

The model follows the **RTSOS light ray convention**, i.e., the zenith and azimuth angles are associated with the directional vector of the ligh ray.

#### Geometry Definitions

| Quantity | RTSOS definition |
|---|---|
| solar zenith | $\theta_s > 90^\circ$ |
| solar azimuth | $\phi_s = 0$ |
| viewing zenith | $\theta_v < 90^\circ$ |
| relative azimuth | $\phi_r = \phi_v - \phi_s$ |

#### Scattering Planes

| Condition | Geometry |
|---|---|
| $\phi_r = 0$ | forward scattering |
| $\phi_r = \pi$ | backscattering |

#### Scattering Angle

The scattering angle between illumination and viewing directions is

$$
\cos\Theta =
\mu_s\mu_v +
\sqrt{1-\mu_s^2}\sqrt{1-\mu_v^2}\cos(\phi_r)
$$

The phase angle used in BRDF models is

$$
\Theta_{phase} = \pi - \Theta
$$

## Ross Volumetric Kernel

The volumetric kernel represents multiple scattering within vegetation canopies.

$$
K_{vol} =
\frac{\left(\frac{\pi}{2}-\Theta_{phase}\right)\cos\Theta_{phase} + \sin\Theta_{phase}}
{|\mu_s| + |\mu_v|}-\frac{\pi}{4}
$$

Reference: Roujean et al. (1992), JGR Atmosphere; Wanner et al. (1995), JGR.

## Li Geometric Kernel (Li-Sparse-R)

Define tangent terms:

$$
|\tan\theta_s| = \frac{\sqrt{1-\mu_s^2}}{|\mu_s|}
$$

$$
|\tan\theta_v| = \frac{\sqrt{1-\mu_v^2}}{|\mu_v|}
$$

Projected angles:

$$
\theta'_s = \tan^{-1}(B/R \cdot |\tan\theta_s|)
$$

$$
\theta'_v = \tan^{-1}(B/R \cdot |\tan\theta_v|)
$$

| Parameter | Meaning |
|---|---|
| $B/R$ | vertical-to-horizontal crown ratio |

### Projected Phase Angle

$$
\cos\xi =
\cos\theta'_s\cos\theta'_v +
\sin\theta'_s\sin\theta'_v\cos(\phi_r+\pi)
$$

### Projected Distance

$$
D =
\sqrt{
\tan^2\theta'_s +
\tan^2\theta'_v -
2\tan\theta'_s\tan\theta'_v\cos(\phi_r+\pi)
}
$$

Define:

$$
\sec\theta'_s = \frac{1}{\cos\theta'_s}
$$

$$
\sec\theta'_v = \frac{1}{\cos\theta'_v}
$$

### Ancillary Function <!-- (meaning?) -->

$$
\cos t =
\frac{H}{B}\frac{
\sqrt{
D^2 + (\tan\theta'_s\tan\theta'_v\sin(\phi_r+\pi))^2
}}
{\sec\theta'_s + \sec\theta'_v}
$$

If

$$
|\cos t| > 1
$$

then

$$
O = 0
$$

Otherwise

$$
O =
\frac{1}{\pi}(t - \sin t \\, \cos t)
(\sec\theta'_s + \sec\theta'_v)
$$

## Final Geometric Kernel

$$
K_{geo} = O - \sec\theta'_s - \sec\theta'_v + \frac{1}{2}(1+\cos\xi) \\, \sec\theta'_s \\,  \sec\theta'_v
$$

## Polarized Surface Reflectance (BPDF)

Scattering angle have been defined above $\Theta$. Assuming a flat surface which produce the same scattering angle, the incident angle relative to the flat surface would be: 

$$
\theta_1 =\frac{\pi - \Theta}{2}
$$

which also equivalent to $\theta_1=(\theta_s+\theta_v)/2$

### Fresnel Reflection

Let the refractive index be

$$
n = n_r + i n_i
$$

Parallel polarization:

$$
r_p =
\frac{n^2\cos\theta_1 - \sqrt{n^2-\sin^2\theta_1}}
{n^2\cos\theta_1 + \sqrt{n^2-\sin^2\theta_1}}
$$

Perpendicular polarization:

$$
r_s =
\frac{\cos\theta_1 - \sqrt{n^2-\sin^2\theta_1}}
{\cos\theta_1 + \sqrt{n^2-\sin^2\theta_1}}
$$

**Assumption: $n = 1.5 + 0i$ **

### Fresnel Mueller Matrix

$$
A = \frac{1}{2}|r_p|^2
$$

$$
B = \frac{1}{2}|r_s|^2
$$

$$
\gamma = r_p^* r_s
$$

$$
\mathbf{F} =
\begin{bmatrix}
A+B & A-B & 0 & 0 \\
A-B & A+B & 0 & 0 \\
0 & 0 & Re(\gamma) & -Im(\gamma) \\
0 & 0 & Im(\gamma) & Re(\gamma)
\end{bmatrix}
$$

Nadir reflectance (A+B) can be approximated as $[(n-1)/(n+1)]^2=0.04$ for n=1.5.
Brewster angle can be observed at the maximum of Abs(A-B)/(A+B).

### Polarization Kernel

In the current framework, we adopt the polarized Kernel based on Maignan et al., (2009):

$$
\mathbf{K}_{pol} =
\frac{
e^{-\tan\theta_1}e^{-v_{fac}}
}{4(|\mu_s|+|\mu_v|)}
\mathbf{L(\pi-i_2)}\mathbf{F} (n, \theta_1) \mathbf{L(i_1)}
$$

where $\mathbf{L(i_1)}$ and $\mathbf{L(\pi-i_2)}$ rotate the Stokes vector from the incident meridian plane to the scattering plane and back to the viewing meridian plane; $i_1$ and $i_2$ are the rotation angles; The factor $v_{fac}$ is:

$$
v_{fac} = 0.1
$$


<!-- This expression is redundant with R above. I suggest to delete it
### Final Surface Mueller Matrix
  
$$
\mathbf{M} =
\left[
f_{iso}
+
f_{vol}K_{vol}
+
f_{geo}K_{geo}
\right]
\mathbf{E}
+
B_{pol}\mathbf{K}_{pol}
$$


Note: The original formulation includes an NDVI factor in $\mathbf{K}_{pol}$ , which is absorbed into $B_{pol}$ .
-->

For scalar radiative transfer simulations, only $R_{11}$ is used.

---

## References

Maignan, F., et al., (2009)
*Polarized reflectances of natural surfaces: Spaceborne measurements and analytical modeling.*
Remote Sensing of Environment, Volume 113, Issue 12, Pages 2642-2650,
https://doi.org/10.1016/j.rse.2009.07.022.

MODIS Surface Reflectance ATBD  
https://modis.gsfc.nasa.gov/data/atbd/atbd_mod09.pdf

Roujean, J.-L., M.Leroy, and P.-Y.Deschamps (1992), A bidirectional reflectance model of the Earth's surface for the correction of remote sensing data, J. Geophys. Res., 97(D18), 20455–20468, doi:10.1029/92JD01411.

Wanner, W., Li, X., & Strahler, A. (1995)  
*On the derivation of kernels for kernel-driven BRDF models.*  
Journal of Geophysical Research.
