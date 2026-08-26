# Neural network forward model and Analytical Jacobian

The MAP retrievals are often computationally expensive due to their high dimensionality and iterative nature, with multiple forward model and Jacobian calculations. The data screening approach developed here further increases the demand for CPU computations because the retrieval must be repeated several times. Therefore, fast forward model and Jacobian matrix calculations are advantageous for efficient processing, which was a motivation for the use of NN forward models for AirHARP in @Gao:2021aa. In this work, we provide the definition of the NN and the use of automatic differentiation to compute the Jacobian matrix analytically (as opposed to numerically through finite differencing), exploiting the differentiable properties of the NN models. For details on the NN training strategies, please refer to @Gao:2023aa and @Gao:2021aa.

The NN forward model developed in @Gao:2021aa is a feed-forward neural network as defined in @tbl-nn-forward, where ${\bf h}_0={\bf x}$ is the input layer that contains all 15 forward model parameters. Two sets of weight matrices ${\bf W}_{p+1}$ and bias vectors ${\bf b}_{p+1}$ have been determined from the NN training process for reflectance and DoLP, respectively [@Gao:2021aa; @Gao:2023aa].

Correspondingly, ${\bf y}$ is the output layer for either reflectance or DoLP at the four AirHARP bands.

For application to multi-angle measurements, the NN needs to be called to simulate ${\bf y}$ for each set of viewing and solar geometries for the state vector ${\bf x}$. Elements of the Jacobian matrix are defined as follows:

$$
{\bf K}_{mij}
=
\frac{\partial {\bf y}_{mi}}
{\partial {\bf x}_{mj}}
$$ {#eq-jacobian}

Here index $m$ indicates the viewing and solar angles, index $i$ indicates the wavelength, and index $j$ indicates the state parameter. @tbl-nn-forward illustrates the structure of the NN. The nonlinear activation function $\Phi$ is the LeakyReLU function, which is defined as

$$
\Phi({\bf Z})_{mi}
=
\max(0,{\bf Z}_{mi})
+
\alpha \times \min(0,{\bf Z}_{mi}).
$$ {#eq-leakyrelu}

where $\alpha=0.01$, and ${\bf Z}$ is a matrix with $m$ and $i$ as its indices. The derivative with respect to each element in $\Phi$ is defined as

$$
{\bf D}_{mi}
=
\frac{\Phi({\bf Z})_{mi}}{{\bf Z}_{mi}}
=
\begin{cases}
1, & {\bf Z}_{mi}>0 \\
\alpha, & {\bf Z}_{mi}<0
\end{cases}
$$ {#eq-D}


### NN Forward Model

| **Layers** | **NN forward model** |
|---|---|
| Input | ${\bf h}_0={\bf x}$ |
| Layer 1 | ${\bf h}_1=\Phi({\bf W}_1^T{\bf h}_0+{\bf b}_1)$ |
| Layer $p+1$ | ${\bf h}_{p+1}=\Phi({\bf W}_{p+1}^T{\bf h}_p+{\bf b}_{p+1})$ |
| Output | ${\bf y}={\bf W}_{k+1}^T{\bf h}_k+{\bf b}_{k+1}$ |

: NN forward model. {#tbl-nn-forward}


### AD: Forward Mode

| **Layers** | **AD: Forward mode** |
|---|---|
| Input | ${\bf \dot{h}}_{0,mij}=\delta_{ij}$ |
| Layer 1 | ${\bf \dot{h}}_{1,mij}={\bf D}_{1,mi}{\bf W}_{1,ij}^T$ |
| Layer $p+1$ | ${\bf \dot{h}}_{p+1,mij}={\bf D}_{p+1,mi}{\bf W}_{p+1,il}^T{\bf \dot{h}}_{p,mlj}$ |
| Output | ${\bf K}_{mij}={\bf \dot{y}}_{mij}={\bf W}_{k+1,il}^T{\bf \dot{h}}_{k,mlj}$ |

: Jacobian matrix computed using forward-mode automatic differentiation (AD). {#tbl-ad-forward}


### AD: Reverse Mode

| **Layers** | **AD: Reverse mode** |
|---|---|
| Output | ${\bf \bar{y}}_{mij}={\bf W}_{k+1,ij}^T$ |
| Layer $p+1$ | ${\bf \bar{h}}_{p,mij}={\bf \bar{h}}_{p+1,mil}{\bf D}_{p+1,ml}{\bf W}_{p+1,lj}^T$ |
| Layer 1 | ${\bf \bar{h}}_{1,mij}={\bf \bar{h}}_{2,mil}{\bf D}_{2,ml}{\bf W}_{2,lj}^T$ |
| Input | ${\bf K}_{mij}={\bf \bar{h}}_{0,mij}$ |

: Jacobian matrix computed using reverse-mode automatic differentiation (AD). {#tbl-ad-reverse}

*For brevity, summation over index $l$ is implied following Einstein notation.*


The finite difference (FD) method was used to compute the Jacobian matrix in FastMAPOL in @Gao:2021aa, where the NN forward model was called twice per input parameter under the central difference approximation of derivatives. To reduce the computational cost, the Jacobian matrix can be derived analytically from the NN forward model using AD based on the chain rule of differentiation [@Baydin:2018aa]. Two recursive relations are obtained to compute the Jacobian matrix, as summarized in @tbl-ad-forward and @tbl-ad-reverse. The forward mode indicates the evaluation sequence from the first layer to the last layer, whereas the reverse mode indicates the evaluation sequence from the last layer to the first layer. To represent the recursive relations, we define ${\bf \dot{h}}_p$ (tangent) and ${\bf \bar{h}}_p$ (adjoint) as follows:

$$
{\bf \dot{h}}_{p,mij}
=
\frac{\partial {\bf h}_{p,mi}}
{\partial {\bf x}_{mj}},
$$

$$
{\bf \bar{h}}_{p,mij}
=
\frac{\partial {\bf y}_{mi}}
{\partial {\bf h}_{p,mj}}.
$$

Note that ${\bf h}$ is defined in @tbl-nn-forward as the output from each hidden layer of the NN. The Jacobian matrix can be represented by AD with either the tangent or the adjoint form, corresponding to the final steps in @tbl-ad-forward and @tbl-ad-reverse, respectively:

$$
{\bf K}_{mij}
=
{\bf \dot{y}}_{mij}
$$ {#eq-forward}

$$
{\bf K}_{mij}
=
{\bf \bar{h}}_{0,mij}
$$ {#eq-reverse}

where @eq-forward and @eq-reverse are computed from the forward- and reverse-mode AD, respectively. Forward and reverse AD produce identical results, but differ in computational efficiency due to the different sequence of matrix operations and NN architecture.

For optimal efficiency, we implemented AD directly based on the formalism summarized in @tbl-ad-forward and @tbl-ad-reverse using the PyTorch library [@Paszke:2019aa]. The NN forward model is computed layer by layer, with the output from the previous layer serving as the input to the next layer, as summarized in @tbl-nn-forward. Forward-mode AD follows the same sequence as the NN forward model, from the first layer to the last layer (@tbl-ad-forward), whereas reverse-mode AD proceeds from the last layer backward to the first layer (@tbl-ad-reverse). Note that AD in both modes requires the values of matrix ${\bf D}$ as defined in @eq-D, which are determined by the output of the NN forward model at each layer.

For the NN used in this study, AD in reverse mode provides the highest efficiency as investigated further in the next section.

The AD methods are efficient and accurate in computing the Jacobian matrix, providing a convenient way to accelerate algorithms like FastMAPOL with a large number of retrieval parameters, making them more suitable for practical applications.
