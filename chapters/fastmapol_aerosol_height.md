# Aerosol vertical profile and height {#sec-aerosol-height}

This chapter provide the vertical aerosol model, definition of aerosol layer height as discussed in @Gao:2023aa. More discussion on the retrieval uncertainties of the aerosol layer height can be found at @Gao:2023aa with dependencies on aerosol loading. 

As discussed in previous chapters, the forward radiative transfer simulations are conducted assuming a coupled atmosphere and ocean system. The atmospheric molecule distributions follow the US standard atmospheric constituent profile [@Anderson:1986aa]. An aerosol layer is considered with a vertical number density distribution assumed as a Gaussian function [@Wu:2015], as discussed in :

$$
f(z) = A
\exp\left[
-\frac{(z-z_{\mathrm{c}})^2}{2\sigma^2}
\right],
$$

where $A= N_t/(\sigma \sqrt{2 \pi})$, $N_t$ is the total aerosol column number density. $z_{\mathrm{c}}$ is the peak height and $\sigma$ is the standard deviation. For FastMAPOL V3 and V4 processing, a FWHM of 2 km is used, which corresponds to

$$
\sigma =
\frac{\mathrm{FWHM}}{2\sqrt{2\ln 2}}
=
\frac{2}{2\sqrt{2\ln 2}}
\approx 0.849~\mathrm{km}.
$$

Note that ALH can be different in different ways. A common definition is defined the height as extinction or backscattering weighted height. For our case, where the vertical profile is uniform, a simple profile-weighted mean height can be calculated as

$$
\bar{z} =
\frac{\displaystyle\int_{0}^{50} z\,f(z)\,dz}
{\displaystyle\int_{0}^{50} f(z)\,dz},
$$

where $f(z)$ represents the aerosol vertical profile and $z$ is the altitude.


Note that there is a caveat here: we follow the methodology from Wu et al 2015 (https://agupubs.onlinelibrary.wiley.com/doi/10.1002/2016GL069848), where he define the Gaussian profile as $$
f(z) = A \exp\left[
-4\ln(2)\frac{(z-z_c)^2}{\sigma'^2}
\right],
$$

where $A$ is the normalization factor, $z_c$ is the center (peak) height of the aerosol layer, and $\sigma'$ is the width of the aerosol height distribution, which is actually FWHM, not standard deviation. Wu et al. (2016) then recommend the use of $\sigma' = 2$ km. We use symbol $\sigma'$ rather than $\sigma$ here to indicate the difference from previous equation.

But in Gao et al 2023, paper, we rewrite the vertical profile following the regular Gaussian profile,
$$
f(z) = A
\exp\left[
-\frac{(z-z_{\mathrm{c}})^2}{2\sigma^2}
\right],
$$
where sigma should be regular standard deviation. That means for FWHM=2km, the actual value of sigma should be $\sigma =
\frac{\mathrm{FWHM}}{2\sqrt{2\ln 2}}=0.85km$ as discussed above.