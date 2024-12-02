import day_1
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn divide_lists_test() {
  day_1.divide_lists(["3   4", "4   3", "2   5", "1   3", "3   9", "3   3"])
  |> should.equal(
    #(["3", "3", "1", "2", "4", "3"], ["3", "9", "3", "5", "3", "4"]),
  )
}

pub fn get_total_distance_test() {
  day_1.get_total_distance([1, 2, 3, 3, 3, 4], [3, 3, 3, 4, 5, 9])
  |> should.equal(11)
}

pub fn get_similarity_score_test() {
  day_1.get_similarity_score([1, 2, 3, 3, 3, 4], [3, 3, 3, 4, 5, 9])
  |> should.equal(31)
}

pub fn count_appearances_test() {
  day_1.count_appearances(3, [1, 2, 3, 3, 3, 4])
  |> should.equal(3)

  day_1.count_appearances(5, [1, 2, 3, 3, 3, 4])
  |> should.equal(0)
}
