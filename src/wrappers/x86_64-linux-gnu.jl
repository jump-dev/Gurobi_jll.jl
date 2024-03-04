export gurobi_cl, grbgetkey, libgurobi

JLLWrappers.@generate_wrapper_header("Gurobi")

JLLWrappers.@declare_library_product(libgurobi, "libgurobi110.so")

JLLWrappers.@declare_executable_product(gurobi_cl)
JLLWrappers.@declare_executable_product(grbgetkey)

function __init__()
    JLLWrappers.@generate_init_header()
    JLLWrappers.@init_library_product(
        libgurobi,
        "lib/libgurobi110.so",
        RTLD_LAZY | RTLD_DEEPBIND,
    )
    JLLWrappers.@init_executable_product(gurobi_cl, "bin/gurobi_cl")
    JLLWrappers.@init_executable_product(grbgetkey, "bin/grbgetkey")
    JLLWrappers.@generate_init_footer()
end  # __init__()
