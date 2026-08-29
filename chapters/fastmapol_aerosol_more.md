# Aerosol Characterization : More discussions
## Sensitivity to component volume

To propagate retrieval uncertainty from mode volumes to bulk effective properties, derivatives with respect to $V_j$ are required.

For effective radius,

$$
\frac{\partial r_{eff}}{\partial V_{j}} =
\frac{1}{\sum_i  m_{2,i}}\frac{\partial m_{3,j}}{\partial V_j}- 
\frac{\sum_i m_{3,i}}{(\sum_i m_{2,i})^2}\frac{\partial m_{2,j}}{\partial V_j},
$$

which can be written as

$$
\frac{\partial r_{eff}}{\partial V_{j}} =
r_{eff} \left(\frac{m'_{3,j}}{\sum_i  m_{3,i}}-\frac{m'_{2,j}}{\sum_i  m_{2,i}}\right).
$$

For effective variance,

$$
\frac{\partial \nu_{eff}}{\partial V_j}=
\frac{\sum_i m_{2,i}}{(\sum_i m_{3,i})^2}\frac{\partial m_{4,j}}{\partial V_j}+
\frac{\sum_i m_{4,i}}{(\sum_i m_{3,i})^2}\frac{\partial m_{2,j}}{\partial V_j}
-2\frac{\sum_i m_{4,i} \sum_i m_{2,i}}{(\sum_i m_{3,i})^3}\frac{\partial m_{3,j}}{\partial V_j},
$$

or equivalently

$$
\frac{\partial \nu_{eff}}{\partial V_j}=
(\nu_{eff}+1) \left(\frac{m'_{4,j}}{\sum_i  m_{4,i}}+\frac{m'_{2,j}}{\sum_i m_{2,i}} 
-2\frac{m'_{3,j}}{\sum_i  m_{3,i}}\right).
$$

Here the derivative of the moment with respect to component volume is

$$
m'_{k,j}=\frac{\partial m_{k,j}}{\partial V_j}=\frac{m_{k,j}}{V_j},
$$

which gives

$$
m'_{k,j}=\frac{3}{4 \pi}
r^{k-3}_{v,j} \exp\left[\frac{(k-3)^2}{2} \sigma_j^2\right].
$$

For $k=3$, this derivative is constant because $m_3$ depends linearly on volume and not on radius.

## Physical interpretation of low-order moments

For a volume-based log-normal mode, the low-order moments are

$$
m_{2,i}=\frac{3}{4\pi} V_i r_{v,i}^{-1} \exp(\sigma_i^2/2),
$$

$$
m_{3,i}=\frac{3}{4\pi} V_i,
$$

$$
m_{4,i}=\frac{3}{4\pi} V_i r_{v,i} \exp(\sigma_i^2/2).
$$

For a single mode, these lead directly to

$$
r_{eff}=\frac{m_3}{m_2}=r_v \exp(-\sigma^2/2),
$$

$$
\nu_{eff}=\frac{m_4 m_2}{m_3^2}-1=\exp (\sigma^2)-1.
$$

For a multimode aerosol,

$$
\sum_i m_{3,i}=\frac{3}{4\pi}\sum_i V_i=\frac{3}{4\pi} V_0,
$$

so the summed third moment is proportional to the total particle volume.

Within a fine-mode or coarse-mode subset, $m_2$ emphasizes smaller particles, whereas $m_4$ emphasizes larger particles. This makes effective radius and effective variance sensitive to the relative partitioning among submodes, even when the logarithmic standard deviation is fixed within that subset.

## Additional notes on units

The column number density may also be written as

$$
N_0=n_0 \delta l,
$$

where $\delta l$ is the aerosol layer thickness.

In log-normal expressions, the absolute unit of radius does not matter as long as $r$ and the mean radius use the same unit, since

$$
\ln r-\ln r_m=\ln(r/r_m).
$$

Both the logarithmic variance and the effective variance are dimensionless.


## Optical depth at different wavelengths

If the aerosol loading is parameterized at a reference wavelength, such as $555 \, nm$, then the corresponding number density can be defined as

$$
n_i=\frac{\tau_{555nm}}{C_{ext,555nm}}.
$$

The optical depth at any other wavelength is then

$$
\tau_{\lambda}=n_i C_{ext,\lambda}.
$$

This relation is useful when the state variable is defined through reference-wavelength optical depth while the forward model requires spectrally varying extinction.


## Phase-matrix averaging

The total number density may be represented as a weighted sum of component size distributions,

$$
n(r)=\sum_i c_i n_i(r),
$$

with

$$
\sum_i c_i =1.
$$

The corresponding size-averaged phase matrix is then

$$
P(\Omega)_{avg}=\int d r \, n(r) P(\Omega;r),
$$

which can be expanded as

$$
P(\Omega)_{avg}= \sum_i c_i \int d r \, n_i(r) P(\Omega;r)
$$

and written as

$$
P(\Omega)_{avg}= \sum_i c_i P_i (\Omega).
$$

If $P_i$ denotes the size-averaged phase matrix of component $i$, then the total phase matrix is a weighted sum over components. If normalized phase matrices $\tilde{P}_i$ are used, then the weighting must be consistent with the corresponding scattering cross sections.

In practice, this requires confirming the normalization convention of the scattering subroutine, such as `spher_interface`.