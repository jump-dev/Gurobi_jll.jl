# Copyright (c) 2024 Oscar Dowson, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

# Use baremodule to shave off a few KB from the serialized `.ji` file
baremodule Gurobi_jll

using Base
using Base: UUID
import JLLWrappers

JLLWrappers.@generate_main_file_header("Gurobi")

JLLWrappers.@generate_main_file("Gurobi", UUID("c018c7e6-a5b0-4aea-8f80-9c1ef9991411"))

"""
    open_documentation()

Open a local copy of the Gurobi documentation in your browser.
"""
function open_documentation()
    relative_path = joinpath("share", "doc", "gurobi", "refman", "index.html")
    path = joinpath(artifact_dir, relative_path)
    @static if Sys.isapple()
        run(`open $path`)
    elseif Sys.iswindows()
        run(`cmd /c start $path`)
    else
        @assert Sys.islinux()
        run(`xdg-open $path`)
    end
    return
end

end  # module Gurobi_jll
