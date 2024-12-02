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

fn parse_list(input: List(String)) -> List(Int) {
  list.map(input, fn(s) {
    let assert Ok(i) = int.parse(s)
    i
  })
}

fn get_reports(input: List(String)) -> List(List(Int)) {
  list.map(input, fn(line) {
    let levels = string.split(line, " ")
    parse_list(levels)
  })
}

fn differences_of_loop(
  list: List(Int),
  min_difference: Int,
  max_difference: Int,
  last_elem: Int,
) -> Bool {
  case list {
    [] -> True
    [first, ..rest] -> {
      let difference = int.absolute_value(first - last_elem)

      case difference <= max_difference && difference >= min_difference {
        True -> differences_of_loop(rest, min_difference, max_difference, first)
        False -> False
      }
    }
  }
}

pub fn differences_of(
  list: List(Int),
  min_difference: Int,
  max_difference: Int,
) -> Bool {
  case list {
    [] -> True
    [first, ..rest] ->
      differences_of_loop(rest, min_difference, max_difference, first)
  }
}

fn verify_order(
  list: List(Int),
  last_elem: Int,
  comparison: fn(Int, Int) -> Bool,
) -> Bool {
  case list {
    [] -> True
    [first, ..rest] -> {
      case comparison(last_elem, first) {
        True -> verify_order(rest, first, comparison)
        False -> False
      }
    }
  }
}

pub fn is_increasing(list: List(Int)) -> Bool {
  case list {
    [] -> True
    [first, ..rest] -> verify_order(rest, first, fn(a, b) { a <= b })
  }
}

pub fn is_decreasing(list: List(Int)) -> Bool {
  case list {
    [] -> True
    [first, ..rest] -> verify_order(rest, first, fn(a, b) { a >= b })
  }
}

pub fn is_report_safe(report: List(Int)) -> Bool {
  { is_decreasing(report) || is_increasing(report) }
  && differences_of(report, 1, 3)
}

pub fn some_combination_safe(report: List(Int)) -> Bool {
  is_report_safe(report)
  || list.any(
    list.combinations(report, list.length(report) - 1),
    is_report_safe,
  )
}

pub fn main() {
  let path = get_path_from_arguments()
  let input = read_from_file(path)

  let reports = get_reports(input)

  let safe_reports = list.map(reports, is_report_safe)
  let amnt_safe_reports = list.count(safe_reports, fn(bool) { bool })

  io.println("--- Part One ---")
  io.debug(amnt_safe_reports)

  io.println("")

  let safe_reports = list.map(reports, some_combination_safe)
  let amnt_safe_reports = list.count(safe_reports, fn(bool) { bool })

  io.println("--- Part Two ---")
  io.debug(amnt_safe_reports)
}
