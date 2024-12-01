import argv
import gleam/int
import gleam/io
import gleam/list
import gleam/string
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

fn read_from_file(file_name: String) -> List(String) {
  let result = simplifile.read(from: file_name)

  let contents = case result {
    Ok(contents) -> contents
    Error(_) -> {
      io.println("Unable to open file")
      panic
    }
  }

  string.split(contents, on: "\r\n")
}

pub fn divide_lists(input: List(String)) {
  divide_lists_loop(input, #([], []))
}

fn divide_lists_loop(
  input: List(String),
  acc_tuple: #(List(String), List(String)),
) -> #(List(String), List(String)) {
  case input {
    [] -> acc_tuple

    [first, ..rest] -> {
      let #(list_a, list_b) = acc_tuple
      let assert Ok(#(elem_list_a, elem_list_b)) =
        string.split_once(first, "   ")

      divide_lists_loop(
        rest,
        #([elem_list_a, ..list_a], [elem_list_b, ..list_b]),
      )
    }
  }
}

fn parse_list(input: List(String)) -> List(Int) {
  list.map(input, fn(s) {
    let assert Ok(i) = int.parse(s)
    i
  })
}

pub fn get_total_distance(list_a: List(Int), list_b: List(Int)) -> Int {
  get_total_distance_loop(list_a, list_b, 0)
}

fn get_total_distance_loop(
  list_a: List(Int),
  list_b: List(Int),
  acc: Int,
) -> Int {
  case list_a, list_b {
    [], _ | _, [] -> acc

    [first_a, ..rest_a], [first_b, ..rest_b] -> {
      let distance = int.absolute_value(first_a - first_b)
      get_total_distance_loop(rest_a, rest_b, acc + distance)
    }
  }
}

pub fn count_appearances(elem: Int, list: List(Int)) -> Int {
  count_appearances_loop(elem, list, 0)
}

fn count_appearances_loop(elem: Int, list: List(Int), acc: Int) -> Int {
  case list {
    [] -> acc
    [first, ..rest] -> {
      let acc = case elem == first {
        True -> acc + 1
        False -> acc
      }

      count_appearances_loop(elem, rest, acc)
    }
  }
}

pub fn get_similarity_score(list_a: List(Int), list_b: List(Int)) -> Int {
  get_similarity_score_loop(list_a, list_b, 0)
}

fn get_similarity_score_loop(
  list_a: List(Int),
  list_b: List(Int),
  acc: Int,
) -> Int {
  case list_a, list_b {
    [], _ | _, [] -> acc

    [first_a, ..rest_a], _ -> {
      let appearances = count_appearances(first_a, list_b)
      get_similarity_score_loop(rest_a, list_b, acc + first_a * appearances)
    }
  }
}

pub fn main() {
  let path = get_path_from_arguments()

  let input = read_from_file(path)

  let #(list_a, list_b) = divide_lists(input)

  let list_a = parse_list(list_a)
  let list_b = parse_list(list_b)

  let list_a = list.sort(list_a, int.compare)
  let list_b = list.sort(list_b, int.compare)

  let total_distance = get_total_distance(list_a, list_b)
  let similarity_score = get_similarity_score(list_a, list_b)

  io.println("--- Part One ---")
  io.debug(total_distance)

  io.println("")

  io.println("--- Part Two ---")
  io.debug(similarity_score)
}
