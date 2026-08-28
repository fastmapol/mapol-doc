# Aerosol Characterization: Component Approach
In the component approach, aerosols are represented by an external mixture of different components with assumed size distribution and refractive index spectra. The components are resolved in two size modes: fine mode and coarse mode. The fine mode aerosols consist of fine mode non-absorbing insoluble (FNAI), brown carbon (BrC), black carbon (BC) and fine mode non absorbing soluble (FNAS), whereas the coarse mode consists of sea salt (SS) and non-spherical dust (Dust). These components represent the most abundant marine aerosols found in the coastal environment and align with the aerosol components in chemical transport models such as Global Ozone Chemistry Aerosol Radiation and Transport (GOCART) model [^1]. 

Each aerosol component follows the lognormal size distribution:

$$
\frac{dV_i(r)}{d\ln r} = \frac{V_i}{\sigma_i\sqrt{2\pi}} \exp \left( - \frac{(\ln r - \ln r_i)^2}{2\sigma_i^2} \right)
$$

Where, $r_i$ and $\sigma_i$ represent the respective dry radius by volume and the standard deviation of a component with total volume column density $V_i$.

The components FNAI, BC and Dust are hydrophobic whereas SS and FNAS are hygroscopic and their growth factors are taken from Optical Properties of Aerosol and Clouds (OPAC) package [^2]. 50% of BrC are assumed to be hygroscopic, the rest being hydrophobic similar to organic carbon component of GOCART. The growth factors at different relative humidities are used in the single parameter growth equation from [^3] to obtain the parameter ($\gamma$) as:

$$
\frac{r_{RH}}{r_\circ} = \left(\frac{1}{1-RH}\right)^\frac{\gamma}{3}
$$

The parameter $\gamma$ solved from $r_{RH}/r_\circ$ at known RH values can be used to obtain the radius at any relative humidity ($r_{RH}$) from dry radius ($r_\circ$).

Polarimetric single scattering properties of spherical components are modeled using the Lorenz-Mie code developed by [^4]. The non-spherical dust properties are adopted from [^5]. The aerosol number density $N$ as a function of height $z$ is assumed to be gaussian with peak represented by aerosol layer height (ALH) [^6]:

$$
N(z) = A \exp\left(-4 \ln 2 \frac{(z-z_c)^2}{\sigma^2}\right)
$$

where $z_c$ is the aerosol layer height in km, $A$ is a normalizing factor determined from total aerosol loading and microphysical parameters, and $\sigma$ is the width of aerosol height distribution which is fixed at 2 km.

The aerosol retrieval parameters include total aerosol optical depth (AOD), aerosol layer height (ALH), fine mode fraction (FVF) and the volume fractions of four aerosol components (FNAI, BrC, BC, SS). The volume fractions of fine and coarse modes are normalized to one so that the volume fractions of FNAS and Dust are determined by FNAS = 1 - FNAI - BrC - BC and Dust = 1 - SS. The total volume fractions of each component are determined by multiplying them with FVF (fine mode) and 1 - FVF (coarse mode), respectively. The overall aerosol phase matrix is a sum of the fine and coarse modes weighted by FVF. The retrieved fractions along with RH is used in the single scattering calculation to obtain other aerosol optical propertis single scattering albedo (SSA) and Angstrom exponents (AE). For more details, readers are referred to the published papers [^7],[^8].

***
## References
[^1]: M. Chin, R. B. Rood, and S.-J. Lin et al., "Atmospheric sulfur cycle simulated in the global model gocart: Model description and global properties," *J. Geophys. Res.: Atmos.* 105(D20), 24671–24687 (2000).

[^2]: M. Hess, P. Koepke, and I. Schult, "Optical properties of aerosols and clouds: The software package opac," *Bull. Am. Meteorol. Soc.* 79(5), 831–844 (1998).

[^3]: S. Gasso, D. Hegg, and D. Covert et al., "Influence of humidity on the aerosol scattering coefficient and its effect on the upwelling radiance during ace-2," *Tellus B* 52(2), 546–567 (2000).

[^4]: M. I. Mishchenko, L. D. Travis, and A. A. Lacis, *Scattering, absorption, and emission of light by small particles* (Cambridge university press, 2002).

[^5]: Z. Meng, P. Yang, and G. W. Kattawar et al., "Single-scattering properties of tri-axial ellipsoidal mineral dust aerosols: A database for application to radiative transfer calculations," *J. Aerosol Sci.* 41(5), 501–512 (2010).

[^6]: L. Wu, O. Hasekamp, and B. van Diedenhoven et al., "Passive remote sensing of aerosol layer height using near-uv multiangle polarization measurements," *Geophys. Res. Lett.* 43(16), 8783–8790 (2016).

[^7]: Aryal, K., Zhai, P. W., Gao, M., Franz, B. A., Knobelspiesse, K., & Hu, Y. (2024). Machine learning based aerosol and ocean color joint retrieval algorithm for multiangle polarimeters over coastal waters. *Optics Express*, 32(17), 29921-29942.

[^8]: Aryal, K., Gao, M., Zhai, P. W., Franz, B. A., Knobelspiesse, K., Ibrahim, A., & Werdell, J. (2026). Aerosol and ocean color retrievals from FastMAPOL/component algorithm using NASA’s PACE polarimetric measurements. *Optics Express*, 34(16), 29139-29155.

