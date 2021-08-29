"""
    drawdowns(pnl; compound)

Calculates the drawdown based on a returns time series.

# Arguments
- `returns`:    Vector of asset returns (usually log-returns).
- `geometric`:  Use geometric compounding (cumprod) if set to true, otherwise simple arithmetic sum (cumsum), e.g. for log-returns (default).
"""
function drawdowns(returns; geometric::Bool=false)
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
