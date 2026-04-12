```@meta
CurrentModule = RiskPerf
```

# Getting Started

This page shows the core workflow: convert prices to returns, calculate
headline metrics, then add benchmark and tail-risk measures when needed.

## From Prices To Returns

Most metrics operate on a vector of returns. Use `drop_first=true` when the
leading `NaN` placeholder from return conversion is not useful downstream.

```julia
using RiskPerf

prices = [100.0, 101.0, 100.5, 99.8, 101.3]
returns = simple_returns(prices; drop_first=true)
```

Use `log_returns` when the rest of the analysis expects log returns.

```julia
logrets = log_returns(prices; drop_first=true)
total_return(logrets; method=:log)
```

## Headline Metrics

Choose the annualization convention that matches the data frequency.

```julia
periods_per_year = 252

growth = cagr(returns, periods_per_year)
risk = volatility(returns; multiplier=periods_per_year)
drawdown = max_drawdown_pct(returns)
sharpe = sharpe_ratio(returns; multiplier=periods_per_year, risk_free=0.0)
sortino = sortino_ratio(returns; multiplier=periods_per_year, MAR=0.0)
```

## Benchmark-Aware Metrics

Benchmark and risk-free inputs can be scalar values or vectors aligned to the
asset returns.

```julia
asset_returns = [0.010, -0.004, 0.006, 0.012, -0.003]
benchmark_returns = [0.008, -0.002, 0.004, 0.009, -0.001]

tracking_error(asset_returns, benchmark_returns; multiplier=252)
information_ratio(asset_returns, benchmark_returns; multiplier=252)
alpha, beta = capm(asset_returns, benchmark_returns; risk_free=0.0)
treynor_ratio(asset_returns, benchmark_returns; multiplier=252, risk_free=0.0)
```

## Tail Risk

Use a significance level such as `0.05` for the worst 5% of outcomes.

```julia
value_at_risk(returns, 0.05; method=:historical)
expected_shortfall(returns, 0.05; method=:historical)

value_at_risk(returns, 0.05; method=:gaussian)
expected_shortfall(returns, 0.05; method=:gaussian)
```

See [Conventions](conventions.md) for input assumptions and
[API Reference](api.md) for the complete function list.
