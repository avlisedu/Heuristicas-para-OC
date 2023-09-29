#=
Universidade Federal de Pernambuco
Programa de Pós-Graduação em Engenharia de Produção
TAPO III - Heurísticas para Problemas de Otimização Combinatória

Docente: Raphael Kramer
Discente: Eduardo da Silva

FORMULAÇÃO 3

=#


using JuMP, Cbc, DelimitedFiles

# Função para calcular a distância euclidiana entre dois pontos
function distancia_euclidiana(x1, y1, x2, y2)
    return sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function coordis(nome_arquivo)
    # Abrir o arquivo em modo de leitura
    arquivo = open(nome_arquivo, "r")
    
    # Ler o valor de n a partir da primeira linha
    n = parse(Int, readline(arquivo))
    
    # Inicializar listas vazias para coordenadas x e y
    coordenadas_x = Int[]
    coordenadas_y = Int[]
    
    # Ler as coordenadas da segunda linha em diante
    for linha in eachline(arquivo)
        partes = split(linha, '\t')
        push!(coordenadas_x, parse(Int, partes[2]))
        push!(coordenadas_y, parse(Int, partes[3]))
    end
    
    # Fechar o arquivo
    close(arquivo)
    
    # Inicializar uma matriz para armazenar as distâncias entre os pontos
    distancias = zeros(Float64, n, n)
    
    # Calcular a distância euclidiana entre todos os pares de pontos
    for i in 1:n
        for j in 1:n
            distancias[i, j] = distancia_euclidiana(coordenadas_x[i], coordenadas_y[i], coordenadas_x[j], coordenadas_y[j])
        end
    end
    
    return n, coordenadas_x, coordenadas_y, distancias
end

function otimizar(nome_arquivo)
    # Ler coordenadas e calcular distâncias
    n, coordenadas_x, coordenadas_y, distancias = coordis(nome_arquivo)

    #Modelo
    model = Model(Cbc.Optimizer)
    set_optimizer_attribute(model, "seconds", 300)
    #Variáveis
    @variable(model, x[1:n, 1:n], binary=true)
    @variable(model, 0 <= u[1:n] <= n, Int)
    #Função objetivo
    @objective(model, Min, sum(distancias[i,j]*x[i, j] for j in 1:n for i in 1:n))
    #Restrições
    @constraint(model, m[j = 1:n], sum(x[i, j] for i in 1:n if i != j) == 1)
    @constraint(model, o[i = 1:n], sum(x[i, j] for j in 1:n if j != i) == 1)
    @constraint(model, u[1] == 1)
    @constraint(model, p[i = 2:n, j = 2:n; i != j], u[i] - u[j] + n * x[i, j] <= (n-1))
    @constraint(model, q[i = 2:n], 2 <= u[i] <= n)

    optimize!(model)
   
v = []
i = 1
push!(v, i)
while length(v) < n
    for j = 1:n
        if value.(x[i, j]) == 1
            i = j
            push!(v, i)
        end
    end
end
   # Medir o tempo de otimização
   t = @elapsed begin
    #Otimização
    optimize!(model)
end

    # Exibir o resultado da otimização
    if termination_status(model) == MOI.OPTIMAL
        println("Solução ótima encontrada:")
        println("Valor ótimo da função objetivo: ", objective_value(model))
        println("Pontos visitados na solução: $v")
    else
        println("Otimização não convergiu para uma solução ótima.")
    end
    println("Tempo decorrido: $t segundos")
end


#=
Universidade Federal de Pernambuco
Programa de Pós-Graduação em Engenharia de Produção
TAPO III - Heurísticas para Problemas de Otimização Combinatória

Docente: Raphael Kramer
Discente: Eduardo da Silva

FORMULAÇÃO 4

=#
#include("C:\\Users\\avlis\\OneDrive\\Área de Trabalho\\PPGEP\\2 SEMESTRE 2023\\HEURISTICA\\aula0925\\todas-instancias\\minhaForm4.jl")

using JuMP, Cbc, DelimitedFiles

# Função para calcular a distância euclidiana entre dois pontos
function distancia_euclidiana(x1, y1, x2, y2)
    return sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function coordis(nome_arquivo)
    # Abrir o arquivo em modo de leitura
    arquivo = open(nome_arquivo, "r")
    
    # Ler o valor de n a partir da primeira linha
    n = parse(Int, readline(arquivo))
    
    # Inicializar listas vazias para coordenadas x e y
    coordenadas_x = Int[]
    coordenadas_y = Int[]
    
    # Ler as coordenadas da segunda linha em diante
    for linha in eachline(arquivo)
        partes = split(linha, '\t')
        push!(coordenadas_x, parse(Int, partes[2]))
        push!(coordenadas_y, parse(Int, partes[3]))
    end
    
    # Fechar o arquivo
    close(arquivo)
    
    # Inicializar uma matriz para armazenar as distâncias entre os pontos
    distancias = zeros(Float64, n, n)
    
    # Calcular a distância euclidiana entre todos os pares de pontos
    for i in 1:n
        for j in 1:n
            distancias[i, j] = distancia_euclidiana(coordenadas_x[i], coordenadas_y[i], coordenadas_x[j], coordenadas_y[j])
        end
    end
    
    return n, coordenadas_x, coordenadas_y, distancias
end

function otimizar(nome_arquivo)
    # Ler coordenadas e calcular distâncias
    n, coordenadas_x, coordenadas_y, distancias = coordis(nome_arquivo)

    # Criar um modelo de otimização
     #Modelo
     model = Model(Cbc.Optimizer)
     set_optimizer_attribute(model, "seconds", 300)
     #Variáveis
     @variable(model, x[1:n, 1:n], binary=true)
     @variable(model, y[1:n, 1:n] , Int)
     #Função objetivo
     @objective(model, Min, sum(distancias[i,j]*x[i, j] for j in 1:n for i in 1:n))
     #Restrições
     @constraint(model, m[j = 1:n], sum(x[i, j] for i in 1:n) == 1)
     @constraint(model, o[i = 1:n], sum(x[i, j] for j in 1:n) == 1)
     @constraint(model, p[i = 2:n], (sum(y[i, j] for j in 1:n if j != i)-sum(y[j, i] for j in 2:n if j != i)) == 1)
     @constraint(model, q[i = 2:n, j = 1:n; i != j], y[i, j] <= (n-1)*x[i, j])
     @constraint(model, r[i = 2:n, j = 1:n; i != j], y[i, j] >= 0)
    
     optimize!(model)
   
v = []
i = 1
push!(v, i)
while length(v) < n
    for j = 1:n
        if value.(x[i, j]) == 1
            i = j
            push!(v, i)
        end
    end
end
   # Medir o tempo de otimização
   t = @elapsed begin
    #Otimização
    optimize!(model)
end

    # Exibir o resultado da otimização
    if termination_status(model) == MOI.OPTIMAL
        println("Solução ótima encontrada:")
        println("Valor ótimo da função objetivo: ", objective_value(model))
        println("Pontos visitados na solução: $v")
    else
        println("Otimização não convergiu para uma solução ótima.")
    end
    println("Tempo decorrido: $t segundos")
end
