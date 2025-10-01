"""
    drawdowns_pct(returns; geometric)

Calculates the drawdown in percentage based on a returns time series.

# Arguments
- `returns`:    Vector of asset returns.
- `geometric`:  If `true`, use geometric compounding via `cumprod(1 .+ returns)` (exact for simple returns).
                If `false`, use arithmetic accumulation `1 .+ cumsum(returns)` as a simple approximation.
                For log returns, geometric compounding reflects exact wealth dynamics via `exp.(cumsum(returns))`,
                which is not implemented here; use the `geometric=true` path with simple returns if you need exact compounding.
"""
function drawdowns_pct(returns; geometric::Bool=false)
    n = length(returns)
    dd = similar(returns, Float64)
    wealth = 1.0
    peak = 1.0
    if geometric
        @inbounds for i in eachindex(returns)
            wealth *= (1.0 + returns[i])
            peak = max(peak, wealth)
            dd[i] = wealth / peak - 1.0
        end
    else
        @inbounds for i in eachindex(returns)
            wealth += returns[i]
            peak = max(peak, wealth)
            dd[i] = wealth / peak - 1.0
        end
    end
    dd
end

"""
    max_drawdown_pct(returns; geometric)

Calculates the maximum drawdown as a positive percentage value for a returns time series.
"""
function max_drawdown_pct(returns; geometric::Bool=false)
    cumulative = 1.0
    peak = 1.0
    max_dd = 0.0

    if geometric
        for r in returns
            cumulative *= (1.0 + r)
            peak = max(peak, cumulative)
            max_dd = max(max_dd, (peak - cumulative) / peak)
        end
    else
        for r in returns
            cumulative += r
            peak = max(peak, cumulative)
            max_dd = max(max_dd, (peak - cumulative) / peak)
        end
    end

    max_dd
end

"""
    drawdowns_pnl(pnl)

Calculates the drawdown based on a Profit-and-Loss (PnL) time series, e.g. daily equity changes in USD.

# Arguments
- `pnl`:    Vector of Profit-and-Loss (PnL) values, e.g. daily equity changes in USD.
"""
function drawdowns_pnl(pnl)
    dd = similar(pnl, Float64)
    cumulative = 0.0
    peak = 0.0
    @inbounds for i in eachindex(pnl)
        cumulative += pnl[i]
        peak = max(peak, cumulative)
        dd[i] = cumulative - peak
    end
    dd
end

"""
    max_drawdown_pnl(pnl)

Calculates the maximum drawdown as a positive loss amount for a PnL time series.
"""
function max_drawdown_pnl(pnl)
    cumulative = 0.0
    peak = 0.0
    max_dd = 0.0

    for delta in pnl
        cumulative += delta
        peak = max(peak, cumulative)
        max_dd = max(max_dd, peak - cumulative)
    end

    max_dd
end
