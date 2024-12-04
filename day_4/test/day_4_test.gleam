import day_4
import gleam/list
import glearray
import gleeunit
import gleeunit/should

const input = [
  ["M", "M", "M", "S", "X", "X", "M", "A", "S", "M"],
  ["M", "S", "A", "M", "X", "M", "S", "M", "S", "A"],
  ["A", "M", "X", "S", "X", "M", "A", "A", "M", "M"],
  ["M", "S", "A", "M", "A", "S", "M", "S", "M", "X"],
  ["X", "M", "A", "S", "A", "M", "X", "A", "M", "M"],
  ["X", "X", "A", "M", "M", "X", "X", "A", "M", "A"],
  ["S", "M", "S", "M", "S", "A", "S", "X", "S", "S"],
  ["S", "A", "X", "A", "M", "A", "S", "A", "A", "A"],
  ["M", "A", "M", "M", "M", "X", "M", "M", "M", "M"],
  ["M", "X", "M", "X", "A", "X", "M", "A", "S", "X"],
]

fn matrix_to_array(input) {
  list.map(input, glearray.from_list)
  |> glearray.from_list
}

pub fn main() {
  gleeunit.main()
}

pub fn is_xmas_horizontal_test() {
  let input = matrix_to_array(input)

  day_4.is_xmas(input, 0, 5, day_4.get_horizontal_word)
  |> should.equal(1)

  day_4.is_xmas(input, 1, 1, day_4.get_horizontal_word)
  |> should.equal(1)

  day_4.is_xmas(input, 7, 2, day_4.get_horizontal_word)
  |> should.equal(0)
}

pub fn is_xmas_vertical_test() {
  let input = matrix_to_array(input)

  day_4.is_xmas(input, 3, 9, day_4.get_vertical_word)
  |> should.equal(1)

  day_4.is_xmas(input, 6, 9, day_4.get_vertical_word)
  |> should.equal(1)

  day_4.is_xmas(input, 5, 1, day_4.get_vertical_word)
  |> should.equal(0)
}

pub fn is_xmas_diagonal_test() {
  let input = matrix_to_array(input)

  day_4.is_xmas(input, 0, 4, day_4.get_right_diagonal_word)
  |> should.equal(1)

  day_4.is_xmas(input, 6, 0, day_4.get_right_diagonal_word)
  |> should.equal(1)

  day_4.is_xmas(input, 2, 2, day_4.get_right_diagonal_word)
  |> should.equal(0)

  day_4.is_xmas(input, 3, 9, day_4.get_left_diagonal_word)
  |> should.equal(1)

  day_4.is_xmas(input, 2, 3, day_4.get_left_diagonal_word)
  |> should.equal(1)

  day_4.is_xmas(input, 1, 4, day_4.get_left_diagonal_word)
  |> should.equal(0)
}

pub fn count_xmases_test() {
  let input = matrix_to_array(input)

  day_4.count_xmases(input)
  |> should.equal(18)
}

pub fn count_x_mases_test() {
  let input = matrix_to_array(input)

  day_4.count_x_mases(input)
  |> should.equal(9)
}
