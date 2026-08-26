# Multi-angle ocean color product

Ocean color signals are often represented by the remote sensing reflectance, $R_{rs}(\lambda;\theta_0, \theta_v, \phi_v)$, which is defined as the ratio of upwelling radiance originating from the ocean body to downwelling irradiance just above the ocean surface, with units of $\mathrm{sr}^{-1}$ [@Mobley:2016aa]. Here $\theta_0$ and $\theta_v$ are the solar and viewing zenith angles, and $\phi_v$ is the relative viewing azimuth angle. For simplicity, the wavelength dependence, $\lambda$, which applies to all ocean reflectance-related variables, is omitted in the following notation. To derive this quantity, we need to remove the atmospheric path radiance and compute the water-leaving reflectance ($\rho_w$) as the reflectance originating from scattering in the ocean that reaches the satellite sensor:

$$
\rho_w(\theta_0,\theta_v,\phi_v)
=
\rho_t(\theta_0,\theta_v,\phi_v)
-
\rho^{f}_{t,\mathrm{atm+sfc}}(\theta_0,\theta_v,\phi_v).
$$ {#eq-rhow}

where $\rho_t$ is the measured total reflectance at the top of atmosphere (TOA), and $\rho^{f}_{t,\mathrm{atm+sfc}}$ is the reflectance with only atmospheric and ocean surface contributions (such as sunglint, white caps, etc.) computed in the forward model, denoted by superscript $f$. With the multi-angle polarimetric observations provided by PACE, wind speed can be retrieved simultaneously with aerosol properties [@Gao:2021aa; @Gao:2022aa]. The joint retrieval algorithm enables the retrieval of ocean signals in regions affected by sunglint, which are often excluded or difficult to process using conventional single-angle ocean color remote sensing approaches [@Harmel:2013aa; @Neukermans:2018aa].

The remote sensing reflectance at arbitrary solar and viewing geometries can be derived from the water-leaving reflectance by considering the transmittance of both solar irradiance and surface radiance [@Gao:2021aa] as:

$$
R_{rs}(\theta_0,\theta_v,\phi_v)
=
\left[
\frac{\rho_w(\theta_0,\theta_v,\phi_v)}{\pi}
\right]
\times
\left[
\frac{1}
{T_d(\theta_0)\,t_u(\theta_0,\theta_v,\phi_v)}
\right].
$$ {#eq-rrs}

where $T_d$ represents the downwelling irradiance transmittance of the solar irradiance from the top of atmosphere to the surface, and $t_u$ represents the upwelling radiance transmittance for the water-leaving radiance from the bottom of atmosphere to the satellite sensor, with more details in @Gao:2021aa.

Furthermore, a BRDF correction procedure is commonly applied by mapping $R_{rs}(\theta_0, \theta_v, \phi_v)$ at arbitrary geometry to the sun at zenith and viewing angle at nadir, denoted as $R_{rs}(0,0)$. The reduction of the solar and viewing geometry angular dependency allows for geometrically consistent cross-instrument comparisons and validation with in-situ data. Based on the radiative transfer model used in this study, the BRDF correction factor can be computed through the modeled $R_{rs}^f$ as defined in Eqs. @eq-rhow and @eq-rrs by replacing the real measurement by the forward model simulation:

$$
C_{\mathrm{BRDF}}(\theta_0,\theta,\phi)
=
\frac{R^f_{rs}(0,0)}
{R^f_{rs}(\theta_0,\theta,\phi)}.
$$ {#eq-cbrdf}

The angular distribution of the water-leaving light field, and thus this correction term, depends on ocean parameters including Chl-a and wind speed, as well as aerosol properties that modulate the diffuse skylight. All of these parameters are retrieved simultaneously in the algorithm. Note that this is an extension of the previous model in @Gao:2021aa for smaller viewing zenith angles, and has been applied in synthetic PACE polarimeter data [@Gao:2023aa; @Aryal:2024aa; @Zhang:2025aa]. Such a correction can be applied to estimate $R_{rs}(0,0)$:

$$
R_{rs}(0,0)
=
R_{rs}(\theta_0,\theta,\phi)
\times
C_{\mathrm{BRDF}}(\theta_0,\theta,\phi).
$$ {#eq-rrs00}

To expedite this process, we further developed two neural networks which compute $1/(T_d t_u)$ and $C_{\mathrm{BRDF}}/(T_d t_u)$ as summarized in Appendix B, which can be used to efficiently produce $R_{rs}$ with and without BRDF correction.

Since HARP2 and SPEXone makes measurements at multiple viewing zenith angles in the along-track direction), we can apply the atmospheric correction to each of these and derive $R_{rs}$ with a new angle dimension. This satellite-based angular remote sensing reflectance contains information on oceanic particles and potentially also uncertainties from imperfect atmospheric correction. At first order, we can compute the angular mean and standard deviation. The mean value can be used to reduce random noise, while the standard deviation can be used to evaluate angular variability.

Moreover, if the satellite-derived $R_{rs}$ agrees with the modeled $R^f_{rs}$ from the forward model, assuming the bio-optical model accurately represents the real water properties, we would expect the angular variation of the $R_{rs}$ to be reduced by the BRDF correction. Therefore, BRDF correction applied on angular $R_{rs}$ can be used as an indicator of the closure of the radiative transfer model and atmospheric correction.

Multiple BRDF correction schemes have been proposed in the ocean color literature [@Morel:2002aa; @Park:2005aa; @Lee:2011aa; @He:2017aa; @Twardowski:2018aa; @Zhang:2025aa; @DAlimonte:2025aa; @Pitarch:2025aa]. The angular $R_{rs}$ observations provided by PACE from simultaneous multi-angle measurements can be used to evaluate these BRDF correction schemes across different water types, as well as angular closure analyses before and after BRDF correction on a pixel-by-pixel basis. For more details and validation results, please refer to @Gao:2026aa. 
