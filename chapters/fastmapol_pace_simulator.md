# Radiative Transfer Model {#sec-rt-model}

The Radiative Transfer model is based on the Successive Order of Scattering (RTSOS) method [@Zhai:2009aa; @Zhai:2010aa].

Key features:
- RTSOS is capable of solving polarized radiative transfer for both atmosphere-ocean and atmosphere-land systems. 
- In atmosphere-ocean systems, it can also simulate inelastic scattering processes, including Raman scattering and fluorescence by chlorophyll and colored dissolved organic matter [@Zhai:2015aa; @Zhai:2017aa].
- An improved pseudos-spherical shell (IPSS) algorithm is used to improve the simulation of radiance field over polar regions [@Zhai:2022aa]. More details are in @sec-rt-shell. 

For this work, RTSOS is configured to simulate polarized radiance fields for randomly generated Earth systems for the PACE instruments [@Zhai:2022aa]. The data are then used to train neural network forward models, which emulates the behavior of the radiative transfer system.

**Code repository**
The RTSOS is made public by Dr. Pengwang Zhai in github.
