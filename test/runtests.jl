# Copyright (c) 2024 Oscar Dowson, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using Test

import Gurobi_jll

@test Gurobi_jll.is_available()

@testset "check_path_is_string" begin
    @test Gurobi_jll.libgurobi_path isa String
    @test Gurobi_jll.gurobi_cl_path isa String
    @test Gurobi_jll.grbgetkey_path isa String
end
