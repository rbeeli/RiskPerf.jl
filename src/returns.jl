"""
    simple_returns(prices::Vector; drop_first=false, first_value=NaN)

Calculates the simple returns series based on the provided time series of `N` prices.
Please note that the provided prices series should be regularly spaced, for example hourly or daily data.

# Formula

``r_t = \\dfrac{P_t}{P_{t-1}} - 1``

where ``r_t`` is the return at time ``t``, ``P_t`` is the price at time ``t``, and ``P_{t-1}`` is the price at time ``t-1``.

# Arguments
- `prices`: Vector of prices.
- `drop_first`: Boolean value indicating whether to drop the first return or not (default=false).
- `first_value`: Value to be used for the first return if `drop_first=false`.

# Examples
```jldoctest
julia> using RiskPerf

julia> prices = [100.0, 101.0, 100.5, 99.8, 101.3]
5-element Vector{Float64}:
 100.0
 101.0
 100.5
  99.8
 101.3

julia> simple_returns(prices)
5-element Vector{Float64}:
 NaN
   0.010000000000000009
  -0.004950495049504955
  -0.006965174129353269
   0.01503006012024044

julia> simple_returns(prices; drop_first=true)
4-element Vector{Float64}:
  0.010000000000000009
 -0.004950495049504955
 -0.006965174129353269
  0.01503006012024044
```
"""
function simple_returns(prices::T; drop_first=false, first_value=NaN) where {T<:AbstractVector}
    n = length(prices)
    Tres = float(eltype(prices))

    if drop_first
        out = similar(prices, Tres, max(n - 1, 0))
        @inbounds for i in 2:n
            pi = Tres(prices[i])
            pj = Tres(prices[i - 1])
            out[i - 1] = pi / pj - one(Tres)
        end
        return out
    else
        out = similar(prices, Tres, n)
        n == 0 && return out
        out[1] = convert(Tres, first_value)
        @inbounds for i in 2:n
            pi = Tres(prices[i])
            pj = Tres(prices[i - 1])
            out[i] = pi / pj - one(Tres)
        end
        return out
    end
end

# """
#     simple_returns(dates::Vector{DateTime}, prices::Vector{T}; drop_overnight::Bool=false)

# Calculates the simple returns series based on the provided time series of prices.
# Please note that the provided prices series should be regularly spaced, for example hourly or daily data.
# If the parameter `drop_overnight` is set to `true`, overnight returns will be dropped.

# # Arguments
# - `dates`:              Vector of `DateTime` objects for prices.
# - `prices`:             Vector of prices.
# - `drop_overnight`:     Boolean value indicating whether to drop overnight returns or not (default=false).

# # Returns
# Tuple of type `Tuple{Vector{DateTime}, Vector{T}, Vector{Int64}}` with dates, returns and indices of original time series.

# # Examples
# ```
# julia> using RiskPerf

# julia> dates = [DateTime(2020, 1, 1, 1), DateTime(2020, 1, 1, 2), DateTime(2020, 1, 2, 1), DateTime(2020, 1, 2, 2)]
# 4-element Array{DateTime,1}:
#  2020-01-01T01:00:00
#  2020-01-01T02:00:00
#  2020-01-02T01:00:00
#  2020-01-02T02:00:00

# julia> prices = [100.0, 101.0, 100.5, 100.75]
# 4-element Vector{Float64}:
#  100.0
#  101.0
#  100.5
#  100.75

# julia> simple_returns(dates, prices; drop_overnight=true)
# ([DateTime("2020-01-01T02:00:00"), DateTime("2020-01-02T02:00:00")], [0.010000000000000009, 0.0024875621890547706], [2, 4])
# ```
# """
# function simple_returns(
#     dates           ::Vector{DateTime},
#     prices          ::Vector{T};
#     drop_overnight  ::Bool=false
# )::Tuple{Vector{DateTime}, Vector{T}, Vector{Int64}} where T
#     N = length(prices)
#     if drop_overnight
#         a = @view dates[2:N]
#         b = @view dates[1:N-1]
#         idxs = findall(vcat(false, Dates.days.(a) .== Dates.days.(b)))
#         a2 = @view prices[idxs]
#         b2 = @view prices[idxs .- 1]
#         dates[idxs], (a2 ./ b2) .- 1.0, idxs
#     else
#         dates[2:N], simple_returns(prices), collect(2:N)
#     end
# end

