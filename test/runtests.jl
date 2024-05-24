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
    @test technicalP[] == 2
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
    error = @ccall libgurobi.GRBstartenv(envptr[]::Ptr{Cvoid})::Cint
    @test error == 10009 || error == 0
    if error == 10009
        ret = @ccall libgurobi.GRBgeterrormsg(envptr[]::Ptr{Cvoid})::Ptr{Cchar}
        @test startswith(unsafe_string(ret), "No Gurobi license found")
    end
end

@testset "open_documentation" begin
    @test isfile(Gurobi_jll.get_documentation_path())
    if Sys.isapple()
        @test Gurobi_jll._browser_command("abc") == `open abc`
        Gurobi_jll.open_documentation()
    elseif Sys.iswindows()
        @test Gurobi_jll._browser_command("abc") == `cmd /c start abc`
        Gurobi_jll.open_documentation()
    else
        @test Gurobi_jll._browser_command("abc") == `xdg-open abc`
        # Gurobi_jll.open_documentation()  # Errors in CI
    end
end
