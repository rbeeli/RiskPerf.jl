@testsnippet TestData begin
    using Test
    using Dates
    using Statistics
    using RiskPerf

    # load test data produced using R PerformanceAnalytics package
    asset_returns = parse.(Float64, readlines("data/recon_asset_rets.csv")[2:end])
    market_returns = parse.(Float64, readlines("data/recon_market_rets.csv")[2:end])
    rf = parse.(Float64, readlines("data/recon_rf_rets.csv")[2:end])
end
