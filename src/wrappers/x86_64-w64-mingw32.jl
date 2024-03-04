export gurobi_cl, grbgetkey, libgurobi

JLLWrappers.@generate_wrapper_header("Gurobi")

JLLWrappers.@declare_library_product(libgurobi, "gurobi110.dll")

JLLWrappers.@declare_executable_product(gurobi_cl)
JLLWrappers.@declare_executable_product(grbgetkey)

function __init__()
    JLLWrappers.@generate_init_header()
    JLLWrappers.@init_library_product(
        libgurobi,
        "gurobi110.dll",
        RTLD_LAZY | RTLD_DEEPBIND,
    )
    JLLWrappers.@init_executable_product(gurobi_cl, "gurobi_cl.exe")
    JLLWrappers.@init_executable_product(grbgetkey, "grbgetkey.exe")
    JLLWrappers.@generate_init_footer()
end  # __init__()
