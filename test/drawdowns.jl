@testitem "drawdowns" setup = [TestData] begin
    @test length(drawdowns_pct(asset_returns)) == length(asset_returns)
    @test mean(drawdowns_pct(asset_returns)) ≈ -0.000418043468523338
    @test std(drawdowns_pct(asset_returns)) ≈ 0.000757130672676854
    @test mean(drawdowns_pct(asset_returns; geometric=true)) ≈ -0.000517982256217951
    @test std(drawdowns_pct(asset_returns; geometric=true)) ≈ 0.000916577011725993
    @test max_drawdown_pct(asset_returns) ≈ -minimum(drawdowns_pct(asset_returns))
    @test max_drawdown_pct(asset_returns; geometric=true) ≈
        -minimum(drawdowns_pct(asset_returns; geometric=true))

    pnl = [-50, 100, -20, 30, -120, -10, 200, 10, 18, -12, -20, -30, 0]
    @test length(drawdowns_pnl(pnl)) == length(pnl)
    @test mean(drawdowns_pnl(pnl)) ≈ -37.53846153846154
    @test std(drawdowns_pnl(pnl)) ≈ 45.40303841634277
    @test max_drawdown_pnl(pnl) ≈ -minimum(drawdowns_pnl(pnl))
end
