# Retrieval Algorithm: Inversion {#sec-retrieval-inversion}

FastMAPOL formulates the retrieval as a constrained nonlinear least-squares optimization problem. The cost function is defined in @sec-retrieval and is restated here for completeness:

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

Here, $\rho_t^f$ and $P_t^f$ are the NN forward-model predictions of reflectance and DoLP, respectively. The state vector $\mathbf{x}$ contains the aerosol and surface parameters for the selected FastMAPOL retrieval configuration, with each parameter constrained to a physically meaningful range.

The cost function can equivalently be written in matrix form as

$$
\chi^2
=
\frac{1}{N}
\left[
\mathbf{F}(\mathbf{x})-\mathbf{m}
\right]^T
\mathbf{S}_{\epsilon}^{-1}
\left[
\mathbf{F}(\mathbf{x})-\mathbf{m}
\right],
$$ {#eq-uq-cost}

where $\mathbf{m}$ is the measurement vector containing reflectance and DoLP observations from the available wavelengths and viewing angles, $\mathbf{F}(\mathbf{x})$ is the corresponding forward-model calculation, $N$ is the total number of measurements, and $\mathbf{S}_{\epsilon}$ is the measurement and forward-model error covariance matrix.

## Measurement and Forward-Model Uncertainties

The uncertainties used to weight the cost function account for contributions from the instrument, NN forward-model approximation, and numerical accuracy of the radiative transfer (RT) simulations used to generate the NN training data. For reflectance and DoLP, respectively,

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

Here, $\sigma_{\mathrm{ins}}$ represents the instrument measurement uncertainty, $\sigma_{\mathrm{NN}}$ represents the uncertainty introduced by the NN approximation of the forward model, and $\sigma_{\mathrm{RT}}$ represents the numerical uncertainty of the RT calculations.

The NN forward-model uncertainties are determined during NN training and evaluation [@Gao:2021aa; @Gao:2023aa], with the current NN architectures and associated uncertainties summarized in @tbl-nn-arch. In the current implementation, the uncertainties are assumed to be spectrally and angularly uncorrelated, such that $\mathbf{S}_{\epsilon}$ is diagonal.

## Nonlinear Least-Squares Optimization

As discussed in @Gao:2021aa, to minimize the cost function, FastMAPOL uses the **Subspace Trust-Region Interior Reflective (STIR)** method [@Branch:1999aa], implemented as the **Trust Region Reflective (TRF)** nonlinear least-squares algorithm in the Python SciPy package [@SciPy:2020aa]. The method iteratively solves for the state vector $\mathbf{x}$ while enforcing prescribed lower and upper bounds on the retrieved parameters.

STIR belongs to the family of trust-region least-squares methods and is closely related to the Levenberg–Marquardt approach [@More:1978aa], while extending the optimization to efficiently handle bound-constrained problems. The method provides good numerical stability near parameter boundaries, which is particularly important for FastMAPOL because many aerosol and surface parameters are restricted to physically meaningful or model-defined ranges.

The name **STIR** summarizes several key features of the optimization:

- **Subspace (S):** the optimization step can be determined within a reduced-dimensional subspace, improving computational efficiency for large optimization problems.
- **Trust Region (T):** the nonlinear cost function is locally approximated using the residuals and Jacobian, and the state-vector update is restricted to a region where this local approximation is considered reliable.
- **Interior (I):** the optimization maintains the state parameters within their prescribed bounds and uses their distances from the bounds in scaling the optimization problem.
- **Reflective (R):** reflected search directions are considered near parameter boundaries, allowing the optimization to continue efficiently within the feasible parameter space.

At each FastMAPOL iteration, the NN forward model calculates the simulated measurements and residuals for the current state vector. The Jacobian matrix,

$$
K_{ij}
=
\frac{\partial F_i}{\partial x_j},
$$ {#eq-retrieval-jacobian}

provides the sensitivity of each modeled measurement $F_i$ to each retrieved state parameter $x_j$.

The forward operation of the NN is defined in @sec-nn-model. During the forward pass, the intermediate values at each NN layer are stored and subsequently used to calculate the Jacobian through either forward-mode automatic differentiation (@tbl-ad-forward) or reverse-mode automatic differentiation (backpropagation; @tbl-ad-reverse).

The residuals and Jacobian are supplied to the TRF optimizer to determine the next update of the state vector. This process is repeated until the convergence criteria are satisfied or the maximum number of iterations is reached. 

## Convergence

FastMAPOL uses three convergence criteria in the TRF optimization, with a tolerance of 0.01 applied to each:

- `ftol = 0.01`, based on the change in the cost function;
- `xtol = 0.01`, based on the change in the state vector; and
- `gtol = 0.01`, based on the optimality condition determined from the cost-function gradient.

The optimization terminates when the corresponding SciPy TRF convergence criterion is satisfied. The resulting state vector provides the retrieved aerosol and surface properties for the pixel.

Following convergence, the retrieval is evaluated using the adaptive multi-angle data-screening procedure described in @sec-data-screening. If one or more measurements are excluded by the screening criteria, the inversion is repeated using the previous solution as the initial state. This screening and re-retrieval process continues until the screening criteria are satisfied or the maximum number of screening passes is reached.

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

Here, $k$ represents the number of degrees of freedom (DOF). When correlations among measurement uncertainties and the effects of retrieved parameters are neglected, the DOF can be approximated from the number of measurements. More generally, the effective DOF depends on the information content of the measurements and retrieved state parameters and can be evaluated using the Jacobian and error covariance matrices [@Gao:2021bb; @Gao:2023bb; @Gao:2026aa].