"""
    simple_returns(prices::Matrix; drop_first=false, first_value=NaN)

Calculates the simple returns series for each column of the provided prices matrix,
where each column denotes a prices series of an asset, e.g. a stock.

Please note that the provided prices series should be regularly spaced,
for example hourly or daily data.

# Arguments
- `prices`: Matrix of size `[N x k]` where each column denotes a price series of an asset, e.g. a stock.
- `drop_first`: Boolean value indicating whether to drop the first return or not (default=false).
- `first_value`: Value to be used for the first return if `drop_first=false`.

# Formula

``r_{t, i} = \\dfrac{P_{t, i}}{P_{t-1, i}} - 1``

where ``r_{t, i}`` is the return at time ``t`` for asset ``i``, ``P_{t, i}`` is the price at time ``t`` for asset ``i``, and ``P_{t-1, i}`` is the price at time ``t-1`` for asset ``i``.

# Examples
```jldoctest
julia> using RiskPerf

julia> prices = [100.0 99.0; 101.0 99.5; 100.5 99.8; 99.8 99.2; 101.3 100.0]
5×2 Matrix{Float64}:
 100.0   99.0
 101.0   99.5
 100.5   99.8
  99.8   99.2
 101.3  100.0

julia> simple_returns(prices)
5×2 Matrix{Float64}:
 NaN           NaN
   0.01          0.00505051
  -0.0049505     0.00301508
  -0.00696517   -0.00601202
   0.0150301     0.00806452

julia> simple_returns(prices; drop_first=true)
4×2 Matrix{Float64}:
  0.01         0.00505051
 -0.0049505    0.00301508
 -0.00696517  -0.00601202
  0.0150301    0.00806452
```
"""
function simple_returns(prices::T; drop_first=false, first_value=NaN) where {T<:AbstractMatrix}
    n1, n2 = size(prices)
    Tres = float(eltype(prices))

    if drop_first
        out = similar(prices, Tres, max(n1 - 1, 0), n2)
        @inbounds for j in 1:n2, i in 2:n1
            pi = Tres(prices[i, j])
            pj = Tres(prices[i - 1, j])
            out[i - 1, j] = pi / pj - one(Tres)
        end
        return out
    else
        out = similar(prices, Tres, n1, n2)
        n1 == 0 && return out
        fv = convert(Tres, first_value)
        out[1, :] .= fv
        @inbounds for j in 1:n2, i in 2:n1
            pi = Tres(prices[i, j])
            pj = Tres(prices[i - 1, j])
            out[i, j] = pi / pj - one(Tres)
        end
        return out
    end
end

"""
    mean_excess(x, y)

Compute the mean of the elementwise difference `x - y` without allocating
intermediate arrays. Supports `y::Real` (scalar) and `y::AbstractArray` with
matching length. Returns a floating result with a promoted accumulation type.

This is a fast replacement for patterns like `mean(x .- y)`.
"""
function mean_excess(x::AbstractArray, y::Real)
    n = length(x)
    n == 0 && throw(ArgumentError("mean of empty collection"))
    T = float(promote_type(eltype(x), typeof(y)))
    s = zero(T)
    Ty = T(y)
    @inbounds @simd for i in eachindex(x)
        s += T(x[i]) - Ty
    end
    return s / T(n)
end

"""
    mean_excess(x, y)

Compute the mean of the elementwise difference `x - y` without allocating
intermediate arrays. Supports `y::Real` (scalar) and `y::AbstractArray` with
matching length. Returns a floating result with a promoted accumulation type.

This is a fast replacement for patterns like `mean(x .- y)`.
"""
function mean_excess(x::AbstractArray, y::AbstractArray)
    @assert length(x) == length(y)
    n = length(x)
    n == 0 && throw(ArgumentError("mean of empty collection"))
    T = float(promote_type(eltype(x), eltype(y)))
    s = zero(T)
    @inbounds @simd for i in eachindex(x, y)
        s += T(x[i]) - T(y[i])
    end
    return s / T(n)
end

"""
    std_excess(x, y; corrected=true)

Compute the standard deviation of the elementwise difference `x - y` without
allocating intermediates. Supports `y::Real` (scalar) and `y::AbstractArray`
with matching length. Mirrors `Statistics.std` semantics for `corrected`.
"""
function std_excess(x::AbstractArray, y::Real; corrected::Bool=true)
    n = length(x)
    n == 0 && throw(ArgumentError("std of empty collection"))
    T = float(promote_type(eltype(x), typeof(y)))
    m = mean_excess(x, y)
    Ty = T(y)
    ss = zero(T)
    @inbounds @simd for i in eachindex(x)
        d = T(x[i]) - Ty - m
        ss = muladd(d, d, ss)
    end
    return corrected ? (n > 1 ? sqrt(ss / T(n - 1)) : T(NaN)) : sqrt(ss / T(n))
