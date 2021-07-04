"""
    expected_shortfall(returns, confidence, method; multiplier=1.0)

Computes the Expected Shortfall (ES), also known as Conditional Value-at-Risk (CVaR), Average Value-at-Risk (AVaR) or Expected Tail Loss (ETL). The ES is the expected return on the asset in the worst `α%` of cases, therefore quantifies the tail-risk of an asset. It is calculated by averaging all of the returns in the distribution that are worse than the VaR of the portfolio at a given significance level `α`. For instance, for a 5% significance level, the expected shortfall is calculated by taking the average of returns in the worst 5% of cases.

Expected Shortfall puts emphasis on the tail of the loss distribution, whereas Value-at-risk neglects this aspect.


# Arguments
- `returns`:     Vector of asset returns.
- `α`:           Significance level, e.g. use `0.05` for 95% confidence, or `0.01` for 99% confidence.
- `method`:      Distribution estimation method: `:historical`, `:gaussian` or `:cornish_fisher`.
- `multiplier`:  Optional scalar multiplier, i.e. use `√12` to annualize monthly returns, and use `√252` to annualize daily returns.

# Methods
- `:historical`:        Historical based on empirical distribution of returns.
- `:gaussian`:          Gaussian distribution based on parametric fit (mean, variance).
- `:cornish_fisher`:    Cornish-Fisher based on Gaussian parametric distribution fit adjusted for third and fourth moments (skewness, kurtosis). Cornish-Fisher expansion aims to approximate the quantile of a true distribution by using higher moments (skewness and kurtosis) of that distribution to adjust for its non-normality. See https://thema.u-cergy.fr/IMG/pdf/2017-21.pdf for details.

# Sources
- Amédée-Manesme, Charles-Olivier and Barthélémy, Fabrice and Maillard, Didier (2017). Computation of the Corrected Cornish–Fisher Expansion using the Response Surface Methodology: Application to VaR and CVaR. THEMA Working Paper n°2017-21, Université de Cergy-Pontoise, France.
"""
function expected_shortfall(returns, α, method::Symbol; multiplier=1.0)
    if method == :historical
        # average return below significance level (quantile)
        sorted = sort(returns)
        idx = floor(Int64, length(sorted) * α)
        return mean(sorted[1:idx]) * multiplier
    elseif method == :gaussian
        # derivation: http://blog.smaga.ch/expected-shortfall-closed-form-for-normal-distribution/
        q = quantile(Normal(), α)
        μ = mean(returns)
        σ = std(returns; corrected=false)
        return (μ - σ*pdf(Normal(), q)/α) * multiplier
    elseif method == :cornish_fisher
        # third/fourth moment adjusted Gaussian distribution fit
        # https://papers.ssrn.com/sol3/papers.cfm?abstract_id=1024151
        q = quantile(Normal(), α)
        S = skewness(returns)
        K = kurtosis(returns; method=:excess)
        g = q + 1/6*(q^2-1)S + 1/24*(q^3-3q)*K - 1/36*(2q^3-5q)*S^2
        ϕ = pdf(Normal(), g)
        EG2 = -1/α*ϕ * (1 + 1/6*(g^3)*S + 1/72*(g^6 - 9g^4 + 9g^2 + 3)*S^2 + 1/24*(g^4 - 2g^2 - 1)*K)
        μ = mean(returns)
        σ = std(returns; corrected=false)
        return (μ + σ*EG2) * multiplier
    end

    throw(ArgumentError("Passed method parameter '$(method)' is invalid, must be one of :historical, :gaussian, :cornish_fisher."))
end
