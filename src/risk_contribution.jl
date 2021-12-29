using LinearAlgebra



"""
    risk_contribution(weights, covariance_matrix)

Calculates the relative contribution to portfolio risk based on the passed asset weights and covariance matrix. The risk contributions are normalized, hence sum to 1.

# Arguments
- `weights`:                Vector of asset weights in portfolio.
- `covariance_matrix`:      Covariance matrix of asset returns.
"""
function risk_contribution(weights, covariance_matrix)
    normalize((weights' * covariance_matrix)' .* weights, 1)
end
