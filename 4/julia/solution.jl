sample = open("../sample.txt", "r")
input = open("../input.txt", "r")

completeMatrix = [1  2  3  4  5
                  6  7  8  9  10
                  11 12 13 14 15
                  16 17 18 19 20
                  21 22 23 24 25]

struct Board
    numbers::Set{String}
end

function readInput(file)
    numbers = map(s->String(s), split(readline(file), ","))
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

    boardList = map(b->Board(Set(b)), boards)

    return (numbers, boardList)
end

function boardMatches(numbers, board::Board)
    matches = []
    n = collect(board.numbers)
    for number in numbers
        push!(matches, findfirst(v->v == number, n))
    end

    matches
end

function hasBingo(numbers, matches)
    sortedMatches = sort(matches)

    for row in [1:5]

    end
end

function boardSolvedAt(numbers, board::Board)

end

function solvePart1(numbers, boards::Array{Board})

end


numbers, boards = readInput(sample)

println(numbers)
println(boards[1])
println(boardMatches(numbers, boards[1]))
