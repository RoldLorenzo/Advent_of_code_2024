import day_3
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn get_num_test() {
  day_3.get_num("123a")
  |> should.equal(Ok(#(123, "a")))

  day_3.get_num("a1")
  |> should.equal(Error(Nil))

  day_3.get_num("")
  |> should.equal(Error(Nil))
}

pub fn expect_test() {
  day_3.expect("()", "(")
  |> should.equal(Ok(")"))

  day_3.expect("[]", "(")
  |> should.equal(Error(Nil))
}

pub fn expect_args_test() {
  day_3.expect_mul_args("(3,2)rest")
  |> should.equal(Ok(#(6, "rest")))

  day_3.expect_mul_args("1,2)")
  |> should.equal(Error(Nil))
  day_3.expect_mul_args("(,2)")
  |> should.equal(Error(Nil))
  day_3.expect_mul_args("(12)")
  |> should.equal(Error(Nil))
  day_3.expect_mul_args("(1,)")
  |> should.equal(Error(Nil))
  day_3.expect_mul_args("(1,2")
  |> should.equal(Error(Nil))
}

pub fn get_next_instruction_test() {
  day_3.get_next_instruction("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)")
  |> should.equal(Ok(#(day_3.Mul(8), "%&mul[3,7]!@^do_not_mul(5,5)")))

  day_3.get_next_instruction("aaaaa")
  |> should.equal(Error(Nil))
}

pub fn get_muls_test() {
  day_3.get_instructions(
    "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))",
  )
  |> should.equal(161)
}
