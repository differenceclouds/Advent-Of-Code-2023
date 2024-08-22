package calibration

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"



letters := "abcdefghijklmnopqrstuvwxyz"
wordgits : []string = {"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}
digits : []string = {"0","1","2","3","4","5","6","7","8","9"}


main :: proc() {
	data, ok := os.read_entire_file("input.txt")
	if !ok do return

	total := 0
	total_wordgits:= 0

	it := string(data)
	for line in strings.split_lines_iterator(&it) {
		v := get_value(line)
		v_w := get_value_with_wordgits(line)
		fmt.printfln("%[0]d, %[1]d", v, v_w)
		total += v
		total_wordgits += v_w
	}


	fmt.printfln("total, digits only: %[0]d", total)
	fmt.printfln("total, wordgits included: %[0]d", total_wordgits)
}

get_value :: proc(line: string) -> int {
	trimmed := strings.trim(line, letters)
	left := trimmed[0:1]
	right := trimmed[len(trimmed) - 1 : len(trimmed)]
	combine := strings.concatenate({left, right})

	parsed, ok := strconv.parse_int(combine)
	if ok do return parsed
	else do return 0
}

get_value_with_wordgits :: proc(line: string) -> int {
	left : string
	found_left : bool
	for l := 0;  l < len(line); l += 1 {
		trimmed := line[l : len(line)]
		left, found_left = check_prefix(trimmed)
		if found_left do break
	}

	right: string
	found_right: bool
	for r := 0; r < len(line); r += 1 {
		trimmed := line[0: len(line) - r]
		right, found_right = check_suffix(trimmed)
		if found_right do break
	}

	combine := strings.concatenate({left, right})

	parsed, ok := strconv.parse_int(combine)
	if ok do return parsed
	else do return 0
}

check_prefix :: proc(line: string) -> (string, bool) {
	for prefix, i in wordgits {
		if strings.has_prefix(line, prefix) || strings.has_prefix(line, digits[i]) {
			return digits[i], true
		} 
	}
	return "", false
}

check_suffix :: proc(line: string) -> (string, bool) {
	for suffix, i in wordgits {
		if strings.has_suffix(line, suffix) || strings.has_suffix(line, digits[i]) {
			return digits[i], true
		}
	}
	return "", false
}










