module ConstructFrom

export construct_from

struct Arguments{A,K}
    args::A
    kwargs::K
end

"""
    construct_from(args...; kwargs...)

Construct an object without spelling out its type if the type can be inferred
from context.

# Examples

```julia-repl
julia> vec::Vector{Vector{Int}} = construct_from(undef, 3);

julia> vec
3-element Vector{Vector{Int64}}:
 #undef
 #undef
 #undef
```
"""
construct_from(args...; kwargs...) = Arguments{typeof(args), typeof(kwargs)}(args, kwargs)

Base.convert(::Type{T}, c::Arguments) where T = T(c.args...; c.kwargs...)
Base.convert(::Type{Any}, c::Arguments) = c

function Base.show(io::IO, c::Arguments)
    lock(io)
    try
        print(io, "construct_from(")
        join(io, c.args, ", ")
        if !isempty(c.kwargs)
            print(io, "; ")
            join(io, Iterators.map(p -> string(p[1], " = ", p[2]), c.kwargs), ", ")
        end
        print(io, ")")
    finally
        unlock(io)
    end
end

end # module ConstructFrom
