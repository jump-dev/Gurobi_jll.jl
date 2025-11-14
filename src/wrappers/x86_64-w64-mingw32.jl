# Copyright (c) 2024 Oscar Dowson, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

export gurobi_cl, grbgetkey, libgurobi

JLLWrappers.@generate_wrapper_header("Gurobi")

JLLWrappers.@declare_library_product(libgurobi, "gurobi130.dll")

JLLWrappers.@declare_executable_product(gurobi_cl)

JLLWrappers.@declare_executable_product(grbgetkey)

function __init__()
    JLLWrappers.@generate_init_header()
    JLLWrappers.@init_library_product(
        libgurobi,
        joinpath("gurobi1300", "win64", "bin", "gurobi130.dll"),
        RTLD_LAZY | RTLD_DEEPBIND,
    )
    JLLWrappers.@init_executable_product(gurobi_cl, joinpath("gurobi1300", "win64", "bin", "gurobi_cl.exe"))
    JLLWrappers.@init_executable_product(grbgetkey, joinpath("gurobi1300", "win64", "bin", "grbgetkey.exe"))
    JLLWrappers.@generate_init_footer()
    return
end  # __init__()
