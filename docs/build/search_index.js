var documenterSearchIndex = {"docs":
[{"location":"#RiskPerf.jl","page":"RiskPerf.jl","title":"RiskPerf.jl","text":"","category":"section"},{"location":"","page":"RiskPerf.jl","title":"RiskPerf.jl","text":"Documentation for RiskPerf.jl","category":"page"},{"location":"#Index","page":"RiskPerf.jl","title":"Index","text":"","category":"section"},{"location":"","page":"RiskPerf.jl","title":"RiskPerf.jl","text":"","category":"page"},{"location":"#Functions","page":"RiskPerf.jl","title":"Functions","text":"","category":"section"},{"location":"","page":"RiskPerf.jl","title":"RiskPerf.jl","text":"Modules = [RiskPerf]\nOrder   = [:function, :type]","category":"page"},{"location":"#RiskPerf.adjusted_sharpe_ratio-Tuple{Any}","page":"RiskPerf.jl","title":"RiskPerf.adjusted_sharpe_ratio","text":"adjusted_sharpe_ratio(returns; multiplier=1.0, risk_free=0.0)\n\nCalculates the adjusted Sharpe Ratio introduced by Pezier and White (2006) by penalizing negative skewness and excess kurtosis.\n\nFormula\n\ntextSR = dfracmathbbEleft textreturns - textrisk_freeright sigma(textreturns - textrisk_free)\n\ntextASR = textSR left1 + fracS6textSR - fracK-324textSR^2right times sqrttextmultiplier\n\nArguments\n\nreturns:        Vector of asset returns.\nmultiplier:     Optional scalar multiplier, i.e. use 12 to annualize monthly returns, and use 252 to annualize daily returns.\nrisk_free:      Optional vector or scalar value denoting the risk-free return (must have same frequency as the provided returns, e.g. daily).\n\nSources\n\nPezier, Jaques and White, Anthony (2006). The Relative Merits of Investable Hedge Fund Indices and of Funds of Hedge Funds in Optimal Passive Portfolios. ICMA Centre Discussion Papers in Finance.\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.capm-Tuple{Any, Any}","page":"RiskPerf.jl","title":"RiskPerf.capm","text":"capm(asset_returns, benchmark_returns; risk_free=0.0)\n\nCalculates the CAPM α and β coefficients based on sample covariance statistics and a simple linear regression model.\n\nThe linear regression model looks as follows:\n\nr_a - r_f = α + β(r_b - r_f) + ϵ\n\nThe α coefficient in this model is also known as Jensen's alpha. β is the slope coefficient, and ϵ is an error term.\n\nArguments\n\nasset_returns:      Vector of asset returns.\nbenchmark_returns:  Vector of benchmark returns (e.g. market portfolio returns for CAPM beta).\nrisk_free:          Optional vector or scalar value denoting the risk-free return (must have same frequency as the provided returns, e.g. daily).\n\nReturns\n\nTuple (α, β) with the estimated α and β coefficients of the CAPM model.\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.downside_deviation-Tuple{Any, Any}","page":"RiskPerf.jl","title":"RiskPerf.downside_deviation","text":"downside_deviation(returns, threshold; method=:full)\n\nCalculates the downside deviation, also called semi-standard deviation, which captures the downside risk.\n\nArguments\n\nreturns:     Vector of asset returns.\nthreshold:   Scalar value or vector denoting the threshold returns.\nmethod:      One of :full (default) or :partial. Indicates whether to use the number of all returns (:full), or only the number of returns below the threshold (:partial) in the denominator.\n\nFormula\n\ntextDownside Deviation = sqrttextLower Partial Moment\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.drawdowns-Tuple{Any}","page":"RiskPerf.jl","title":"RiskPerf.drawdowns","text":"drawdowns(pnl; compound)\n\nCalculates the drawdown based on a returns time series.\n\nArguments\n\nreturns:    Vector of asset returns (usually log-returns).\ngeometric:  Use geometric compounding (cumprod) if set to true, otherwise simple arithmetic sum (cumsum), e.g. for log-returns (default).\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.drawdowns_pnl-Tuple{Any}","page":"RiskPerf.jl","title":"RiskPerf.drawdowns_pnl","text":"drawdowns_pnl(pnl)\n\nCalculates the drawdown based on a Profit-and-Loss (PnL) time series, e.g. daily equity changes in USD.\n\nArguments\n\npnl:    Vector of Profit-and-Loss (PnL) values, e.g. daily equity changes in USD.\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.expected_shortfall-Tuple{Any, Any, Symbol}","page":"RiskPerf.jl","title":"RiskPerf.expected_shortfall","text":"expected_shortfall(returns, confidence, method; multiplier=1.0)\n\nComputes the Expected Shortfall (ES), also known as Conditional Value-at-Risk (CVaR), Average Value-at-Risk (AVaR) or Expected Tail Loss (ETL). The ES is the expected return on the asset in the worst α% of cases, therefore quantifies the tail-risk of an asset. It is calculated by averaging all of the returns in the distribution that are worse than the VaR of the portfolio at a given significance level α. For instance, for a 5% significance level, the expected shortfall is calculated by taking the average of returns in the worst 5% of cases.\n\nExpected Shortfall puts emphasis on the tail of the loss distribution, whereas Value-at-risk neglects this aspect.\n\nArguments\n\nreturns:        Vector of asset returns.\nα:              Significance level, e.g. use 0.05 for 95% confidence, or 0.01 for 99% confidence.\nmethod:         Distribution estimation method: :historical, :gaussian or :cornish_fisher.\nmultiplier:     Optional scalar multiplier, i.e. use 12 to annualize monthly returns, and use 252 to annualize daily returns.\n\nMethods\n\n:historical:        Historical based on empirical distribution of returns.\n:gaussian:          Gaussian distribution based on parametric fit (mean, variance).\n:cornish_fisher:    Cornish-Fisher based on Gaussian parametric distribution fit adjusted for third and fourth moments (skewness, kurtosis). Cornish-Fisher expansion aims to approximate the quantile of a true distribution by using higher moments (skewness and kurtosis) of that distribution to adjust for its non-normality. See https://thema.u-cergy.fr/IMG/pdf/2017-21.pdf for details.\n\nSources\n\nAmédée-Manesme, Charles-Olivier and Barthélémy, Fabrice and Maillard, Didier (2017). Computation of the Corrected Cornish–Fisher Expansion using the Response Surface Methodology: Application to VaR and CVaR. THEMA Working Paper n°2017-21, Université de Cergy-Pontoise, France.\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.higher_partial_moment-Tuple{Any, Any, Any, Symbol}","page":"RiskPerf.jl","title":"RiskPerf.higher_partial_moment","text":"higher_partial_moment(returns, threshold, n, method)\n\nThis function calculates the Higher Partial Moment (HPM) for a given threshold.\n\nArguments\n\nreturns:     Vector of asset returns.\nthreshold:   Scalar value or vector denoting the threshold returns.\nn:           n-th moment to calculate.\nmethod:      One of :full or :partial. Indicates whether to use the number of all returns (:full), or only the number of returns above the threshold (:partial) in the denominator.\n\nFormula\n\ntextHPM_n = frac1D sum_i=1^N max(0 textreturns_i - textthreshold)^n\n\nwhere N is the number of returns, and D is the denominator.\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.information_ratio-Tuple{Any, Any}","page":"RiskPerf.jl","title":"RiskPerf.information_ratio","text":"information_ratio(asset_returns, benchmark_returns; multiplier=1.0)\n\nThis function calculates the Information Ratio as the active return divided by the tracking error. The calculation equals William F. Sharpe's revision of the original version of the Sharpe Ratio (see function sharpe_ratio).\n\nFormula\n\ntextIR = dfracmathbbElefttextasset_returns - textbenchmark_returns rightsigma(textasset_returns - textbenchmark_returns) times sqrttextmultiplier\n\nArguments\n\nasset_returns:      Vector of asset returns.\nbenchmark_returns:  Vector or scalar value of benchmark returns having same same frequency (e.g. daily) as the provided returns.\nmultiplier:         Optional scalar multiplier, i.e. use 12 to annualize monthly returns, and use 252 to annualize daily returns.\n\nSources\n\nSharpe, William F. (1994). \"The Sharpe Ratio\". The Journal of Portfolio Management.\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.jensen_alpha-Tuple{Any, Any}","page":"RiskPerf.jl","title":"RiskPerf.jensen_alpha","text":"jensen_alpha(asset_returns, benchmark_returns; risk_free=0.0)\n\nJensen's alpha, or simply alpha, is a risk-adjusted excess-performance measure. It indicates the average return of an investment above or below that predicted by the capital asset pricing model (CAPM). The measure adjusts the excess returns such that the risk is identical for the investment and benchmark.\n\nArguments\n\nasset_returns:      Vector of asset returns.\nbenchmark_returns:  Vector of benchmark returns (e.g. market portfolio returns for CAPM beta).\nrisk_free:          Optional vector or scalar value denoting the risk-free return (must have same frequency as the provided returns, e.g. daily).\n\nReturns\n\nJensen's alpha measure.\n\nSources\n\nBacon, Carl (2008). Practical Portfolio Performance Measurement and Attribution, 2nd Edition, John Wiley & Sons Ltd. Page 72.\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.kurtosis-Tuple{Any}","page":"RiskPerf.jl","title":"RiskPerf.kurtosis","text":"kurtosis(x; method=:excess)\n\nCalculates the kurtosis using on the specified method.\n\nMethods\n\nExcess (default)\nMoment\nCornish-Fisher\n\nArguments\n\nx:          Vector of values.\nmethod:     Estimation method: :excess, :moment or :cornish_fisher.\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.log_returns-Tuple{T} where T<:(AbstractMatrix)","page":"RiskPerf.jl","title":"RiskPerf.log_returns","text":"log_returns(prices::Matrix)\n\nCalculates log-return series for each column of the provided prices matrix, where each column denotes a prices series of an asset, e.g. a stock.\n\nPlease note that the provided prices series should be regularly spaced, for example hourly or daily data.\n\nArguments\n\nprices: Matrix of size [N x k] of prices, where each column denotes a price series of an asset, e.g. a stock.\n\nFormula\n\nr_t i = logleft(dfracP_t iP_t-1 iright)\n\nwhere r_t i is the return at time t for asset i, P_t i is the price at time t for asset i, and P_t-1 i is the price at time t-1 for asset i.\n\nReturns\n\nMatrix of log-returns with size [(N-1) x k].\n\nExamples\n\njulia> using RiskPerf\n\njulia> prices = [100.0 99.0; 101.0 99.5; 100.5 99.8; 99.8 99.2; 101.3 100.0]\n5×2 Matrix{Float64}:\n 100.0   99.0\n 101.0   99.5\n 100.5   99.8\n  99.8   99.2\n 101.3  100.0\n\njulia> log_returns(prices)\n4×2 Matrix{Float64}:\n  0.00995033   0.00503779\n -0.00496279   0.00301054\n -0.00698954  -0.00603017\n  0.0149182    0.00803217\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.log_returns-Tuple{T} where T<:(AbstractVector)","page":"RiskPerf.jl","title":"RiskPerf.log_returns","text":"log_returns(prices::Vector)\n\nCalculates the log-return series based on the provided time series of N prices. Please note that the provided prices series should be regularly spaced, for example hourly or daily data.\n\nArguments\n\nprices: Vector of prices.\n\nFormula\n\nr_t = logleft(dfracP_tP_t-1right)\n\nwhere r_t is the return at time t, P_t is the price at time t, and P_t-1 is the price at time t-1.\n\nReturns\n\nVector of log-returns with size N-1.\n\nExamples\n\njulia> using RiskPerf\n\njulia> prices = [100.0, 101.0, 100.5, 99.8, 101.3]\n5-element Vector{Float64}:\n 100.0\n 101.0\n 100.5\n  99.8\n 101.3\n\njulia> log_returns(prices)\n4-element Vector{Float64}:\n  0.009950330853168092\n -0.004962789342129014\n -0.006989544181712186\n  0.014918227937219366\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.lower_partial_moment-Tuple{Any, Any, Any, Symbol}","page":"RiskPerf.jl","title":"RiskPerf.lower_partial_moment","text":"lower_partial_moment(returns, threshold, n, method)\n\nThis function calculates the Lower Partial Moment (LPM) for a given threshold.\n\nArguments\n\nreturns:     Vector of asset returns.\nthreshold:   Scalar value or vector denoting the threshold returns.\nn:           n-th moment to calculate.\nmethod:      One of :full or :partial. Indicates whether to use the number of all returns (:full), or only the number of returns below the threshold (:partial) in the denominator.\n\nFormula\n\ntextLPM_n = frac1D sum_i=1^N max(0 textthreshold - textreturns_i)^n\n\nwhere N is the number of returns, and D is the denominator.\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.modified_jensen-Tuple{Any, Any}","page":"RiskPerf.jl","title":"RiskPerf.modified_jensen","text":"modified_jensen(asset_returns, benchmark_returns; risk_free=0.0)\n\nDivides Jensen’s alpha by the systematic risk, which measures the systematic risk-adjusted return per unit of systematic risk. See also jensen_alpha\n\nArguments\n\nasset_returns:      Vector of asset returns.\nbenchmark_returns:  Vector of benchmark returns (e.g. market portfolio returns for CAPM beta).\nrisk_free:          Optional vector or scalar value denoting the risk-free return (must have same frequency as the provided returns, e.g. daily).\n\nReturns\n\nModified Jensen's alpha measure.\n\nSources\n\nBacon, Carl (2008). Practical Portfolio Performance Measurement and Attribution, 2nd Edition, John Wiley & Sons Ltd. Page 77.\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.omega_ratio-Tuple{Any, Any}","page":"RiskPerf.jl","title":"RiskPerf.omega_ratio","text":"omega_ratio(returns, target_return)\n\nThis function calculates the Omega ratio.\n\nFormula\n\nOmega = -dfrac mathbbEleft textmax(textreturns - texttarget_return 0) right  mathbbEleft textmin(texttarget_return - textreturns 0) right \n\nArguments\n\nreturns:        Vector of asset returns.\ntarget_return:  Vector or scalar value of benchmark returns having same same frequency (e.g. daily) as the provided returns.\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.relative_risk_contribution-Tuple{Any, Any}","page":"RiskPerf.jl","title":"RiskPerf.relative_risk_contribution","text":"relative_risk_contribution(weights, covariance_matrix)\n\nFormula\n\nThe relative risk contribution (RRC) is defined as the ratio of its RC to the total portfolio risk sigma(w):\n\ntextRRC_i = fractextRC_isigma(w) = fracw_i(Sigma w)_iw^TSigma w\n\nsuch that sum_i=1^N textRRC_i = 1.\n\nArguments\n\nweights:                Vector of asset weights in portfolio.\ncovariance_matrix:      Covariance matrix of asset returns.\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.sharpe_ratio-Tuple{Any}","page":"RiskPerf.jl","title":"RiskPerf.sharpe_ratio","text":"sharpe_ratio(returns; multiplier=1.0, risk_free=0.0)\n\nCalculates the Sharpe Ratio (SR) according to the original definition by William F. Sharpe in 1966. For calculating the Sharpe Ratio according to Sharpe's revision in 1994, please see function information_ratio (IR).\n\nFormula\n\ntextSR = dfracmathbbElefttextreturns - textrisk_free rightsigma(textreturns) times sqrttextmultiplier\n\ntextIR = dfracmathbbElefttextasset_returns - textbenchmark_returns rightsigma(textasset_returns - textbenchmark_returns) times sqrttextmultiplier\n\nArguments\n\nreturns:        Vector of asset returns.\nmultiplier:     Optional scalar multiplier, i.e. use 12 to annualize monthly returns, and use 252 to annualize daily returns.\nrisk_free:      Optional vector or scalar value denoting the risk-free return (must have same frequency as the provided returns, e.g. daily).\n\nSources\n\nSharpe, W. F. (1966). Mutual Fund Performance. Journal of Business.\nSharpe, William F. (1994). The Sharpe Ratio. The Journal of Portfolio Management.\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.simple_returns-Tuple{T} where T<:(AbstractMatrix)","page":"RiskPerf.jl","title":"RiskPerf.simple_returns","text":"simple_returns(prices::Matrix)\n\nCalculates the simple returns series for each column of the provided prices matrix, where each column denotes a prices series of an asset, e.g. a stock.\n\nPlease note that the provided prices series should be regularly spaced, for example hourly or daily data.\n\nArguments\n\nprices: Matrix of size [N x k] where each column denotes a price series of an asset, e.g. a stock.\n\nFormula\n\nr_t i = dfracP_t iP_t-1 i - 1\n\nwhere r_t i is the return at time t for asset i, P_t i is the price at time t for asset i, and P_t-1 i is the price at time t-1 for asset i.\n\nReturns\n\nMatrix of simple returns with size [(N-1) x k].\n\nExamples\n\njulia> using RiskPerf\n\njulia> prices = [100.0 99.0; 101.0 99.5; 100.5 99.8; 99.8 99.2; 101.3 100.0]\n5×2 Matrix{Float64}:\n 100.0   99.0\n 101.0   99.5\n 100.5   99.8\n  99.8   99.2\n 101.3  100.0\n\njulia> simple_returns(prices)\n4×2 Matrix{Float64}:\n  0.01         0.00505051\n -0.0049505    0.00301508\n -0.00696517  -0.00601202\n  0.0150301    0.00806452\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.simple_returns-Tuple{T} where T<:(AbstractVector)","page":"RiskPerf.jl","title":"RiskPerf.simple_returns","text":"simple_returns(prices::Vector)\n\nCalculates the simple returns series based on the provided time series of N prices. Please note that the provided prices series should be regularly spaced, for example hourly or daily data.\n\nFormula\n\nr_t = dfracP_tP_t-1 - 1\n\nwhere r_t is the return at time t, P_t is the price at time t, and P_t-1 is the price at time t-1.\n\nArguments\n\nprices: Vector of prices.\n\nReturns\n\nVector of simple returns with size N-1.\n\nExamples\n\njulia> using RiskPerf\n\njulia> prices = [100.0, 101.0, 100.5, 99.8, 101.3]\n5-element Vector{Float64}:\n 100.0\n 101.0\n 100.5\n  99.8\n 101.3\n\njulia> simple_returns(prices)\n4-element Vector{Float64}:\n  0.010000000000000009\n -0.004950495049504955\n -0.006965174129353269\n  0.01503006012024044\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.simple_returns-Union{Tuple{T}, Tuple{Vector{Dates.DateTime}, Vector{T}}} where T","page":"RiskPerf.jl","title":"RiskPerf.simple_returns","text":"simple_returns(dates::Vector{DateTime}, prices::Vector{T}; drop_overnight::Bool=false)\n\nCalculates the simple returns series based on the provided time series of prices. Please note that the provided prices series should be regularly spaced, for example hourly or daily data. If the parameter drop_overnight is set to true, overnight returns will be dropped.\n\nArguments\n\ndates:              Vector of DateTime objects for prices.\nprices:             Vector of prices.\ndrop_overnight:     Boolean value indicating whether to drop overnight returns or not (default=false).\n\nReturns\n\nTuple of type Tuple{Vector{DateTime}, Vector{T}, Vector{Int64}} with dates, returns and indices of original time series.\n\nExamples\n\njulia> using RiskPerf\n\njulia> dates = [DateTime(2020, 1, 1, 1), DateTime(2020, 1, 1, 2), DateTime(2020, 1, 2, 1), DateTime(2020, 1, 2, 2)]\n4-element Array{DateTime,1}:\n 2020-01-01T01:00:00\n 2020-01-01T02:00:00\n 2020-01-02T01:00:00\n 2020-01-02T02:00:00\n\njulia> prices = [100.0, 101.0, 100.5, 100.75]\n4-element Vector{Float64}:\n 100.0\n 101.0\n 100.5\n 100.75\n\njulia> simple_returns(dates, prices; drop_overnight=true)\n([DateTime(\"2020-01-01T02:00:00\"), DateTime(\"2020-01-02T02:00:00\")], [0.010000000000000009, 0.0024875621890547706], [2, 4])\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.skewness-Tuple{Any}","page":"RiskPerf.jl","title":"RiskPerf.skewness","text":"skewness(x; method=:moment)\n\nCalculates the skewness using the specified method.\n\nMethods\n\nMoment (default)\nFisher-Pearson\nSample\n\nArguments\n\nx:          Vector of values.\nmethod:     Estimation method: :moment, :fisher_pearson or :sample.\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.sortino_ratio-Tuple{Any}","page":"RiskPerf.jl","title":"RiskPerf.sortino_ratio","text":"sortino_ratio(returns; multiplier=1.0, risk_free=0.0)\n\nCalculates the Sortino Ratio, a downside risk-adjusted performance measure. Contrary to the Sharpe Ratio, only deviations below the minimum acceptable returns are included in the calculation of the risk (downside deviation instead of standard deviation).\n\nArguments\n\nreturns:        Vector of asset returns.\nmultiplier:     Optional scalar multiplier, i.e. use 12 to annualize monthly returns, and use 252 to annualize daily returns.\nMAR:            Optional vector or scalar value denoting the minimum acceptable return(s). Must have same frequency as the provided returns, e.g. daily.\n\nFormula\n\ntextSortino Ratio = dfractextreturns - textMARtextdownside deviation times sqrttextmultiplier\n\nThe downside deviation is simply the standard deviation of the returns below the minimum acceptable return.\n\nSources\n\nSortino, F. and Price, L. (1996). Performance Measurement in a Downside Risk Framework. Journal of Investing.\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.tracking_error-Tuple{Any, Any}","page":"RiskPerf.jl","title":"RiskPerf.tracking_error","text":"tracking_error(asset_returns, benchmark_returns; multiplier=1.0)\n\nCalculates the ex-post Tracking Error based on the standard deviation of the active returns.\n\nFormula\n\ntextTE = sigmaleft( textasset_returns - textbenchmark_returns right) times sqrttextmultiplier\n\nArguments\n\nasset_returns:      Vector of asset returns.\nbenchmark_returns:  Vector of benchmark returns.\nmultiplier:         Optional scalar multiplier, i.e. use 12 to annualize monthly returns, and use 252 to annualize daily returns.\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.treynor_ratio-Tuple{Any, Any}","page":"RiskPerf.jl","title":"RiskPerf.treynor_ratio","text":"treynor_ratio(asset_returns, benchmark_returns; multiplier=1.0, risk_free=0.0)\n\nCalculates the Treynor ratio as the ratio of excess return divided by the CAPM beta. This ratio is similar to the Sharpe Ratio, but instead of dividing by the volatility, we devide by the CAPM beta as risk proxy.\n\nFormula\n\ntextTR = dfrac mathbbEleft textasset_returns - textrisk_free rightbeta times textmultiplier\n\nArguments\n\nasset_returns:      Vector of asset returns.\nbenchmark_returns:  Vector of benchmark returns (e.g. market portfolio returns).\nmultiplier:         Optional scalar multiplier, i.e. use 12 to annualize monthly returns, and use 252 to annualize daily returns.\nrisk_free:          Optional vector or scalar value denoting the risk-free return (must have same frequency as the provided returns, e.g. daily).\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.upside_deviation-Tuple{Any, Any}","page":"RiskPerf.jl","title":"RiskPerf.upside_deviation","text":"upside_deviation(returns, threshold; method=:full)\n\nCalculates the upside deviation, also called semi-standard deviation, which captures the upside \"risk\".\n\nArguments\n\nreturns:     Vector of asset returns.\nthreshold:   Scalar value or vector denoting the threshold returns.\nmethod:      One of :full (default) or :partial. Indicates whether to use the number of all returns (:full), or only the number of returns above the threshold (:partial) in the denominator.\n\nFormula\n\ntextUpside Deviation = sqrttextHigher Partial Moment\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.upside_potential_ratio-Tuple{Any, Any}","page":"RiskPerf.jl","title":"RiskPerf.upside_potential_ratio","text":"upside_potential_ratio(returns, threshold; method=:partial)\n\nThe Upside Potential Ratio is a risk-adjusted performance measure similarly to the Sharpe Ratio and the Sortino Ratio. This ratio considers only upside returns (above threshold) in the numerator, and only downside returns (below threshold) in the denominator (see downside_deviation).\n\nArguments\n\nreturns:     Vector of asset returns.\nthreshold:   Scalar value or vector denoting the threshold returns.\nmethod:      One of :full (default) or :partial. Indicates whether to use the number of all returns (:full), or only the number of returns above the threshold (:partial) in the denominator.\n\nSources\n\nPlantinga, A., van der Meer, R. and Sortino, F. (2001). The Impact of Downside Risk on Risk-Adjusted Performance of Mutual Funds in the Euronext Markets.\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.value_at_risk-Tuple{Any, Any, Symbol}","page":"RiskPerf.jl","title":"RiskPerf.value_at_risk","text":"value_at_risk(returns, confidence, method; multiplier=1.0)\n\nComputes the Value-at-Risk (VaR) for a given significance level α based on the chosen estimation method. The VaR value represents the maximum expected loss at a certain significance level α. For a more tail-risk focused measure, see expected_shortfall.\n\nArguments\n\nreturns:     Vector of asset returns.\nα:           Significance level, e.g. use 0.05 for 95% confidence, or 0.01 for 99% confidence.\nmethod:      Distribution estimation method: :historical, :gaussian or :cornish_fisher.\nmultiplier:  Optional scalar multiplier, i.e. use 12 to annualize monthly returns, and use 252 to annualize daily returns.\n\nMethods\n\n:historical:        Historical based on empirical distribution of returns.\n:gaussian:          Gaussian distribution based on parametric fit (mean, variance).\n:cornish_fisher:    Cornish-Fisher based on Gaussian parametric distribution fit adjusted for third and fourth moments (skewness, kurtosis). Cornish-Fisher expansion aims to approximate the quantile of a true distribution by using higher moments (skewness and kurtosis) of that distribution to adjust for its non-normality. See https://thema.u-cergy.fr/IMG/pdf/2017-21.pdf for details.\n\nSources\n\nFavre, Laurent and Galeano, Jose-Antonio (2002). Mean-Modified Value-at-Risk Optimization with Hedge Funds. Journal of Alternative Investment.\nAmédée-Manesme, Charles-Olivier and Barthélémy, Fabrice and Maillard, Didier (2017). Computation of the Corrected Cornish–Fisher Expansion using the Response Surface Methodology: Application to VaR and CVaR. THEMA Working Paper n°2017-21, Université de Cergy-Pontoise, France.\n\n\n\n\n\n","category":"method"},{"location":"#RiskPerf.volatility-Tuple{Any}","page":"RiskPerf.jl","title":"RiskPerf.volatility","text":"volatility(returns; multiplier=1.0)\n\nCalculates the volatility based on the standard deviation of the returns. The optional multiplier parameter allows for scaling the resulting volatility metric, i.e. for annualization.\n\nFormula\n\nsigma_vol = sigma(textreturns) times sqrttextmultiplier\n\nwhere sigma denotes the sample standard deviation.\n\nArguments\n\nreturns:    Vector of asset returns (usually log-returns).\nmultiplier: Optional scalar multiplier, i.e. use 12 to annualize monthly returns, and use 252 to annualize daily returns.\n\n\n\n\n\n","category":"method"}]
}