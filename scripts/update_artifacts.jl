# Copyright (c) 2024 Oscar Dowson, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using Tar, Inflate, SHA, TOML

function get_artifact(data; version::String, pyversion::String)
    filename = "gurobi-$version-$pyversion.tar.bz2"
    url = "https://anaconda.org/Gurobi/gurobi/$version/download/$(data.conda)/$filename"
    run(`wget $url`)
    ret = Dict(
        "git-tree-sha1" => Tar.tree_hash(`gzcat $filename`),
        "arch" => data.arch,
        "os" => data.os,
        "download" => Any[
            Dict("sha256" => bytes2hex(open(sha256, filename)), "url" => url),
        ]
    )
    rm(filename)
    return ret
end

function main(; version = "10.0.3", pyversion = "py311_0")
    platforms = [
        (os = "linux", arch = "x86_64", conda = "linux-64"),
        (os = "macos", arch = "x86_64", conda = "osx-64"),
        (os = "macos", arch = "aarch64", conda = "osx-arm64"),
        (os = "windows", arch = "x86_64", conda = "win-64"),
    ]
    output = Dict("Gurobi" => get_artifact.(platforms; version, pyversion))
    open(joinpath(dirname(@__DIR__), "Artifacts.toml"), "w") do io
        return TOML.print(io, output)
    end
    return
end

#   julia --project=scripts scripts/update_artifacts.jl version`
#
# Update the Artifacts.toml file.
if !isempty(ARGS)
    main(; version = ARGS[1])
end
