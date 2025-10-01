"""
    value_at_risk(returns, α; method=:historical, multiplier=1.0)

Computes the Value-at-Risk (VaR) for a given significance level `α` based on the chosen estimation method. The VaR value represents the maximum expected loss at a certain significance level `α`. For a more tail-risk focused measure, see `expected_shortfall`.

Returns NaN for empty returns vector.

# Arguments
- `returns`:     Vector of asset returns.
- `α`:           Significance level, e.g. use `0.05` for 95% confidence, or `0.01` for 99% confidence.
- `method`:      Distribution estimation method: `:historical` (default), `:gaussian` or `:cornish_fisher`.
- `multiplier`:  Optional scalar multiplier, i.e. use `12` to annualize monthly returns, and use `252` to annualize daily returns.

# Methods
- `:historical`:        Historical based on empirical distribution of returns.
- `:gaussian`:          Gaussian distribution based on parametric fit (mean, variance).
- `:cornish_fisher`:    Cornish-Fisher based on Gaussian parametric distribution fit adjusted for third and fourth moments (skewness, kurtosis). Cornish-Fisher expansion aims to approximate the quantile of a true distribution by using higher moments (skewness and kurtosis) of that distribution to adjust for its non-normality. See https://thema.u-cergy.fr/IMG/pdf/2017-21.pdf for details.

# Sources
- Favre, Laurent and Galeano, Jose-Antonio (2002). Mean-Modified Value-at-Risk Optimization with Hedge Funds. Journal of Alternative Investment.
- Amédée-Manesme, Charles-Olivier and Barthélémy, Fabrice and Maillard, Didier (2017). Computation of the Corrected Cornish–Fisher Expansion using the Response Surface Methodology: Application to VaR and CVaR. THEMA Working Paper n°2017-21, Université de Cergy-Pontoise, France.
"""
function value_at_risk(returns, α; method::Symbol=:historical, multiplier=1.0)
    T = float(promote_type(eltype(returns), typeof(α)))
    isempty(returns) && return T(NaN)

    μ = T(mean(returns))
    αT = T(α)
    normal = Normal{T}(zero(T), one(T))
    base = if method == :historical
        # empirical quantile for VaR estimation
        T(quantile(returns, αT))
    elseif method == :gaussian
        # parametric Gaussian distribution fit
        σ = T(std(returns; corrected=false))
        iszero(σ) ? μ : μ + σ * quantile(normal, αT)
    elseif method == :cornish_fisher
        # third/fourth moment adjusted Gaussian distribution fit
        # http://www.diva-portal.org/smash/get/diva2:442078/FULLTEXT01.pdf
        # https://papers.ssrn.com/sol3/papers.cfm?abstract_id=1024151
        q = quantile(normal, αT)
        S = T(skewness(returns))
        K = T(kurtosis(returns; method=:excess))
        z = q + (T(1) / T(6)) * (q^2 - T(1)) * S + (T(1) / T(24)) * (q^3 - T(3) * q) * K -
            (T(1) / T(36)) * (T(2) * q^3 - T(5) * q) * (S^2)
        σ = T(std(returns; corrected=false))
        iszero(σ) ? μ : μ + z * σ
    else
        throw(
            ArgumentError(
                "Passed method parameter '$(method)' is invalid, must be one of :historical, :gaussian, :cornish_fisher.",
            ),
        )
    end

    m = T(multiplier)
    m == one(T) && return base
    μ * m + sqrt(m) * (base - μ)
end
