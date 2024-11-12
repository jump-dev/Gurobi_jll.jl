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
    @test majorP[] == 12
    @test minorP[] == 0
    @test technicalP[] == 0
end

@testset "gurobi_cl" begin
    @test Gurobi_jll.gurobi_cl_path isa String
    contents = sprint(io -> run(pipeline(`$(gurobi_cl()) -v`, stdout = io)))
    if Sys.iswindows()
        # Is there an issue flushing `io`? Some versions return `""`
        @test occursin("Gurobi Optimizer", contents) || isempty(contents)
    else
        @test occursin("Gurobi Optimizer", contents)
    end
end

@testset "grbgetkey" begin
    @test Gurobi_jll.grbgetkey_path isa String
end

@testset "license_error" begin
    envptr = Ref{Ptr{Cvoid}}()
    # Temporary workaround for 12.0.0. This can be reverted to use GRBemptyenv for 12.0.1
    # https://docs.gurobi.com/projects/optimizer/en/12.0/reference/releasenotes/knownbugs.html
    #
    # This does not affect usage in Gurobi.jl because it defines the function
    # 
    # function GRBemptyenv(envP)
    #     return GRBemptyenvinternal(
    #         envP,
    #         GRB_VERSION_MAJOR,
    #         GRB_VERSION_MINOR,
    #         GRB_VERSION_TECHNICAL,
    #     )
    # end
    error = @ccall libgurobi.GRBemptyenvinternal(envptr::Ptr{Ptr{Cvoid}}, 12::Int, 0::Int, 0::Int)::Cint
    @test error == 0
    error = @ccall libgurobi.GRBstartenv(envptr[]::Ptr{Cvoid})::Cint
    @test error == 10009 || error == 0
    if error == 10009
        ret = @ccall libgurobi.GRBgeterrormsg(envptr[]::Ptr{Cvoid})::Ptr{Cchar}
        @test startswith(unsafe_string(ret), "No Gurobi license found")
    end
end
