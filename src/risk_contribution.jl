using LinearAlgebra

"""
    relative_risk_contribution(weights, covariance_matrix)

# Formula

The relative risk contribution (RRC) is defined as the ratio of its RC to the total portfolio risk ``\\sigma(w)``:

``\\text{RRC}_i = \\frac{\\text{RC}_i}{\\sigma(w)} = \\frac{w_i(\\Sigma w)_i}{w^T\\Sigma w}``

such that ``\\sum_{i=1}^N \\text{RRC}_i = 1``.

# Arguments
- `weights`:                Vector of asset weights in portfolio.
- `covariance_matrix`:      Covariance matrix of asset returns.
"""
function relative_risk_contribution(weights, covariance_matrix)
    normalize((weights' * covariance_matrix)' .* weights, 1)
end
