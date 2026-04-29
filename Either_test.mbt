///|
test "Either Show" {
  let left_value : Either[Int, String] = Left(42)
  let right_value : Either[Int, String] = Right("hello")
  inspect(left_value.to_string(), content="Left(42)")
  inspect(right_value.to_string(), content="Right(\"hello\")")
}
