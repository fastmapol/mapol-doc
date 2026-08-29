# Retrieval Algorithm: Adaptive Multi-angle Data Screening {#sec-data-screening}

Within the FastMAPOL retrieval algorithm, an adaptive multi-angle data screening approach is implemented, which conducts automatic data quality analysis and data screening. A flowchart is summarized in Figure @fig-flowchart-screening B ((../figure/fig_data_screening.png). More details in the algorithm and applications are in @Gao:2021bb.

![Flowcharts for (A) FastMAPOL retrievals and (B) retrievals with the multi-angle polarimetric data screening (MAPDS).** In panel **(A)**, $\Delta\chi^2 = |\chi_i^2-\chi_{i-1}^2|$ indicates the changes of the cost function between two iterations with $\eta$ as threshold. In panel **(B)**, $\Delta\rho_t$ and $\Delta P_t$ indicate the difference between forward model and measurements for reflectance and DoLP with $\xi$ as threshold. The dashed box in **(B)** represents the same retrieval process as shown in the dashed box in **(A)**. A maximum three passes (indicated by the loop in **(B)**) are used in the data screening process.Figure is adopted from @Gao:2021bb](../figure/fig_data_screening.png){#fig-flowchart-screening width=80%}

After each converged FastMAPOL retrieval, the residuals between each measurement and the forward model prediction are used to evaluate the data quality under the criteria:

$$
\frac{|\Delta\rho_t|}{\sigma_\rho} < \xi,
\qquad
\frac{|\Delta P_t|}{\sigma_P} < \xi
$$

where the residuals are compared with the uncertainty model defined in the cost function, and $\xi$ is a threshold. When either the reflectance or DoLP does not satisfy the criteria, the corresponding measurement is excluded from the cost function calculation (i.e., the view angle which cannot be represented well by the forward model is removed), and a new FastMAPOL retrieval is performed. In practice, additional screening rules based on the criteria may be used depending on the data quality of the field measurements.

This process is repeated until all angles remaining satisfy above conditions. Note that the whole data screening process will include several retrieval passes, each involving multiple iterations until convergence. At the end of each retrieval pass based on the new forward model fittings, all measurements used in the retrieval are evaluated above and subsequently excluded from the next round if they failed to pass.

The data screening approach is an adaptive process, since it depends on the fitting at each iteration for each pixel. A threshold value of $\xi=3$ is used in this study, which can be further tuned when more data is available. We found at most three passes of retrievals are sufficient to remove most of the problematic angles. Since the retrieved parameters from last retrieval can be used as the initial values to the next retrieval, the total speed to conduct data screening are usually less than three times of the single round retrieval.