end

function std_excess(x::AbstractArray, y::AbstractArray; corrected::Bool=true)
    @assert length(x) == length(y)
    n = length(x)
    n == 0 && throw(ArgumentError("std of empty collection"))
    T = float(promote_type(eltype(x), eltype(y)))
    m = mean_excess(x, y)
    ss = zero(T)
    @inbounds @simd for i in eachindex(x, y)
        d = T(x[i]) - T(y[i]) - m
        ss = muladd(d, d, ss)
    end
    return corrected ? (n > 1 ? sqrt(ss / T(n - 1)) : T(NaN)) : sqrt(ss / T(n))
end

"""
    log_returns(prices::Vector; drop_first=false, first_value=NaN)

Calculates the log-return series based on the provided time series of `N` prices.
Please note that the provided prices series should be regularly spaced, for example hourly or daily data.

# Arguments
- `prices`: Vector of prices.
- `drop_first`: Boolean value indicating whether to drop the first return or not (default=false).
- `first_value`: Value to be used for the first return if `drop_first=false`.

# Formula

``r_t = \\log\\left(\\dfrac{P_t}{P_{t-1}}\\right)``

where ``r_t`` is the return at time ``t``, ``P_t`` is the price at time ``t``, and ``P_{t-1}`` is the price at time ``t-1``.

# Examples
```jldoctest
julia> using RiskPerf

julia> prices = [100.0, 101.0, 100.5, 99.8, 101.3]
5-element Vector{Float64}:
 100.0
 101.0
 100.5
  99.8
 101.3

julia> log_returns(prices)
5-element Vector{Float64}:
 NaN
   0.009950330853168092
  -0.004962789342129014
  -0.006989544181712186
   0.014918227937219366

julia> log_returns(prices; drop_first=true)
4-element Vector{Float64}:
  0.009950330853168092
 -0.004962789342129014
 -0.006989544181712186
  0.014918227937219366
```
"""
function log_returns(prices::T; drop_first=false, first_value=NaN) where {T<:AbstractVector}
    if drop_first
        a = @view prices[2:end]
        b = @view prices[1:(end - 1)]
        log.(a ./ b)
    else
        res = similar(prices)
        a = @view prices[2:end]
        b = @view prices[1:(end - 1)]
        res[2:end] .= log.(a ./ b)
        res[1] = first_value
        res
    end
end

"""
    log_returns(prices::Matrix; drop_first=false, first_value=NaN)

Calculates log-return series for each column of the provided prices matrix, where each column denotes a prices series of an asset, e.g. a stock.

Please note that the provided prices series should be regularly spaced, for example hourly or daily data.

# Arguments
- `prices`: Matrix of size `[N x k]` of prices, where each column denotes a price series of an asset, e.g. a stock.
- `drop_first`: Boolean value indicating whether to drop the first return or not (default=false).
- `first_value`: Value to be used for the first return if `drop_first=false`.

# Formula

``r_{t, i} = \\log\\left(\\dfrac{P_{t, i}}{P_{t-1, i}}\\right)``

where ``r_{t, i}`` is the return at time ``t`` for asset ``i``, ``P_{t, i}`` is the price at time ``t`` for asset ``i``, and ``P_{t-1, i}`` is the price at time ``t-1`` for asset ``i``.

# Examples
```jldoctest
julia> using RiskPerf

julia> prices = [100.0 99.0; 101.0 99.5; 100.5 99.8; 99.8 99.2; 101.3 100.0]
5×2 Matrix{Float64}:
 100.0   99.0
 101.0   99.5
 100.5   99.8
  99.8   99.2
 101.3  100.0

julia> log_returns(prices)
5×2 Matrix{Float64}:
 NaN           NaN
   0.00995033    0.00503779
  -0.00496279    0.00301054
  -0.00698954   -0.00603017
   0.0149182     0.00803217

julia> log_returns(prices; drop_first=true)
4×2 Matrix{Float64}:
  0.00995033   0.00503779
 -0.00496279   0.00301054
 -0.00698954  -0.00603017
  0.0149182    0.00803217
```
"""
function log_returns(prices::T; drop_first=false, first_value=NaN) where {T<:AbstractMatrix}
    if drop_first
        a = @view prices[2:end, :]
        b = @view prices[1:(end - 1), :]
        log.(a ./ b)
    else
        res = similar(prices)
        a = @view prices[2:end, :]
        b = @view prices[1:(end - 1), :]
        res[2:end, :] .= log.(a ./ b)
        res[1, :] .= first_value
        res
    end
