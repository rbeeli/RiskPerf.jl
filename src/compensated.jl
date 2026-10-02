# Neumaier-compensated summation for first-order sums: means, excess means, log-return sums,
# tail means, and third central moments. Squares and fourth powers keep plain sequential sums.

@inline function _compensated_add(total::T, correction::T, value::T) where {T}
    next_total = total + value
    isfinite(next_total) || return next_total, zero(T)
    correction += abs(total) >= abs(value) ? (total - next_total) + value : (value - next_total) + total
    return next_total, correction
end

"""Compensated sum of `f(value)` over `values`, accumulated in type `T`."""
function _compensated_sum(f, values, ::Type{T}) where {T}
    total = zero(T)
    correction = zero(T)
    for value in values
        total, correction = _compensated_add(total, correction, T(f(value)))
    end
    return total + correction
end

_compensated_sum(values, ::Type{T}) where {T} = _compensated_sum(identity, values, T)

"""Compensated mean of `values`, or `NaN` for an empty input."""
function _compensated_mean(values, ::Type{T}=float(eltype(values))) where {T}
    isempty(values) && return T(NaN)
    return _compensated_sum(values, T) / T(length(values))
end
