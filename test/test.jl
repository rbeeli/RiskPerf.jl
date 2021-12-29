using RiskPerf

asset_returns = parse.(Float64, readlines("test/data/recon_asset_rets.csv")[2:end])
market_returns = parse.(Float64, readlines("test/data/recon_market_rets.csv")[2:end])
rf = parse.(Float64, readlines("test/data/recon_rf_rets.csv")[2:end])

dd = drawdowns(asset_returns)

dd2 = map(x -> ((x < 0) ? -1 : 0), dd);
breaks = diff(dd2);

test = hcat(breaks, hcat(dd2, dd)[2:end, :])
