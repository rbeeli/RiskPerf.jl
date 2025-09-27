@testitem "risk_contribution" setup = [TestData] begin
    # https://breakingdownfinance.com/finance-topics/modern-portfolio-theory/marginal-contribution-to-risk-mctr/
    w = [0.042, 0.25, 0.32, 0.22, 0.168]
    covmat = [
        0.001369 0.001184 0.000161 0.001924 0.002886
        0.001184 0.006400 0.000580 0.008840 0.006240
        0.000161 0.000580 0.000841 0.001885 0.001131
        0.001924 0.008840 0.001885 0.016900 0.003380
        0.002886 0.006240 0.001131 0.003380 0.067600
    ]
    ctb = relative_risk_contribution(w, covmat)

    @test all(isapprox.(ctb, [0.009944 0.217649 0.059174 0.284805 0.428427]'; rtol=0.0001))
end
