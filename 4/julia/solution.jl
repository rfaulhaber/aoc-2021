# this is a terrible solution and I'm sorry :(

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

    filter(!isnothing, matches)
end

function chunk(arr, n)
    [arr[i:min(i + n - 1, end)] for i in 1:n:length(arr)]
end

function hasBingo(numbers, matches)
    sortedMatches = sort(matches)

    if length(sortedMatches) < 5
        return (false, nothing)
    end

    for run in chunk(sortedMatches, 5)
        for row in eachrow(completeMatrix)
            if isequal(row, run)
                return (true, run)
            end
        end

        for col in eachcol(completeMatrix)
            if isequal(col, run)
                return (true, run)
            end
        end
    end

    return (false, nothing)
end

function getAllUnmarkedNumbers(matches, board::Board)
    println("matches", matches)
    findall(v->!(v in matches), collect(board.numbers))
end

function solvePart1(numbers, boards::Array{Board})
    for i in 1:length(numbers)
        for board in boards
            n = numbers[1:i]
            # println("numbers", n)
            matches = boardMatches(n, board)

            win, run = hasBingo(n, matches)

            if n[length(n)] == "24"
                println("win", win, matches)
            end

            if win
                # println("win at ", numbers[i], numbers)
                unmarked = getAllUnmarkedNumbers(matches, board)
                # println("unmarked", unmarked)
                return sum(unmarked) * parse(Int64, numbers[i])
            end
        end
    end
end


numbers, boards = readInput(sample)

# println(numbers)
# println(boards[1])
# println(hasBingo(numbers, boardMatches(numbers, boards[1])))
println(solvePart1(numbers, boards))
# can't figure out this one :(
