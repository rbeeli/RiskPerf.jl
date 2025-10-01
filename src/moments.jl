"""
    skewness(x; method=:moment)

Calculates the skewness using the specified method.

# Methods
- Moment (default)
- Fisher-Pearson
- Sample

# Arguments
- `x`:          Vector of values.
- `method`:     Estimation method: `:moment`, `:fisher_pearson` or `:sample`.
"""
function skewness(x; method::Symbol=:moment)
    n = length(x)
    T = float(eltype(x))
    n == 0 && return T(NaN)
    μ = T(mean(x))
    # Two-pass accumulation to avoid temporaries
    s2 = zero(T)
    s3 = zero(T)
    @inbounds @simd for i in eachindex(x)
        xi = T(x[i])
        d = xi - μ
        d2 = d * d
        s2 += d2
        s3 += d2 * d
    end
    tn = T(n)
    m2 = s2 / tn
    m3 = s3 / tn
    # sqrt(x)^3 faster than x^1.5 !
    denom = sqrt(m2)^3

    if method == :moment
        # Standardized moment coefficient
        return m3 / denom
    elseif method == :fisher_pearson
        # Fisher-Pearson standardized moment coefficient
        if n > 2
            return sqrt(tn * T(n - 1)) / T(n - 2) * (m3 / denom)
        else
            return T(NaN)
        end
    elseif method == :sample
        # Sample skewness
        num = tn
        den = T(n - 1) * T(n - 2)
        return num / den * (s3 / denom)
    end

    throw(
        ArgumentError(
            "Passed method parameter '$(method)' is invalid, must be one of :moment, :fisher_pearson, :sample.",
        ),
    )
end

"""
    kurtosis(x; method=:excess)

Calculates the kurtosis using on the specified method.

# Methods
- Excess (default)
- Moment
- Cornish-Fisher

# Arguments
- `x`:          Vector of values.
- `method`:     Estimation method: `:excess`, `:moment` or `:cornish_fisher`.
"""
function kurtosis(x; method::Symbol=:excess)
    n = length(x)
    T = float(eltype(x))
    n == 0 && return T(NaN)
    tn = T(n)
    if method == :cornish_fisher
        s2 = zero(T)
        s4 = zero(T)
        @inbounds @simd for xi in x
            val = T(xi)
            x2 = val * val
            s2 += x2
            s4 += x2 * x2
        end
        m2 = s2 / tn
        m4 = s4 / tn
        num = (T(n + 1)) * T(n - 1)
        adj = m4 / (m2^2) - (T(3) * T(n - 1)) / T(n + 1)
        return num * adj / (T(n - 2) * T(n - 3))
    elseif method == :moment || method == :excess
        μ = T(mean(x))
        s2 = zero(T)
        s4 = zero(T)
        @inbounds @simd for xi in x
            val = T(xi)
            d = val - μ
            d2 = d * d
            s2 += d2
            s4 += d2 * d2
        end
        m2 = s2 / tn
        m4 = s4 / tn
        k = m4 / (m2^2)
        return method == :moment ? k : (k - T(3))
    else
        throw(
            ArgumentError(
                "Passed method parameter '$(method)' is invalid, must be one of :excess, :moment, :cornish_fisher.",
            ),
        )
    end
end

"""
    lower_partial_moment(returns, threshold, n, method)

This function calculates the Lower Partial Moment (LPM) for a given threshold.
Returns 0.0 when the denominator is zero (no-tail or empty returns).

# Arguments
- `returns`:     Vector of asset returns.
- `threshold`:   Scalar value of the threshold return.
- `n`:           `n`-th moment to calculate.
- `method`:      One of `:full` or `:partial`. Indicates whether to use the number of all returns (`:full`),
                 or only the number of returns below the threshold (`:partial`) in the denominator.

# Formula
    
``\\text{LPM}_n = \\frac{1}{D} \\sum_{i=1}^N \\max(0, \\text{threshold} - \\text{returns}_i)^n``

where `N` is the number of returns, and `D` is the denominator.
"""
function lower_partial_moment(returns::AbstractVector, threshold::Real, n, method::Symbol)
    T = float(promote_type(eltype(returns), typeof(threshold)))
    thr = T(threshold)
    if method == :full
        denom = length(returns)
        denom == 0 && return zero(T)
        s = zero(T)
        @inbounds @simd for ri in returns
            d = thr - T(ri)
            if d > 0
                s += d^n
            end
        end
        return s / T(denom)
    elseif method == :partial
        s = zero(T)
        cnt = 0
        @inbounds for ri in returns
            d = thr - T(ri)
            if d > 0
                s += d^n
                cnt += 1
            end
        end
        return cnt == 0 ? zero(T) : s / T(cnt)
    else
        throw(
            ArgumentError(
                "Passed method parameter '$(method)' is invalid, must be one of :full, :partial."
            ),
        )
    end
end

