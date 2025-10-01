"""
    calmar_ratio(returns::AbstractVector, periods_per_year::Real; compound=true)

Compute the Calmar Ratio, defined as the Compound Annual Growth Rate (CAGR)
divided by the maximum drawdown magnitude.

# Arguments
- `returns`: Vector of periodic simple returns.
- `periods_per_year`: Number of return observations per year (e.g. 252, 12, 52).
- `compound`: When `true` (default), compute drawdowns using geometric compounding;
              when `false`, use the additive approximation.

# Formula

``\\text{Calmar Ratio} = \\dfrac{\\text{CAGR}(returns)}{\\text{MaxDrawdown}(returns)}``

# Edge Cases
- Returns `0.0` if `returns` is empty.
- If the maximum drawdown is exactly zero, returns `Inf` (or `-Inf` if CAGR is negative).
- `periods_per_year` must be positive and finite (enforced by `cagr`).
"""
function calmar_ratio(returns::AbstractVector, periods_per_year::Real; compound::Bool=true)
    isempty(returns) && return 0.0
    growth = cagr(returns, periods_per_year)
    drawdown = max_drawdown_pct(returns; compound=compound)
    drawdown == 0.0 && return growth == 0.0 ? 0.0 : (signbit(growth) ? -Inf : Inf)
    growth / drawdown
end
