@testitem "capm" setup = [TestData] begin
    α1, β1 = capm(asset_returns, market_returns)
    @test α1 ≈ 0.000512345109212185
    @test β1 ≈ 0.0370188032088717

    α2, β2 = capm(asset_returns, market_returns; risk_free=rf)
    @test α2 ≈ 0.000502715256287843
    @test β2 ≈ 0.037019963055605
end

@testitem "capm parameter types" setup = [TestData] begin
    # scalar non-zero risk-free (Real)
    c = 0.001
    αc, βc = capm(asset_returns, market_returns; risk_free=c)
    αshift, βshift = capm(asset_returns .- c, market_returns .- c)
    @test αc ≈ αshift atol=1e-12 rtol=0
    @test βc ≈ βshift atol=1e-12 rtol=0

    # scalar integer risk-free (Int <: Real)
    αi, βi = capm(asset_returns, market_returns; risk_free=0)
    αf, βf = capm(asset_returns, market_returns; risk_free=0.0)
    @test αi ≈ αf atol=0 rtol=0
    @test βi ≈ βf atol=0 rtol=0

    # Float32 inputs, Float64 risk-free (promotion + stability)
    a32 = Float32.(asset_returns)
    b32 = Float32.(market_returns)
    α32, β32 = capm(a32, b32; risk_free=0.0)
    α64, β64 = capm(asset_returns, market_returns; risk_free=0.0)
    @test isfinite(α32) && isfinite(β32)
    @test Float64(α32) ≈ α64 rtol=1e-6 atol=0
    @test Float64(β32) ≈ β64 rtol=1e-6 atol=0

    # vector risk-free with different eltype
    rf32 = Float32.(rf)
    αv32, βv32 = capm(asset_returns, market_returns; risk_free=rf32)
    αv64, βv64 = capm(asset_returns, market_returns; risk_free=rf)
    @test Float64(αv32) ≈ αv64 rtol=1e-6 atol=0
    @test Float64(βv32) ≈ βv64 rtol=1e-6 atol=0

    # AbstractVector inputs (views)
    va = @view asset_returns[:]
    vb = @view market_returns[:]
    αv, βv = capm(va, vb; risk_free=rf)
    @test αv ≈ αv64 rtol=0 atol=0
    @test βv ≈ βv64 rtol=0 atol=0

    # length mismatch errors
    @test_throws AssertionError capm(asset_returns[1:end-1], market_returns)
    @test_throws AssertionError capm(asset_returns, market_returns; risk_free=rf[1:end-1])
end
