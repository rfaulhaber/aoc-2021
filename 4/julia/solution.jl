sample = open("../sample.txt", "r")
input = open("../input.txt", "r")

struct Board
    numbers::Array{Int32}
end

function readInput(file)
    numbers = split(readline(file), ",")
    boards = []

    currentBoard = []

    readline(file)

    for line in readlines(file)
        if !isempty(line)
            append!(currentBoard, split(replace(line, r"(\D+)" => s","), ","))
        else
            currentBoard = filter(s->!isempty(s), currentBoard)
            push!(boards, currentBoard)
            currentBoard = []
        end
    end


    currentBoard = filter(s->!isempty(s), currentBoard)
    push!(boards, currentBoard)

    return (numbers, boards)
end

numbers, boards = readInput(sample)
println("numbers: ", numbers)
println("boards: ", boards)
