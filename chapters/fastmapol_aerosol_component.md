# Aerosol: Component Approach {#sec-aerosol-component}

**Implementation status**

| DITL | PACE V3 | PACE V4 | Evaluation | Planned |
|:---:|:---:|:---:|:---:|:---:|
| — | — | — | ✓ | — |

In the aerosol component approach, aerosols are represented by an external mixture of different components with assumed size distribution and refractive index spectra. The components are resolved in two size modes: fine mode and coarse mode. The fine mode aerosols consist of fine mode non-absorbing insoluble (FNAI), brown carbon (BrC), black carbon (BC) and fine mode non absorbing soluble (FNAS), whereas the coarse mode consists of sea salt (SS) and non-spherical dust (Dust). These components represent the most abundant marine aerosols found in the coastal environment and align with the aerosol components in chemical transport models such as Global Ozone Chemistry Aerosol Radiation and Transport (GOCART) model [@Chin:2000aa]. 

Each aerosol component follows the lognormal size distribution:

$$
\frac{dV_i(r)}{d\ln r} = \frac{V_i}{\sigma_i\sqrt{2\pi}} \exp \left( - \frac{(\ln r - \ln r_i)^2}{2\sigma_i^2} \right)
$$

Where, $r_i$ and $\sigma_i$ represent the respective dry radius by volume and the standard deviation of a component with total volume column density $V_i$.

The components FNAI, BC and Dust are hydrophobic whereas SS and FNAS are hygroscopic and their growth factors are taken from Optical Properties of Aerosol and Clouds (OPAC) package [@Hess:1998aa]. 50% of BrC are assumed to be hygroscopic, the rest being hydrophobic similar to organic carbon component of GOCART. The growth factors at different relative humidities are used in the single parameter growth equation from [@Gasso:2000aa] to obtain the parameter ($\gamma$) as:

$$
\frac{r_{RH}}{r_\circ} = \left(\frac{1}{1-RH}\right)^\frac{\gamma}{3}
$$

The parameter $\gamma$ solved from $r_{RH}/r_\circ$ at known RH values can be used to obtain the radius at any relative humidity ($r_{RH}$) from dry radius ($r_\circ$).

Polarimetric single scattering properties of spherical components are modeled using the Lorenz-Mie code developed by @Mishchenko:2002aa. The non-spherical dust properties are adopted from @Meng:2010aa. The aerosol number density $N$ as a function of height $z$ is assumed to be gaussian with peak represented by aerosol layer height (ALH) [@Wu:2016aa], following the discussion in @sec-aerosol-height, assuming FWHM is fixed at 2 km. 

The aerosol retrieval parameters include total aerosol optical depth (AOD), aerosol layer height (ALH), fine mode fraction (FVF) and the volume fractions of four aerosol components (FNAI, BrC, BC, SS). The volume fractions of fine and coarse modes are normalized to one so that the volume fractions of FNAS and Dust are determined by FNAS = 1 - FNAI - BrC - BC and Dust = 1 - SS. The total volume fractions of each component are determined by multiplying them with FVF (fine mode) and 1 - FVF (coarse mode), respectively. The overall aerosol phase matrix is a sum of the fine and coarse modes weighted by FVF. The retrieved fractions along with RH is used in the single scattering calculation to obtain other aerosol optical propertis single scattering albedo (SSA) and Angstrom exponents (AE). For more details, readers are referred to the published papers [@Aryal:2024aa;@Aryal:2026aa].

