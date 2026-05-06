#!/bin/bash
#
# Version update script that tries to adjust all hard-coded values for a
# new Gurobi x.y.z release and updates the artifacts. Check results with
# care.

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <version> (e.g. 13.0.2)"
    exit 1
fi

VERSION="$1"
IFS='.' read -r MAJOR MINOR TECHNICAL <<< "$VERSION"

DIR_VER="${MAJOR}${MINOR}${TECHNICAL}"
LIB_VER="${MAJOR}${MINOR}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$SCRIPT_DIR"

julia --project=. -e 'using Pkg; Pkg.instantiate()'

julia --project=. update_artifacts.jl "$VERSION"

sedi() { sed -i '' "$@" 2>/dev/null || sed -i "$@"; }

for f in "$REPO_ROOT/src/wrappers"/*.jl; do
    sedi \
        -e "s/libgurobi[0-9]*\.so/libgurobi${LIB_VER}.so/g" \
        -e "s/libgurobi[0-9]*\.dylib/libgurobi${LIB_VER}.dylib/g" \
        -e "s/gurobi[0-9]*\.dll/gurobi${LIB_VER}.dll/g" \
        "$f"
done

sedi "s/const GUROBI_DIR = \"gurobi[0-9]*\"/const GUROBI_DIR = \"gurobi${DIR_VER}\"/g" "$REPO_ROOT/src/Gurobi_jll.jl"

sedi "s/^version = \".*\"/version = \"${VERSION}\"/" "$REPO_ROOT/Project.toml"

sedi \
    -e "s/@test majorP\[\] == [0-9]*/@test majorP[] == ${MAJOR}/" \
    -e "s/@test minorP\[\] == [0-9]*/@test minorP[] == ${MINOR}/" \
    -e "s/@test technicalP\[\] == [0-9]*/@test technicalP[] == ${TECHNICAL}/" \
    "$REPO_ROOT/test/runtests.jl"

echo "Updated to version ${VERSION}"
