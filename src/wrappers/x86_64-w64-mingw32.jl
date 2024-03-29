# Copyright (c) 2024 Oscar Dowson, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

export gurobi_cl, grbgetkey, libgurobi

JLLWrappers.@generate_wrapper_header("Gurobi")

JLLWrappers.@declare_library_product(libgurobi, "gurobi110.dll")

JLLWrappers.@declare_executable_product(gurobi_cl)

JLLWrappers.@declare_executable_product(grbgetkey)

function __init__()
    JLLWrappers.@generate_init_header()
    # There's a permission error with the conda binaries
    chmod(dirname(dirname(artifact_dir)), 0o755; recursive = true)
    JLLWrappers.@init_library_product(
        libgurobi,
        "gurobi110.dll",
        RTLD_LAZY | RTLD_DEEPBIND,
    )
    JLLWrappers.@init_executable_product(gurobi_cl, "gurobi_cl.exe")
    JLLWrappers.@init_executable_product(grbgetkey, "grbgetkey.exe")
    JLLWrappers.@generate_init_footer()
    return
end  # __init__()
