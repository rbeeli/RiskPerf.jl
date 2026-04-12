```@meta
CurrentModule = RiskPerf
```

# Conventions

`RiskPerf.jl` keeps the API small: most functions accept plain numeric vectors,
plus scalar or vector reference series where needed.

## Return Frequency

Return vectors are assumed to be regularly spaced, for example daily, weekly, or
monthly. `RiskPerf.jl` does not infer frequency from dates, so pass the
annualization factor explicitly:

```julia
volatility(daily_returns; multiplier=252)
sharpe_ratio(monthly_returns; multiplier=12)
cagr(monthly_returns, 12)
```

## Simple And Log Returns

`simple_returns` and `log_returns` both accept vectors and matrices. Matrix
inputs are treated column-by-column, with each column representing one asset.

Use the matching `method` when a metric supports both simple and log returns:

```julia
total_return(simple_returns(prices; drop_first=true); method=:simple)
total_return(log_returns(prices; drop_first=true); method=:log)
```

## Reference Series

Functions such as `sharpe_ratio`, `sortino_ratio`, `tracking_error`,
`information_ratio`, `capm`, and `jensen_alpha` accept scalar references when
the benchmark, risk-free rate, or minimum acceptable return is constant:

```julia
sharpe_ratio(returns; risk_free=0.0)
sortino_ratio(returns; MAR=0.0)
```

Use vectors when the reference value changes period by period. Vector references
must be aligned to the return series and have the same length.

```julia
information_ratio(asset_returns, benchmark_returns)
capm(asset_returns, benchmark_returns; risk_free=risk_free_returns)
```

## Drawdowns

Percentage drawdowns compound simple returns by default:

```julia
drawdowns_pct(returns; compound=true)
max_drawdown_pct(returns; compound=true)
```

Set `compound=false` for the additive approximation:

```julia
drawdowns_pct(returns; compound=false)
```

Use the PnL variants when the input is a series of profit-and-loss amounts
rather than percentage returns:

```julia
drawdowns_pnl(pnl)
max_drawdown_pnl(pnl)
```

## Data Preparation

Clean and align data before calling metrics. For return conversion, pass
`drop_first=true` when downstream calculations should not receive the leading
placeholder value:

```julia
returns = simple_returns(prices; drop_first=true)
```
