import day_2
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn is_increasing_test() {
  day_2.is_increasing([7, 6, 4, 2, 1])
  |> should.be_false()

  day_2.is_increasing([1, 2, 7, 8, 9])
  |> should.be_true()

  day_2.is_increasing([9, 7, 6, 2, 1])
  |> should.be_false()

  day_2.is_increasing([1, 3, 2, 4, 5])
  |> should.be_false()

  day_2.is_increasing([8, 6, 4, 4, 1])
  |> should.be_false()

  day_2.is_increasing([1, 3, 6, 7, 9])
  |> should.be_true()
}

pub fn is_decreasing_test() {
  day_2.is_decreasing([7, 6, 4, 2, 1])
  |> should.be_true()

  day_2.is_decreasing([1, 2, 7, 8, 9])
  |> should.be_false()

  day_2.is_decreasing([9, 7, 6, 2, 1])
  |> should.be_true()

  day_2.is_decreasing([1, 3, 2, 4, 5])
  |> should.be_false()

  day_2.is_decreasing([8, 6, 4, 4, 1])
  |> should.be_true()

  day_2.is_decreasing([1, 3, 6, 7, 9])
  |> should.be_false()
}

pub fn differences_of_test() {
  day_2.differences_of([7, 6, 4, 2, 1], 1, 3)
  |> should.be_true()

  day_2.differences_of([1, 2, 7, 8, 9], 1, 3)
  |> should.be_false()

  day_2.differences_of([1, 2, 7, 8, 9], 1, 5)
  |> should.be_true()

  day_2.differences_of([9, 7, 6, 2, 1], 1, 3)
  |> should.be_false()

  day_2.differences_of([1, 3, 2, 4, 5], 1, 2)
  |> should.be_true()

  day_2.differences_of([8, 6, 4, 4, 1], 1, 3)
  |> should.be_false()

  day_2.differences_of([8, 6, 4, 4, 1], 0, 3)
  |> should.be_true()

  day_2.differences_of([1, 3, 6, 7, 9], 1, 3)
  |> should.be_true()
}

pub fn is_report_safe_test() {
  day_2.is_report_safe([7, 6, 4, 2, 1])
  |> should.be_true()

  day_2.is_report_safe([1, 2, 7, 8, 9])
  |> should.be_false()

  day_2.is_report_safe([9, 7, 6, 2, 1])
  |> should.be_false()

  day_2.is_report_safe([1, 3, 2, 4, 5])
  |> should.be_false()

  day_2.is_report_safe([8, 6, 4, 4, 1])
  |> should.be_false()

  day_2.is_report_safe([1, 3, 6, 7, 9])
  |> should.be_true()
}

pub fn some_combination_safe_test() {
  day_2.some_combination_safe([7, 6, 4, 2, 1])
  |> should.be_true()

  day_2.some_combination_safe([1, 2, 7, 8, 9])
  |> should.be_false()

  day_2.some_combination_safe([9, 7, 6, 2, 1])
  |> should.be_false()

  day_2.some_combination_safe([1, 3, 2, 4, 5])
  |> should.be_true()

  day_2.some_combination_safe([8, 6, 4, 4, 1])
  |> should.be_true()

  day_2.some_combination_safe([1, 3, 6, 7, 9])
  |> should.be_true()
}
