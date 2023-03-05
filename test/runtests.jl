using Test
using ConstructFrom

a::Vector{Int} = construct_from()
b::Vector{Int} = construct_from(undef, 3)
c::Dict{Int,Int} = construct_from(1=>0x2, 3.0=>4)