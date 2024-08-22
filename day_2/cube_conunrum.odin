package cube_conundrum

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"


colors : []string 	= {" red", " green", " blue"}
limits : []int		= {12, 13, 14}


main :: proc() {
	data, ok := os.read_entire_file("input.txt")
	if !ok do return

	input1 := string(data)
	input2 := string(data)

	part1(&input1)
	part2(&input2)

}

part1 :: proc(lines: ^string) {
	valid_games := 0

	game := 1
	for line in strings.split_lines_iterator(lines) {

		sets := strings.split(line, ":")[1]

		valid := get_valid(sets, game)

		if valid  {
			fmt.printfln("game %[0]d VALID", game)
			valid_games += game
		} else {
			fmt.printfln("game %[0]d NOT VALID", game)
		}
		game += 1
	}
	fmt.println()
	fmt.printfln("possible game IDs, added: %[0]d", valid_games)
	fmt.println()
}

get_valid :: proc(sets: string, game: int) -> bool {
	for set in strings.split(sets, ";") {
		for d in strings.split(set, ",") {
			die := strings.trim_space(d)
			for color, c in colors {
				if strings.has_suffix(die, color) {
					count, ok := strconv.parse_int(strings.trim_suffix(die, color))
					if !ok do panic("could not parse")
					if count > limits[c] {
						fmt.println()
						fmt.printfln("    invalid set, %[0]v", die)
						return false
					}
				}
			}
		}
	}
	return true
}


part2 :: proc(lines: ^string) {
	total := 0
	game := 1
	for line in strings.split_lines_iterator(lines) {
		sets := strings.split(line, ":")[1]

		fmt.printf("Game %[0]d: ", game)
		power := get_power(sets)
		fmt.printfln("Power: %[0]d", power)

		total += power
		game += 1
	}

	fmt.println()
	fmt.printfln("Total powers, added: %[0]d", total)
	fmt.println()

}

get_power :: proc(sets: string) -> int {
	mins : []int = {1, 1, 1}
	for set in strings.split(sets, ";") {
		for d in strings.split(set, ",") {
			die := strings.trim_space(d)
			for color, c in colors {
				if strings.has_suffix(die, color) {
					count, ok := strconv.parse_int(strings.trim_suffix(die, color))
					if !ok do panic("could not parse")

					if count > mins[c] {
						mins[c] = count
					}

				}
			}
		}
	}
	power := 1
	for min in mins {
		power *= min
	}
	fmt.printf("%[0]w, ", mins)
	return power
}

