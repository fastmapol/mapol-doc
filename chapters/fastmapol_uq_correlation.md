# Uncertainty Quantifization: Angular Correlations {#sec-uq-correlation}

**Implementation status**

| DITL | PACE V3 | PACE V4 | Evaluation | Planned |
|:---:|:---:|:---:|:---:|:---:|
| - | - | - | ✓ | — |

Following the uncertainty quantification discussion in @sec-uq-theory, we discuss the general retrieval approach considering correlation between angles following [@Gao:2023bb]. The same maximum-likelihood approach is used to retrieve the state parameters in FastMAPOL by minimizing a cost function that represents the difference between the measurements and forward-model calculations but in a matrix as discussed in @sec-retrieval-inversion. We can further simplify the cost function expression as:

$$
\chi^2
=
\frac{1}{N}
\mathbf{y}^{T}
\mathbf{S}_{\epsilon}^{-1}
\mathbf{y},
$$ {#eq-chi2}

where

$$
\mathbf{y}
=
\mathbf{m}
-
\mathbf{f}(\mathbf{x})
$$

is the residual vector between the measurement vector $\mathbf{m}$ and forward model $\mathbf{f}$ for the state vector $\mathbf{x}$. The measurement vector $\mathbf{m}$ includes both reflectance ($\rho_t$) and DoLP ($P_t$), where the subscript $t$ indicates the total signal measured by the instrument. The total number of measurements, $N$, at each pixel includes contributions from both reflectance and DoLP [@Gao:2021aa; @Gao:2021bb].

The error covariance matrix $\mathbf{S}_{\epsilon}$ in @eq-chi2 specifies both the uncertainty of each measurement and correlations among measurements at the same pixel. It is a symmetric matrix defined as

$$
S_{\epsilon;i,j}
=
\mathbb{E}
\left[
(y_i-\mathbb{E}[y_i])
(y_j-\mathbb{E}[y_j])
\right],
$$ {#eq-covariance-definition}

where $i$ and $j$ indicate measurements at different viewing angles and spectral bands, and $\mathbb{E}$ denotes the expectation value.

To represent angular uncertainty correlations, an autoregressive model of order 1, denoted AR(1), is used. This approach was previously applied to RSP data [@Knobelspiesse:2012aa] and is adopted here for HARP data. AR(1) represents a linear Markov process with the error covariance matrix specified as

$$
S_{\epsilon;i,j}
=
\begin{cases}
\sigma_{t,i}^2,
& i=j, \\[4pt]
\sigma_{c,i}\sigma_{c,j}
r^{\Delta_\theta |i-j|},
& i\ne j \text{ and at the same band and polarization state}, \\[4pt]
0,
& \text{otherwise}.
\end{cases}
$$ {#eq-covariance}

where $\sigma_t$ is the total uncertainty, including both random noise and calibration uncertainty ($\sigma_c$). Only $\sigma_c$ is assumed to be correlated among measurements at different viewing angles.

The relative contributions of random and calibration uncertainties may differ between reflectance and polarized signals [@Knobelspiesse:2019aa]. For synthetic data generated directly using the forward model, the contribution of forward-model uncertainty is not considered. $\Delta_\theta$ is the average angular grid spacing and depends on the spectral channel. We model the correlation properties using $\Delta_\theta$ estimated from the viewing angles in the along-track direction to better represent the stripe-filter characteristics used for HARP angular measurements.

The average $\Delta_\theta$ is approximately $6.0^\circ$ for AirHARP and $12^\circ$ for HARP2 at 440, 550, and 870 nm, and approximately $2.0^\circ$ at 670 nm for both HARP instruments. The parameter $r$ in @eq-covariance is the correlation parameter, with a value between 0 and 1. For uncertainties with more complex structures, a general autoregressive moving-average (ARMA) model can be used [@Priestley:1983aa]. However, analysis of retrieval results from real AirHARP measurements indicates that the AR(1) model provides a useful representation for most cases.

To provide a more intuitive representation of strong correlations as $r$ approaches 1, we define a correlation angle $\theta_c$ according to

$$
r^{\Delta_\theta |i-j|}
=
e^{-\Delta_\theta |i-j|/\theta_c}.
$$ {#eq-correlation-angle}

Therefore, $\theta_c$ represents the angular separation over which the magnitude of the correlation is reduced by a factor of $e$. The correlation angle can be derived from $r$ as

$$
\theta_c
=
-\frac{1}{\ln r}.
$$ {#eq-thetac2r}

## Uncertainty Quantifization
Pixel-wise retrieval uncertainty can be quantified by propagating measurement and forward-model uncertainties into the retrieval parameter space [@Rodgers:2000aa]:

$$
\mathbf{S}^{-1}
=
\mathbf{K}^{T}
\mathbf{S}_{\epsilon}^{-1}
\mathbf{K}
+
\mathbf{S}_{a}^{-1},
$$ {#eq-S}

where the Jacobian matrix $\mathbf{K}$ contains the partial derivatives of the modeled measurements with respect to the retrieval parameters.

Each retrieval parameter is constrained to a finite permitted range, which imposes an implicit a priori constraint on the retrieval. To represent its influence on retrieval uncertainties, the a priori error covariance matrix $\mathbf{S}_a$ in @eq-S is assumed to be diagonal, with the a priori uncertainty for each state parameter approximated by its permitted retrieval range [@Gao:2022aa].

The uncertainties are defined as the standard deviation ($1\sigma$) around the retrieval solution and are estimated from the square roots of the diagonal elements of $\mathbf{S}$. Uncertainties for variables that are functions of the retrieved state parameters can similarly be derived from $\mathbf{S}$ and the corresponding derivatives.

Because FastMAPOL retrieves a relatively large number of state parameters, direct evaluation of retrieval uncertainties can be computationally expensive. The uncertainty calculation is accelerated using automatic differentiation applied to the neural network forward models [@Gao:2022aa]. For example, the uncertainty in remote sensing reflectance ($R_{rs}$) can be propagated using automatic differentiation through the neural networks used for atmospheric and BRDF corrections.

The retrieval uncertainties estimated through error propagation in @eq-S, hereafter referred to as **theoretical retrieval uncertainties**, represent an optimalized local estimate and rely on assumptions such as successful convergence of the retrieval parameters to the appropriate solution [@Sayer:2020aa; @Gao:2022aa]. If the retrieval solution differs substantially from the true state, both the retrieved state and its associated Jacobian may be less representative of the true conditions, potentially leading to inaccurate uncertainty estimates.

For synthetic retrieval experiments, the retrieval error can be calculated directly as the difference between the retrieved and true values. The statistical distribution of these retrieval errors is referred to here as the **real retrieval uncertainty**. Comparing theoretical and real retrieval uncertainties provides a means of evaluating the optimal and actual performance of the retrieval algorithm.

The Monte Carlo error propagation (MCEP) method is used for this comparison [@Gao:2022aa]. MCEP samples retrieval errors from the theoretical retrieval uncertainty distributions and directly compares these sampled error distributions with errors obtained from the actual retrievals. Multiple sets of random samples can be generated to evaluate the influence of sample size on the estimated uncertainty statistics [@Gao:2022aa].

## Eigenvector decomposition of the error covariance matrix {#sec-transform}

An error covariance matrix with non-diagonal terms can be challenging to implement efficiently in optimization algorithms, which often operate most conveniently in a space with uncorrelated measurement errors. Correlated measurement uncertainties can also be difficult to interpret because individual uncertainty components are associated with multiple measurements. To address these issues, the measurements can be transformed into a new space in which the error covariance matrix is diagonal.

Eigenvector decomposition is applied to the error covariance matrix [@Rodgers:2000aa]:

$$
\mathbf{S}_{\epsilon}
=
\mathbf{U}^{T}
\mathbf{D}_{\epsilon}
\mathbf{U},
$$ {#eq-svd}

where $\mathbf{D}_{\epsilon}$ is a positive diagonal matrix containing the eigenvalues of $\mathbf{S}_{\epsilon}$ and $\mathbf{U}$ is a unitary matrix.

Based on @eq-svd, the cost function in @eq-chi2 and the error propagation in @eq-S can be written as

$$
\chi^2
=
\frac{1}{N}
\mathbf{y}'^{T}
\mathbf{D}_{\epsilon}^{-1}
\mathbf{y}',
$$ {#eq-chi2-new}

and

$$
\mathbf{S}^{-1}
=
\mathbf{K}'^{T}
\mathbf{D}_{\epsilon}^{-1}
\mathbf{K}'
+
\mathbf{S}_{a}^{-1},
$$ {#eq-S-new}

where the original residual vector $\mathbf{y}$ is transformed to a new residual vector $\mathbf{y}'$ with uncorrelated uncertainties, together with the corresponding Jacobian matrix:

$$
\mathbf{y}'
=
\mathbf{U}\mathbf{y},
$$ {#eq-y-transform}

$$
\mathbf{K}'
=
\mathbf{U}\mathbf{K}.
$$ {#eq-K-transform}

The transformations in @eq-chi2-new and @eq-S-new allow the retrieval to operate with diagonal uncertainty matrices and provide several advantages:

1. **Clear representation of measurement uncertainty.**  
   The diagonal elements of $\mathbf{D}_{\epsilon}$ represent the uncertainties of the transformed measurements $\mathbf{y}'$, providing insight into how measurement accuracy is affected by correlations.

2. **Efficient minimization of the retrieval cost function.**  
   @eq-chi2-new represents the cost function for the uncorrelated transformed measurements $\mathbf{y}'$ and can therefore be used directly with conventional optimization algorithms, such as the subspace trust-region interior-reflective (STIR) algorithm [@Branch:1999aa], as implemented in FastMAPOL [@Gao:2021aa; @Gao:2021bb; @Gao:2022aa].

3. **Generation of correlated errors.**  
   To investigate and visualize angular uncertainty correlations, errors can first be generated in the transformed $\mathbf{y}'$ space by drawing random samples from normal distributions whose variances are defined by the eigenvalues in $\mathbf{D}_{\epsilon}$. These errors are then transformed back into the original measurement space according to

   $$
   \mathbf{y}
   =
   \mathbf{U}^{T}\mathbf{y}'.
   $$ {#eq-y-inverse-transform}

   This procedure enables synthetic measurement errors with prescribed angular correlation structures to be generated and added to simulated measurements.


## Correlation strength estimation using autocorrelation {#sec-ac}

Autocorrelation provides a useful measure of correlation in a discrete data sequence and is defined as [@Priestley:1983aa]

$$
R_{i,j}
=
\mathbb{E}[y_i y_j],
$$ {#eq-autocorrelation}

where $i$ and $j$ are two indices of the dataset. Comparing @eq-autocorrelation with @eq-covariance-definition, the autocorrelation is equivalent to the autocovariance when $\mathbb{E}[y_i]=0$.

This method can be applied to simulated noise and to retrieval fitting residuals. However, the mean and variance of the fitting residuals can vary with viewing angle. Such signals are non-stationary and are difficult to represent directly using AR models [@Priestley:1983aa]. To reduce this effect, the original residual vector $\mathbf{y}$ is processed by removing its mean and normalizing by its standard deviation. The resulting normalized residual is denoted by $\tilde{\mathbf{y}}$.

For measurements within the same spectral band and polarization state, the autocorrelation function of the normalized residuals is equivalent to the covariance defined in @eq-covariance:

$$
\tilde{R}_k
=
\mathbb{E}
\left[
\tilde{y}_i
\tilde{y}_{i+k}
\right]
=
r^{\Delta_\theta k}.
$$ {#eq-rk}

The correlation strength can therefore be estimated by analyzing the residuals between the measurements and forward-model calculations. The autocorrelation function is averaged over multiple pixels to reduce statistical uncertainty. The correlation parameter can then be estimated as

$$
r
=
\left(\tilde{R}_1\right)^{1/\Delta_\theta}.
$$ {#eq-r-from-ac}

The corresponding correlation angle $\theta_c$ is calculated from $r$ using @eq-thetac2r.

A partial autocorrelation function can also be calculated from the data sequence. Partial autocorrelation removes correlations associated with intermediate lags and can therefore be used to evaluate whether an AR(1) model adequately represents the uncertainty structure [@Priestley:1983aa]. If AR(1) is sufficient, only the first-order lag should remain prominent beyond the zero-order term. The Python packages StatsModels [@Seabold:2010aa] and SciPy [@Virtanen:2018aa] are used to conduct the autocorrelation analyses.