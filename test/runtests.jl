# Copyright (c) 2024 Oscar Dowson, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using Test

using Gurobi_jll

@testset "is_available" begin
    @test Gurobi_jll.is_available()
end

@testset "libgurobi" begin
    @test Gurobi_jll.libgurobi_path isa String
    majorP, minorP, technicalP = Ref{Cint}(), Ref{Cint}(), Ref{Cint}()
    @ccall libgurobi.GRBversion(
        majorP::Ptr{Cint},
        minorP::Ptr{Cint},
        technicalP::Ptr{Cint},
    )::Cvoid
    # Update these values when you update Artifacts.toml
    @test majorP[] == 11
    @test minorP[] == 0
    @test technicalP[] == 1
end

@testset "gurobi_cl" begin
    @test Gurobi_jll.gurobi_cl_path isa String
    contents = sprint(io -> run(pipeline(`$(gurobi_cl()) -v`, stdout = io)))
    if Sys.iswindows()
        # Is there an issue flushing `io`? Returns `""`
        @test contents == ""
    else
        @test occursin("Gurobi Optimizer", contents)
    end
end

@testset "grbgetkey" begin
    @test Gurobi_jll.grbgetkey_path isa String
end

@testset "license_error" begin
    envptr = Ref{Ptr{Cvoid}}()
    error = @ccall libgurobi.GRBemptyenv(envptr::Ptr{Ptr{Cvoid}})::Cint
    @test error == 0
    error = @ccall libgurobi.GRBstartenv(envptr.x::Ptr{Cvoid})::Cint
    @test error == 10009
    msg = unsafe_string(@ccall libgurobi.GRBgeterrormsg(envptr.x::Ptr{Cvoid})::Ptr{Cchar})
    @test startswith(msg, "No Gurobi license found")
end
