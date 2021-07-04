"""
    capm(asset_returns, benchmark_returns; risk_free=0.0)

Calculates the CAPM alpha and beta coefficients based on sample covariance statistics and a simple linear regression.

# Arguments
- `asset_returns`:      Vector of asset returns.
- `benchmark_returns`:  Vector of benchmark returns (e.g. market portfolio returns for CAPM beta).
- `risk_free`:          Optional vector or scalar value denoting the risk-free return(s). Must have same frequency (e.g. daily) as the provided returns.

# Returns
Tuple containing the alpha and beta coefficients of the CAPM model.
"""
function capm(asset_returns, benchmark_returns; risk_free=0.0)
    asset_returns_ex = asset_returns .- risk_free
    benchmark_returns_ex = benchmark_returns .- risk_free
    μ1 = mean(asset_returns_ex)
    μ2 = mean(benchmark_returns_ex)
    β = sum((asset_returns_ex .- μ1).*(benchmark_returns_ex .- μ2)) / sum((benchmark_returns_ex .- μ2).^2)
    α = μ1 - β*μ2
    (α, β)
end
