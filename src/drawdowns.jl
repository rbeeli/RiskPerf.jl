"""
    drawdowns_pct(returns; compound)

Calculates the drawdown in percentage based on a returns time series.

# Arguments
- `returns`:    Vector of asset returns (usually log-returns).
- `geometric`:  Use geometric compounding (`cumprod`) if set to `true`, otherwise simple arithmetic sum (`cumsum`), e.g. for log-returns (default).
"""
function drawdowns_pct(returns; geometric::Bool=false)
    if geometric
        returns = cumprod(1.0 .+ returns)
    else
        returns = 1.0 .+ cumsum(returns)
    end

    # cumulative returns needs to start at 1.0 for cumulative max to be correct
    returns_max = accumulate(max, [1.0; returns])[2:end]
    returns ./ returns_max .- 1.0
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
    pnl = cumsum(pnl)

    # cumulative PnL needs to start at 0.0 for cumulative max to be correct
    pnl_max = accumulate(max, [0.0; pnl])[2:end]
    pnl .- pnl_max
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
