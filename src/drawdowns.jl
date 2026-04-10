"""
    drawdowns_pct(returns; compound)

Calculates the drawdown in percentage based on a returns time series.

# Arguments
- `returns`:    Vector of asset returns.
- `compound`:   When `true` (default), compound wealth via `cumprod(1 .+ returns)` (exact for simple returns).
                When `false`, use the additive approximation `1 .+ cumsum(returns)`.
                For log returns, exact dynamics would be `exp.(cumsum(returns))`; combine `compound=true` with
                simple returns if you need exact compounding.
"""
function drawdowns_pct(returns; compound::Bool=true)
    n = length(returns)
    dd = similar(returns, Float64)
    wealth = 1.0
    peak = 1.0
    if compound
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
    max_drawdown_pct(returns; compound)

Calculates the maximum drawdown as a positive percentage value for a returns time series.
"""
function max_drawdown_pct(returns; compound::Bool=true)
    cumulative = 1.0
    peak = 1.0
    max_dd = 0.0

    if compound
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

function _drawdown_moments_pct(returns; compound::Bool=true)
    n = length(returns)
    n == 0 && return (mean_dd=NaN, mean_squared_dd=NaN)

    cumulative = 1.0
    peak = 1.0
    sum_dd = 0.0
    sum_squared_dd = 0.0

    if compound
        for r in returns
            cumulative *= (1.0 + r)
            peak = max(peak, cumulative)
            drawdown = (peak - cumulative) / peak
            sum_dd += drawdown
            sum_squared_dd += drawdown * drawdown
        end
    else
        for r in returns
            cumulative += r
            peak = max(peak, cumulative)
            drawdown = (peak - cumulative) / peak
            sum_dd += drawdown
            sum_squared_dd += drawdown * drawdown
        end
    end

    (mean_dd=sum_dd / n, mean_squared_dd=sum_squared_dd / n)
end

"""
    average_drawdown_pct(returns; compound)

Calculates the average drawdown as a positive percentage value for a returns time series.

This is the time-series mean of the drawdown magnitudes. It captures both drawdown
depth and time spent below previous peaks, unlike maximum drawdown which only uses
the single worst point.
"""
function average_drawdown_pct(returns; compound::Bool=true)
    _drawdown_moments_pct(returns; compound=compound).mean_dd
end

"""
    ulcer_index(returns; compound)

Calculates the Ulcer Index for a returns time series.

The Ulcer Index is the root mean square of percentage drawdown magnitudes. It
penalizes persistent drawdowns and gives deeper drawdowns more weight than
`average_drawdown_pct`.
"""
function ulcer_index(returns; compound::Bool=true)
    sqrt(_drawdown_moments_pct(returns; compound=compound).mean_squared_dd)
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
