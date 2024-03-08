# Copyright (c) 2024 Oscar Dowson, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using Test

import Gurobi_jll

@testset "is_available" begin
    @test Gurobi_jll.is_available()
end

@testset "libgurobi" begin
    @test Gurobi_jll.libgurobi_path isa String
    majorP, minorP, technicalP = Ref{Cint}(), Ref{Cint}(), Ref{Cint}()
    @ccall Gurobi_jll.libgurobi.GRBversion(
        majorP::Ptr{Cint},
        minorP::Ptr{Cint},
        technicalP::Ptr{Cint},
    )::Cvoid
    # Update these values when you update Artifacts.toml
    @test majorP[] == 11
    @test minorP[] == 0
    @test technicalP[] == 0
end

@testset "gurobi_cl" begin
    @test Gurobi_jll.gurobi_cl_path isa String
    contents = sprint() do io
        return run(pipeline(`$(Gurobi_jll.gurobi_cl()) -v`, stdout = io))
    end
    if !Sys.iswindows()
        @test occursin("Gurobi Optimizer", contents)
    end
end

@testset "grbgetkey" begin
    @test Gurobi_jll.grbgetkey_path isa String
end
