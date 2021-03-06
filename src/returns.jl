"""
    simple_returns(prices::Vector)

Calculates the simple returns series based on the provided time series of `N` prices.
Please note that a) the provided prices series should incorporate
all corporate actions, dividends etc., and b) should be regularly spaced, for example hourly or daily data.

# Arguments
- `prices`: Vector of adjusted prices accounting for all corporate actions etc.

# Returns
Vector of simple returns with size `N-1`.

# Examples
```jldoctest
julia> prices = [100.0, 101.0, 100.5, 99.8, 101.3]
5-element Array{Float64,1}:
 100.0
 101.0
 100.5
  99.8
 101.3

julia> simple_returns(prices)
4-element Array{Float64,1}:
  0.010000000000000009
 -0.004950495049504955
 -0.006965174129353269
  0.01503006012024044
```
"""
@inline function simple_returns(prices::Vector)
    a = @view prices[2:end]
    b = @view prices[1:end-1]
    (a ./ b) .- 1.0
end



"""
    simple_returns(dates::Vector{DateTime}, prices::Vector{T}; drop_overnight::Bool=false)

Calculates the simple returns series based on the provided time series of prices.
Please note that a) the provided prices series should incorporate
all corporate actions, dividends etc., and b) should be regularly spaced, for example hourly or daily data.
If the parameter `drop_overnight` is set to `true`, overnight returns will be dropped.

# Arguments
- `dates`:              Vector of `DateTime` objects for prices.
- `prices`:             Vector of adjusted prices accounting for all corporate actions etc.
- `drop_overnight`:     Boolean value indicating whether to drop overnight returns or not (default=false).

# Returns
Tuple of type `Tuple{Vector{DateTime}, Vector{T}, Vector{Int64}}` with dates, returns and indices of original time series.

# Examples
```
julia> dates = [DateTime(2020, 1, 1, 1), DateTime(2020, 1, 1, 2), DateTime(2020, 1, 2, 1), DateTime(2020, 1, 2, 2)]
4-element Array{DateTime,1}:
 2020-01-01T01:00:00
 2020-01-01T02:00:00
 2020-01-02T01:00:00
 2020-01-02T02:00:00

julia> prices = [100.0, 101.0, 100.5, 100.75]
4-element Array{Float64,1}:
 100.0
 101.0
 100.5
 100.75

julia> simple_returns(dates, prices; drop_overnight=true)
([DateTime("2020-01-01T02:00:00"), DateTime("2020-01-02T02:00:00")], [0.010000000000000009, 0.0024875621890547706], [2, 4])
```
"""
function simple_returns(
    dates           ::Vector{DateTime},
    prices          ::Vector{T};
    drop_overnight  ::Bool=false
)::Tuple{Vector{DateTime}, Vector{T}, Vector{Int64}} where T
    N = length(prices)
    if drop_overnight
        a = @view dates[2:N]
        b = @view dates[1:N-1]
        idxs = findall(vcat(false, Dates.days.(a) .== Dates.days.(b)))
        a2 = @view prices[idxs]
        b2 = @view prices[idxs .- 1]
        return dates[idxs], (a2 ./ b2) .- 1.0, idxs
    else
        return dates[2:N], simple_returns(prices), collect(2:N)
    end
end



"""
    simple_returns(prices::Matrix)

Calculates the simple returns series for each column of the provided prices matrix, where each column denotes a prices series of an asset, e.g. a stock.

Please note that a) the provided prices series should incorporate all corporate actions,
dividends etc. and b) should be regularly spaced, for example hourly or daily data.

# Arguments
- `prices`: Matrix of size `[N x k]` of adjusted prices accounting for all corporate actions etc., where each column denotes a price series of an asset, e.g. a stock.

# Returns
Matrix of simple returns with size `[(N-1) x k]`.

# Examples
```jldoctest
julia> prices = [100.0 99.0; 101.0 99.5; 100.5 99.8; 99.8 99.2; 101.3 100.0]
5??2 Array{Float64,2}:
 100.0   99.0
 101.0   99.5
 100.5   99.8
  99.8   99.2
 101.3  100.0

julia> simple_returns(prices)
4??2 Array{Float64,2}:
  0.01         0.00505051
 -0.0049505    0.00301508
 -0.00696517  -0.00601202
  0.0150301    0.00806452
```
"""
@inline function simple_returns(prices::Matrix)
    a = @view prices[2:end, :]
    b = @view prices[1:end-1, :]
    (a ./ b) .- 1.0
end



"""
    log_returns(prices::Vector)

Calculates the log-return series based on the provided time series of `N` prices.
Please note that a) the provided prices series should incorporate
all corporate actions, dividends etc., and b) should be regularly spaced, for example hourly or daily data.

# Arguments
- `prices`: Vector of adjusted prices accounting for all corporate actions etc.

# Returns
Vector of log-returns with size `N-1`.

# Examples
```jldoctest
julia> prices = [100.0, 101.0, 100.5, 99.8, 101.3]
5-element Array{Float64,1}:
 100.0
 101.0
 100.5
  99.8
 101.3

julia> log_returns(prices)
4-element Array{Float64,1}:
  0.009950330853168092
 -0.004962789342129014
 -0.006989544181712186
  0.014918227937219366
```
"""
@inline function log_returns(prices::Vector)
    a = @view prices[2:end]
    b = @view prices[1:end-1]
    log.(a ./ b)
end


"""
    log_returns(prices::Matrix)

Calculates log-return series for each column of the provided prices matrix, where each column denotes a prices series of an asset, e.g. a stock.

Please note that a) the provided prices series should incorporate all corporate actions,
dividends etc. and b) should be regularly spaced, for example hourly or daily data.

# Arguments
- `prices`: Matrix of size `[N x k]` of adjusted prices accounting for all corporate actions etc., where each column denotes a price series of an asset, e.g. a stock.

# Returns
Matrix of log-returns with size `[(N-1) x k]`.

# Examples
```jldoctest
julia> prices = [100.0 99.0; 101.0 99.5; 100.5 99.8; 99.8 99.2; 101.3 100.0]
5??2 Array{Float64,2}:
 100.0   99.0
 101.0   99.5
 100.5   99.8
  99.8   99.2
 101.3  100.0

julia> log_returns(prices)
4??2 Array{Float64,2}:
  0.00995033   0.00503779
 -0.00496279   0.00301054
 -0.00698954  -0.00603017
  0.0149182    0.00803217
```
"""
@inline function log_returns(prices::Matrix)
    a = @view prices[2:end, :]
    b = @view prices[1:end-1, :]
    log.(a ./ b)
end
