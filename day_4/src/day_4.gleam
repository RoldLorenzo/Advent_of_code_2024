import argv
import gleam/bool
import gleam/io
import gleam/list
import gleam/option.{type Option}
import gleam/result
import gleam/string
import glearray.{type Array}
import simplifile

fn get_path_from_arguments() -> String {
  case argv.load().arguments {
    [path] -> path

    _ -> {
      io.println("USAGE: gleam run <filepath>")
      panic
    }
  }
}

type Matrix(any) =
  Array(Array(any))

fn read_from_file(file_name: String) -> Matrix(String) {
  let contents =
    simplifile.read(from: file_name)
    |> result.lazy_unwrap(fn() {
      io.println("Unable to open file")
      panic
    })

  string.split(contents, on: "\r\n")
  |> list.map(string.to_graphemes)
  |> list.map(glearray.from_list)
  |> glearray.from_list()
}

fn get_from_matrix(
  input: Matrix(String),
  line_index: Int,
  col_index: Int,
) -> String {
  glearray.get(input, line_index)
  |> result.unwrap(glearray.new())
  |> glearray.get(col_index)
  |> result.unwrap("")
}

pub fn get_horizontal_word(
  input: Matrix(String),
  line_index: Int,
  col_index: Int,
) -> String {
  get_from_matrix(input, line_index, col_index)
  <> get_from_matrix(input, line_index, col_index + 1)
  <> get_from_matrix(input, line_index, col_index + 2)
  <> get_from_matrix(input, line_index, col_index + 3)
}

pub fn get_vertical_word(
  input: Matrix(String),
  line_index: Int,
  col_index: Int,
) -> String {
  get_from_matrix(input, line_index, col_index)
  <> get_from_matrix(input, line_index + 1, col_index)
  <> get_from_matrix(input, line_index + 2, col_index)
  <> get_from_matrix(input, line_index + 3, col_index)
}

pub fn get_left_diagonal_word(
  input: Matrix(String),
  line_index: Int,
  col_index: Int,
) -> String {
  get_from_matrix(input, line_index, col_index)
  <> get_from_matrix(input, line_index + 1, col_index - 1)
  <> get_from_matrix(input, line_index + 2, col_index - 2)
  <> get_from_matrix(input, line_index + 3, col_index - 3)
}

pub fn get_right_diagonal_word(
  input: Matrix(String),
  line_index: Int,
  col_index: Int,
) -> String {
  get_from_matrix(input, line_index, col_index)
  <> get_from_matrix(input, line_index + 1, col_index + 1)
  <> get_from_matrix(input, line_index + 2, col_index + 2)
  <> get_from_matrix(input, line_index + 3, col_index + 3)
}

type GetWordFn =
  fn(Array(Array(String)), Int, Int) -> String

pub fn is_xmas(
  input: Matrix(String),
  line_index: Int,
  col_index: Int,
  get_word: GetWordFn,
) -> Int {
  let word = get_word(input, line_index, col_index)
  bool.to_int(word == "XMAS" || word == "SAMX")
}

fn is_mas(word: String) -> Bool {
  word == "MAS" || word == "SAM"
}

pub fn is_x_mas(input: Matrix(String), line_index: Int, col_index: Int) -> Int {
  let right_diagonal =
    get_from_matrix(input, line_index - 1, col_index - 1)
    <> get_from_matrix(input, line_index, col_index)
    <> get_from_matrix(input, line_index + 1, col_index + 1)

  let left_diagonal =
    get_from_matrix(input, line_index - 1, col_index + 1)
    <> get_from_matrix(input, line_index, col_index)
    <> get_from_matrix(input, line_index + 1, col_index - 1)

  { is_mas(right_diagonal) && is_mas(left_diagonal) }
  |> bool.to_int()
}

fn update_indexes(
  input: Matrix(String),
  line_index: Int,
  col_index: Int,
) -> Option(#(Int, Int)) {
  let next_line = line_index + 1
  let next_col = col_index + 1

  let amnt_lines = glearray.length(input)
  let amnt_cols =
    glearray.get(input, line_index)
    |> result.unwrap(glearray.new())
    |> glearray.length()

  case next_line >= amnt_lines, next_col >= amnt_cols {
    _, False -> option.Some(#(line_index, next_col))
    False, True -> option.Some(#(next_line, 0))
    True, True -> option.None
  }
}

fn count_xmases_loop(
  input: Matrix(String),
  line_index: Int,
  col_index: Int,
  acc: Int,
) -> Int {
  let acc =
    acc
    + is_xmas(input, line_index, col_index, get_horizontal_word)
    + is_xmas(input, line_index, col_index, get_vertical_word)
    + is_xmas(input, line_index, col_index, get_right_diagonal_word)
    + is_xmas(input, line_index, col_index, get_left_diagonal_word)

  case update_indexes(input, line_index, col_index) {
    option.None -> acc
    option.Some(#(new_line, new_col)) -> {
      count_xmases_loop(input, new_line, new_col, acc)
    }
  }
}

pub fn count_xmases(input: Matrix(String)) -> Int {
  count_xmases_loop(input, 0, 0, 0)
}

fn count_x_mases_loop(
  input: Matrix(String),
  line_index: Int,
  col_index: Int,
  acc: Int,
) -> Int {
  let acc = acc + is_x_mas(input, line_index, col_index)

  case update_indexes(input, line_index, col_index) {
    option.None -> acc
    option.Some(#(new_line, new_col)) -> {
      count_x_mases_loop(input, new_line, new_col, acc)
    }
  }
}

pub fn count_x_mases(input: Matrix(String)) -> Int {
  count_x_mases_loop(input, 0, 0, 0)
}

pub fn main() {
  let path = get_path_from_arguments()
  let input = read_from_file(path)

  io.println("--- Part One ---")
  io.debug(count_xmases(input))

  io.println("")

  io.println("--- Part Two ---")
  io.debug(count_x_mases(input))
}
