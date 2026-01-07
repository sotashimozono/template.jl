#!/bin/bash

# 1. プロジェクトの依存関係を解決
julia --project=. -e 'using Pkg; Pkg.instantiate()'

# 2. ツール類をグローバル環境に追加
# IJulia, Revise に加えて JuliaFormatter を追加
julia -e 'using Pkg; Pkg.add(["IJulia", "Revise", "JuliaFormatter"])'

# 3. startup.jl の設定 (Revise)
mkdir -p ~/.julia/config
cat <<EOF > ~/.julia/config/startup.jl
try
    using Revise
    println("Revise loaded!")
catch e
    @warn "Error initializing Revise" e
end
EOF

echo "Setup complete! Jupyter, Revise, and JuliaFormatter are ready."