"""
    lower_partial_moment(returns, threshold, n, method)

This function calculates the Lower Partial Moment (LPM) for a given threshold.
Returns 0.0 when the denominator is zero (no-tail or empty returns).

# Arguments
- `returns`:     Vector of asset returns.
- `threshold`:   Vector denoting the threshold returns.
- `n`:           `n`-th moment to calculate.
- `method`:      One of `:full` or `:partial`. Indicates whether to use the number of all returns (`:full`),
                 or only the number of returns below the threshold (`:partial`) in the denominator.

# Formula
    
``\\text{LPM}_n = \\frac{1}{D} \\sum_{i=1}^N \\max(0, \\text{threshold} - \\text{returns}_i)^n``

where `N` is the number of returns, and `D` is the denominator.
"""
function lower_partial_moment(returns::AbstractVector, threshold::AbstractVector, n, method::Symbol)
    length(returns) == length(threshold) ||
        throw(ArgumentError("returns and threshold must have same length"))
    T = float(promote_type(eltype(returns), eltype(threshold)))
    if method == :full
        denom = length(returns)
        denom == 0 && return zero(T)
        s = zero(T)
        @inbounds @simd for i in eachindex(returns, threshold)
            d = T(threshold[i]) - T(returns[i])
            if d > 0
                s += d^n
            end
        end
        return s / T(denom)
    elseif method == :partial
        s = zero(T)
        cnt = 0
        @inbounds for i in eachindex(returns, threshold)
            d = T(threshold[i]) - T(returns[i])
            if d > 0
                s += d^n
                cnt += 1
            end
        end
        return cnt == 0 ? zero(T) : s / T(cnt)
    else
        throw(
            ArgumentError(
                "Passed method parameter '$(method)' is invalid, must be one of :full, :partial."
            ),
        )
    end
end

"""
    higher_partial_moment(returns, threshold, n, method)

This function calculates the Higher Partial Moment (HPM) for a given threshold.
Returns 0.0 when the denominator is zero (no-tail or empty returns).

# Arguments
- `returns`:     Vector of asset returns.
- `threshold`:   Scalar value of the threshold return.
- `n`:           `n`-th moment to calculate.
- `method`:      One of `:full` or `:partial`. Indicates whether to use the number of all returns (`:full`),
                 or only the number of returns above the threshold (`:partial`) in the denominator.

# Formula

``\\text{HPM}_n = \\frac{1}{D} \\sum_{i=1}^N \\max(0, \\text{returns}_i - \\text{threshold})^n``

where `N` is the number of returns, and `D` is the denominator.
"""
function higher_partial_moment(returns::AbstractVector, threshold::Real, n, method::Symbol)
    T = float(promote_type(eltype(returns), typeof(threshold)))
    thr = T(threshold)
    if method == :full
        denom = length(returns)
        denom == 0 && return zero(T)
        s = zero(T)
        @inbounds @simd for ri in returns
            d = T(ri) - thr
            if d > 0
                s += d^n
            end
        end
        return s / T(denom)
    elseif method == :partial
        s = zero(T)
        cnt = 0
        @inbounds for ri in returns
            d = T(ri) - thr
            if d > 0
                s += d^n
                cnt += 1
            end
        end
        return cnt == 0 ? zero(T) : s / T(cnt)
    else
        throw(
            ArgumentError(
                "Passed method parameter '$(method)' is invalid, must be one of :full, :partial."
            ),
        )
    end
end

"""
    higher_partial_moment(returns, threshold, n, method)

This function calculates the Higher Partial Moment (HPM) for a given threshold.
Returns 0.0 when the denominator is zero (no-tail or empty returns).

# Arguments
- `returns`:     Vector of asset returns.
- `threshold`:   Vector denoting the threshold returns.
- `n`:           `n`-th moment to calculate.
- `method`:      One of `:full` or `:partial`. Indicates whether to use the number of all returns (`:full`),
                 or only the number of returns above the threshold (`:partial`) in the denominator.

# Formula

``\\text{HPM}_n = \\frac{1}{D} \\sum_{i=1}^N \\max(0, \\text{returns}_i - \\text{threshold})^n``

where `N` is the number of returns, and `D` is the denominator.
"""
function higher_partial_moment(
    returns::AbstractVector, threshold::AbstractVector, n, method::Symbol
)
    length(returns) == length(threshold) ||
        throw(ArgumentError("returns and threshold must have same length"))
    T = float(promote_type(eltype(returns), eltype(threshold)))
    if method == :full
        denom = length(returns)
        denom == 0 && return zero(T)
        s = zero(T)
        @inbounds @simd for i in eachindex(returns, threshold)
            d = T(returns[i]) - T(threshold[i])
            if d > 0
                s += d^n
            end
        end
        return s / T(denom)
    elseif method == :partial
        s = zero(T)
        cnt = 0
        @inbounds for i in eachindex(returns, threshold)
            d = T(returns[i]) - T(threshold[i])
            if d > 0
                s += d^n
                cnt += 1
            end
        end
        return cnt == 0 ? zero(T) : s / T(cnt)
    else
        throw(
            ArgumentError(
                "Passed method parameter '$(method)' is invalid, must be one of :full, :partial."
            ),
        )
    end
end
