# Copyright (c) 2024 Oscar Dowson, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

# We don't want to precompile Gurobi_jll, so that the LazyArtifacts are
# downloaded only during the first instance of `using Gurobi_jll`. This means,
# for example, that they won't be downloaded by Gurobi.jl if someone has a local
# install.
__precompile__(false)

# Use baremodule to shave off a few KB from the serialized `.ji` file
baremodule Gurobi_jll

using Base
using Base: UUID
import JLLWrappers
import LazyArtifacts

JLLWrappers.@generate_main_file_header("Gurobi")

JLLWrappers.@generate_main_file("Gurobi", UUID("c018c7e6-a5b0-4aea-8f80-9c1ef9991411"))

function get_documentation_path()
    path = @static if Sys.iswindows()
        joinpath("Doc", "Gurobi", "refman", "index.html")
    else
        joinpath("share", "doc", "gurobi", "refman", "index.html")
    end
    return joinpath(artifact_dir, path)
end

function _browser_command(path::String)
    @static if Sys.isapple()
        return `open $path`
    elseif Sys.iswindows()
        return `cmd /c start $path`
    else
        @assert Sys.islinux()
        return `xdg-open $path`
    end
end

"""
    open_documentation()

Open a local copy of the Gurobi documentation in your browser.
"""
open_documentation() = run(_browser_command(get_documentation_path()))

end  # module Gurobi_jll
