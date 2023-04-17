# ConstructFrom.jl

Construct objects without spelling out their types if the types can be inferred from context.

```julia
julia> vec::Vector{Vector{Int}} = construct_from(undef, 3);

julia> vec
3-element Vector{Vector{Int64}}:
 #undef
 #undef
 #undef
```

`construct_from()` may be useful in a number of circumstances.

- When defining default values for function arguments.
  ```julia
  foo(data::Vector{Int} = construct_from()) = ...
  ```

- When defining default values for fields of `@kwdef` structs.
  ```julia
  Base.@kwdef struct Foo
      data::Vector{Int} = construct_from()
  end
  ```

- When initializing typed globals.
  ```julia
  data::Vector{Int} = construct_from()
  ```

- When providing a default value for dictionary lookups.
  ```julia
  dict = Dict{Int, Vector{Int}}()
  get(dict, 42, construct_from())
  ```

---

**Note.** `construct_from()` exploits that Julia inserts an implicit `convert()` in many circumstances. (Most prominently, `a::T = b` is syntactic sugar for `a = typeassert(convert(T, b), T)`.) Correspondingly, `construct_from()` fails in cases where there is no conversion, or the conversion happens too late.

- No conversion:

  ```julia
  julia> foo(data::Vector{Int}) = data;

  julia> # Doesn't work because no conversion
         foo(construct_from())
  ERROR: MethodError: no method matching foo(::ConstructFrom.Arguments{...})

  julia> # Let's add the conversion ourselves
         foo(data) = foo(convert(Vector{Int}, data));

  julia> # Now it works
         foo(construct_from())
  Int64[]
  ```

- Conversion happens too late:
  ```julia
  julia> a = construct_from()
         push!(a, 42) # <- Julia won't deduce the type of `a` from how it's used later
         b::Vector{Int} = a
  ERROR: MethodError: no method matching push!(::ConstructFrom.Arguments{...}, ::Int64)
  ```