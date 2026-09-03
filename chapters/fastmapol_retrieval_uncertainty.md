# Retrieval: Input Uncertainty Model {#sec-retrieval-unc-model}

**Implementation status**

| Model | DITL | PACE V3 | PACE V4 | Evaluation | Planned |
| --- |:---:|:---:|:---:|:---:|:---:|
| HARP2 | x | x | x | — | — |
| SPEXone | — | x | x | — | — |

As discussed in @sec-retrieval and later in Appendix @sec-retrieval-inversion, measurement uncertainties are used to weight the observations in the retrieval cost function. The uncertainty model accounts for contributions from instrument measurement uncertainty, NN forward-model approximation, and numerical uncertainty in the radiative transfer (RT) simulations used to generate the NN training dataset.

The RT and NN contributions are evaluated based on factors such as the RT model configuration, the number of Gaussian quadrature points and scattering orders, and the size and performance of the NN training dataset [@Gao:2021aa].

Instrument measurement uncertainties depend on the characteristics and calibration performance of each instrument and are based on information provided by the instrument teams. For the current FastMAPOL retrievals used in all the previous versions and studies [@Gao:2021aa; Gao:2023aa; @Gao:2026aa], the following measurement uncertainties are adopted:

| Instrument | Reflectance uncertainty | DoLP uncertainty |
|---|---:|---:|
| HARP2 | 3% | 0.005 |
| SPEXone | 2% | 0.003 |

The reflectance uncertainty is specified as a relative uncertainty, whereas the DoLP uncertainty is specified as an absolute uncertainty. These values are used in constructing the measurement uncertainty terms that weight the corresponding observations in the retrieval cost function.

Note that above table denotes the current instrument uncertainty model used in the retrievals. These uncertainty models may be updated in the future to reflect changes in instrument characterization or calibration provided by the instrument teams.