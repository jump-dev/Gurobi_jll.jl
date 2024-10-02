# Copyright (c) 2024 Oscar Dowson, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

export gurobi_cl, grbgetkey, libgurobi

JLLWrappers.@generate_wrapper_header("Gurobi")

JLLWrappers.@declare_library_product(libgurobi, "@rpath/libgurobi120.dylib")

JLLWrappers.@declare_executable_product(gurobi_cl)

JLLWrappers.@declare_executable_product(grbgetkey)

function __init__()
    JLLWrappers.@generate_init_header()
    # This is needed to work-around a permission issue on some intel macs.
    # See Gurobi.jl#545 for details.
    libgurobi_path = joinpath(artifact_dir, "lib", "libgurobi120.dylib")
    run(`codesign --remove-signature $libgurobi_path`)
    # Back to the standard header
    JLLWrappers.@init_library_product(
        libgurobi,
        "lib/libgurobi120.dylib",
        RTLD_LAZY | RTLD_DEEPBIND,
    )
    JLLWrappers.@init_executable_product(gurobi_cl, "bin/gurobi_cl")
    JLLWrappers.@init_executable_product(grbgetkey, "bin/grbgetkey")
    # The standard license supports only Python installs. Remove it.
    gurobi_lic = joinpath(artifact_dir, "lib", "gurobi.lic")
    if isfile(gurobi_lic)
        rm(gurobi_lic; force = true)
    end
    JLLWrappers.@generate_init_footer()
    return
end  # __init__()
