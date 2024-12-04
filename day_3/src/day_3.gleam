import argv
import gleam/int
import gleam/io
import gleam/result
import gleam/string
import simplifile

pub type Instruction {
  Mul(result: Int)
  Do
  Dont
}

type Parsed(any) =
  #(any, String)

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
  simplifile.read(from: file_name)
  |> result.lazy_unwrap(fn() {
    io.println("Unable to open file")
    panic
  })
}

fn is_digit(char: String) -> Bool {
  case char {
    "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> True
    _ -> False
  }
}

fn get_num_loop(input: String, acc: String) -> Result(Parsed(Int), Nil) {
  let #(char, rest) =
    string.pop_grapheme(input)
    |> result.unwrap(#("", ""))

  let begins_with_digit = is_digit(char)
  case char {
    c if begins_with_digit -> get_num_loop(rest, acc <> c)
    _ -> result.map(int.parse(acc), fn(x) { #(x, input) })
  }
}

pub fn get_num(input: String) -> Result(Parsed(Int), Nil) {
  get_num_loop(input, "")
}

pub fn expect(input: String, expected: String) -> Result(String, Nil) {
  case string.starts_with(input, expected) {
    True -> Ok(string.drop_start(input, string.length(expected)))
    False -> Error(Nil)
  }
}

pub fn expect_mul_args(input: String) -> Result(Parsed(Int), Nil) {
  use rest <- result.try(expect(input, "("))
  use #(arg1, rest) <- result.try(get_num(rest))
  use rest <- result.try(expect(rest, ","))
  use #(arg2, rest) <- result.try(get_num(rest))
  use rest <- result.try(expect(rest, ")"))

  Ok(#(arg1 * arg2, rest))
}

pub fn expect_empty_args(input: String) -> Result(String, Nil) {
  use rest <- result.try(expect(input, "("))
  use rest <- result.try(expect(rest, ")"))
  Ok(rest)
}

pub fn get_next_instruction(input: String) -> Result(Parsed(Instruction), Nil) {
  case input {
    "" -> Error(Nil)

    "mul" <> rest -> {
      case expect_mul_args(rest) {
        Ok(#(result, rest)) -> Ok(#(Mul(result), rest))
        Error(Nil) -> get_next_instruction(rest)
      }
    }

    "don't" <> rest -> {
      case expect_empty_args(rest) {
        Ok(rest) -> Ok(#(Dont, rest))
        Error(Nil) -> get_next_instruction(rest)
      }
    }

    "do" <> rest -> {
      case expect_empty_args(rest) {
        Ok(rest) -> Ok(#(Do, rest))
        Error(Nil) -> get_next_instruction(rest)
      }
    }

    _ -> get_next_instruction(string.drop_start(input, 1))
  }
}

fn get_instructions_no_enable_loop(input: String, acc: Int) -> Int {
  case get_next_instruction(input) {
    Ok(#(Mul(i), rest)) -> get_instructions_no_enable_loop(rest, acc + i)
    Ok(#(Do, rest)) | Ok(#(Dont, rest)) ->
      get_instructions_no_enable_loop(rest, acc)
    Error(Nil) -> acc
  }
}

pub fn get_instructions_no_enable(input: String) -> Int {
  get_instructions_no_enable_loop(input, 0)
}

fn get_instructions_loop(input: String, acc: Int, enabled: Bool) -> Int {
  case get_next_instruction(input) {
    Ok(#(Mul(i), rest)) -> {
      let acc = case enabled {
        True -> acc + i
        False -> acc
      }

      get_instructions_loop(rest, acc, enabled)
    }

    Ok(#(Do, rest)) -> get_instructions_loop(rest, acc, True)
    Ok(#(Dont, rest)) -> get_instructions_loop(rest, acc, False)

    Error(Nil) -> acc
  }
}

pub fn get_instructions(input: String) -> Int {
  get_instructions_loop(input, 0, True)
}

pub fn main() {
  let path = get_path_from_arguments()
  let input = read_from_file(path)

  io.println("--- Part One ---")
  io.debug(get_instructions_no_enable(input))

  io.println("")

  io.println("--- Part Two ---")
  io.debug(get_instructions(input))
}
