"""
    capm(asset_returns, benchmark_returns; risk_free=0.0)

Calculates the CAPM α and β coefficients based on sample covariance statistics and a simple linear regression model.

The linear regression model looks as follows:

``r_a - r_f = α + β(r_b - r_f) + ϵ``

The α coefficient in this model is also known as Jensen's alpha. β is the slope coefficient, and ϵ is an error term.

# Arguments
- `asset_returns`:      Vector of asset returns.
- `benchmark_returns`:  Vector of benchmark returns (e.g. market portfolio returns for CAPM beta).
- `risk_free`:          Optional vector or scalar value denoting the risk-free return (must have same frequency as the provided returns, e.g. daily).

# Returns
Tuple (α, β) with the estimated α and β coefficients of the CAPM model.
"""
@inline capm(asset_returns, benchmark_returns; risk_free=0.0) =
    _capm(asset_returns, benchmark_returns, risk_free)

function _capm(asset_returns, benchmark_returns, risk_free::Real)
    @assert length(asset_returns) == length(benchmark_returns)

    T = promote_type(eltype(asset_returns), eltype(benchmark_returns), typeof(risk_free))
    T = float(T)
    n = length(asset_returns)
    invn = one(T) / T(n)

    s1 = zero(T)
    s2 = zero(T)
    @inbounds @simd for i in eachindex(asset_returns, benchmark_returns)
        s1 += asset_returns[i] - risk_free
        s2 += benchmark_returns[i] - risk_free
    end
    μ1 = s1 * invn
    μ2 = s2 * invn

    num = zero(T)
    den = zero(T)
    @inbounds @simd for i in eachindex(asset_returns, benchmark_returns)
        ai = asset_returns[i] - risk_free
        bi = benchmark_returns[i] - risk_free
        num = muladd(ai - μ1, bi - μ2, num)
        den = muladd(bi - μ2, bi - μ2, den)
    end
    β = num / den
    α = μ1 - β * μ2
    return α, β
end

function _capm(asset_returns, benchmark_returns, risk_free::AbstractVector)
    @assert length(asset_returns) == length(benchmark_returns)
    @assert length(risk_free) == length(asset_returns)

    T = promote_type(eltype(asset_returns), eltype(benchmark_returns), eltype(risk_free))
    T = float(T)
    n = length(asset_returns)
    invn = one(T) / T(n)

    s1 = zero(T)
    s2 = zero(T)
    @inbounds @simd for i in eachindex(asset_returns, benchmark_returns, risk_free)
        rf = risk_free[i]
        s1 += asset_returns[i] - rf
        s2 += benchmark_returns[i] - rf
    end
    μ1 = s1 * invn
    μ2 = s2 * invn

    num = zero(T)
    den = zero(T)
    @inbounds @simd for i in eachindex(asset_returns, benchmark_returns, risk_free)
        rf = risk_free[i]
        ai = asset_returns[i] - rf
        bi = benchmark_returns[i] - rf
        num = muladd(ai - μ1, bi - μ2, num)
        den = muladd(bi - μ2, bi - μ2, den)
    end
    β = num / den
    α = μ1 - β * μ2
    return α, β
end
