# Retrieval Algorithm: Inversion {#sec-retrieval-inversion}

FastMAPOL solves the retrieval as a constrained nonlinear least-squares optimization problem. The cost function is defined in @sec-retrieval and is restated here for completeness:

$$
\chi^2({\mathbf x})
=
\frac{1}{N}
\sum_i
\left[
\frac{[\rho_t(i)-\rho_t^f({\mathbf x};i)]^2}{\sigma_\rho^2(i)}
+
\frac{[P_t(i)-P_t^f({\mathbf x};i)]^2}{\sigma_P^2(i)}
\right].
$$

The state vector ${\mathbf x}$ contains the aerosol and surface parameters appropriate for the selected FastMAPOL retrieval configuration. Each parameter is constrained to a physically meaningful range during the inversion.

## Measurement and Forward-Model Uncertainties

The reflectance and DoLP uncertainties used to weight the cost function include contributions from instrument uncertainty, NN forward-model uncertainty, and radiative transfer simulation uncertainty:

$$
\sigma_\rho^2
=
\sigma_{\rho,\mathrm{ins}}^2
+
\sigma_{\rho,\mathrm{NN}}^2
+
\sigma_{\rho,\mathrm{RT}}^2,
$$ {#eq-sigma-rho}

and

$$
\sigma_P^2
=
\sigma_{P,\mathrm{ins}}^2
+
\sigma_{P,\mathrm{NN}}^2
+
\sigma_{P,\mathrm{RT}}^2.
$$ {#eq-sigma-P}

The NN forward-model uncertainties are determined during NN training and evaluation [@Gao:2021aa; @Gao:2023aa], with the current NN architectures and associated uncertainties summarized in @tbl-nn-arch. At present, these uncertainties are assumed to be spectrally and angularly uncorrelated.

## Nonlinear Least-Squares Optimization

FastMAPOL uses the **Trust Region Reflective (TRF)** nonlinear least-squares algorithm implemented in SciPy [@Branch:1999aa; @SciPy:2020aa]. The algorithm iteratively updates the state vector while enforcing the prescribed parameter bounds.

At iteration $j$, the NN forward model evaluates the simulated measurements for the current state vector ${\mathbf x}_j$. The Jacobian matrix,

$$
K_{mn}
=
\frac{\partial F_m}{\partial x_n},
$$ {#eq-retrieval-jacobian}

describes the sensitivity of each modeled measurement to each state parameter and is calculated efficiently through automatic differentiation.

The forward-model residuals and Jacobian are supplied to the nonlinear least-squares optimizer to determine the next update of the state vector. This process is repeated until convergence or until the maximum allowed number of iterations is reached.

## Convergence

The retrieval convergence is evaluated from the relative change in the cost function between successive iterations:

$$
\frac{|\chi_j^2-\chi_{j-1}^2|}
{\chi_j^2}
<
\eta,
$$ {#eq-delta-chi}

where $j$ is the iteration index and $\eta$ is the convergence tolerance. FastMAPOL uses $\eta=0.01$.

The converged state vector provides the retrieved aerosol and surface properties for the pixel. The solution is subsequently evaluated by the adaptive multi-angle data-screening procedure described in @sec-data-screening. If measurements are excluded during screening, another inversion is performed using the previous solution as the initial state.

## Interpretation of the Cost Function

The final cost function provides an overall measure of agreement between the observations and forward model relative to the assumed uncertainties. For an ensemble of retrievals, the distribution of the normalized cost function can be compared with the theoretical $\chi^2$ distribution [@Gao:2021bb]:

$$
f(\chi^2,k)
=
\frac{
(\chi^2)^{k/2-1}
k^{k/2}
\exp(-k\chi^2/2)
}{
2^{k/2}\Gamma(k/2)
}.
$$ {#eq-chi2-pdf}

Here, $k$ represents the number of degrees of freedom (DOF). When correlations among measurement uncertainties and the effects of retrieved parameters are neglected, the DOF can be approximated from the number of measurements. More generally, the effective DOF depends on the information content of the measurements and retrieved state parameters and can be evaluated using the Jacobian and error covariance matrices [@Gao:2021bb; @Gao:2023bb].