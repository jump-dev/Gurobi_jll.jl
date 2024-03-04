# Use baremodule to shave off a few KB from the serialized `.ji` file
baremodule Gurobi_jll

using Base
using Base: UUID
import JLLWrappers

JLLWrappers.@generate_main_file_header("Gurobi")
JLLWrappers.@generate_main_file("Gurobi", UUID("c018c7e6-a5b0-4aea-8f80-9c1ef9991411"))

end  # module Gurobi_jll
