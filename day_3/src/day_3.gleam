import argv
import gleam/int
import gleam/io
import gleam/result
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

fn read_from_file(file_name: String) -> String {
  let result = simplifile.read(from: file_name)

  case result {
    Ok(contents) -> contents
    Error(_) -> {
      io.println("Unable to open file")
      panic
    }
  }
}

fn is_digit(char: String) -> Bool {
  case char {
    "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> True
    _ -> False
  }
}

fn get_num_loop(input: String, acc: String) -> Result(#(Int, String), Nil) {
  let #(char, rest) =
    string.pop_grapheme(input)
    |> result.unwrap(#("", ""))

  let begins_with_digit = is_digit(char)
  case char {
    c if begins_with_digit -> get_num_loop(rest, acc <> c)
    _ -> result.map(int.parse(acc), fn(x) { #(x, input) })
  }
}

pub fn get_num(input: String) -> Result(#(Int, String), Nil) {
  get_num_loop(input, "")
}

pub fn expect(input: String, expected: String) -> Result(String, Nil) {
  case string.starts_with(input, expected) {
    True -> Ok(string.drop_start(input, string.length(expected)))
    False -> Error(Nil)
  }
}

pub fn expect_args(input: String) -> Result(#(Int, String), Nil) {
  use rest <- result.try(expect(input, "("))
  use #(arg1, rest) <- result.try(get_num(rest))
  use rest <- result.try(expect(rest, ","))
  use #(arg2, rest) <- result.try(get_num(rest))
  use rest <- result.try(expect(rest, ")"))

  Ok(#(arg1 * arg2, rest))
}

pub fn get_next_mul(input: String) -> Result(#(Int, String), Nil) {
  case input {
    "" -> Error(Nil)

    "mul" <> rest -> {
      case expect_args(rest) {
        Error(Nil) -> get_next_mul(rest)
        ok -> ok
      }
    }

    _ -> get_next_mul(string.drop_start(input, 1))
  }
}

fn get_muls_loop(input: String, acc: Int) -> Int {
  case get_next_mul(input) {
    Ok(#(i, rest)) -> get_muls_loop(rest, acc + i)
    Error(Nil) -> acc
  }
}

pub fn get_muls(input: String) -> Int {
  get_muls_loop(input, 0)
}

pub fn main() {
  let path = get_path_from_arguments()
  let input = read_from_file(path)

  io.println("--- Part One ---")
  io.debug(get_muls(input))

  io.println("")
}
