///|
test "Either Show" {
  let left_value : @either.Either[Int32, String] = Left(42)
  let right_value : @either.Either[Int32, String] = Right("hello")
  inspect(left_value.to_string(), content="Left(42)")
  inspect(right_value.to_string(), content="Right(hello)")
}