end

"""
    total_return(returns::AbstractVector; method=:simple)

Calculates the total compounded return for a series of returns.

# Arguments
- `returns`: Vector of simple or log returns.
- `method`: Either `:simple` (default) when `returns` are simple returns, or `:log` when they are log returns.

# Formula

For simple returns:

``R_{total} = \\prod_{i=1}^N (1 + r_i) - 1``

For log returns:

``R_{total} = \\exp\\left( \\sum_{i=1}^N r_i \\right) - 1``

# Examples
```jldoctest
julia> using RiskPerf

julia> simple = [0.01, -0.02, 0.015];

julia> total_return(simple)
0.004100999999999987

julia> logret = log.(1 .+ simple);

julia> total_return(logret; method=:log)
0.004100999999999987
```
"""
function total_return(returns::AbstractVector; method::Symbol=:simple)
    T = promote_type(eltype(returns), Float64)
    if method == :simple
        total = one(T)
        for r in returns
            total *= one(T) + T(r)
        end
        return total - one(T)
    elseif method == :log
        sum_logs = zero(T)
        for r in returns
            sum_logs += T(r)
        end
        return exp(sum_logs) - one(T)
    end

    throw(ArgumentError("Invalid method $(method). Use :simple or :log."))
end

"""
    cagr(returns::AbstractVector; periods_per_year, method=:simple)

Compute the Compound Annual Growth Rate (CAGR) from a series of periodic returns.
Supports either simple returns (`method = :simple`) or log returns (`method = :log`).

`periods_per_year` specifies how many return observations correspond to one year
(e.g. 252 for daily, 12 for monthly, 52 for weekly). The observation frequency
is inferred as `length(returns) / periods_per_year` years of data.

# Arguments
- `returns`: Vector of periodic simple or log returns.
- `periods_per_year`: Number of periods per year (e.g. 252, 12, 52).
- `method`: `:simple` (default) if `returns` are simple returns, `:log` if they are log returns.

# Formula

Let `N = length(returns)` and `Y = N / periods_per_year` be the number of years
spanned by the data. Then

For simple returns:
``CAGR = \\left( \\prod_{i=1}^{N} (1 + r_i) \\right)^{1 / Y} - 1 = \\exp\\left(\\frac{\\sum_{i=1}^{N} \\log(1+r_i)}{Y}\\right) - 1``

For log returns:
``CAGR = \\exp\\left( \\frac{\\sum_{i=1}^{N} r_i}{Y} \\right) - 1``

# Edge Cases
- Returns `0.0` if `returns` is empty.
- Throws `ArgumentError` on invalid `method`.

# Examples
```jldoctest
julia> using RiskPerf

julia> monthly_r = fill((1.5)^(1/36) - 1, 36);  # 3 years of monthly returns growing total 50%

julia> cagr(monthly_r; periods_per_year=12)
0.1447146268169922  # ≈ (1.5)^(1/3) - 1

julia> log_monthly = log.(1 .+ monthly_r);

julia> cagr(log_monthly; periods_per_year=12, method=:log) ≈ cagr(monthly_r; periods_per_year=12)
true
```
"""
function cagr(returns::AbstractVector; periods_per_year::Real, method::Symbol=:simple)
    n = length(returns)
    n == 0 && return 0.0
    ppy = float(periods_per_year)
    (!isfinite(ppy) || ppy <= 0) && throw(
        ArgumentError(
            "periods_per_year must be positive and finite (got $(periods_per_year)).",
        ),
    )
    years = n / ppy
    T = promote_type(eltype(returns), Float64)

    if method == :simple
        # Use log1p for better numerical stability than direct product
        sum_logs = zero(T)
        @inbounds for r in returns
            sum_logs += log1p(T(r))
        end
        return exp(sum_logs / T(years)) - one(T)
    elseif method == :log
        sum_logs = zero(T)
        @inbounds for r in returns
            sum_logs += T(r)
        end
        return exp(sum_logs / T(years)) - one(T)
    end

    throw(ArgumentError("Invalid method $(method). Use :simple or :log."))
end
