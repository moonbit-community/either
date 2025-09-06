///|
/// Inspired by Haskell's Either and Rust's either library, this enum represents a value that can be one of two types.
pub(all) enum Either[L, R] {
  Left(L)
  Right(R)
} derive(Show, Eq, Hash)

///|
/// Creates a new Left variant of Either.
///
/// ```mbt
/// let left: Either[Int, String] = left(123)
/// assert_true(left is Left(123))
/// ```
pub fn[L, R] left(l : L) -> Either[L, R] {
  Left(l)
}

///|
/// Creates a new Right variant of Either.
///
/// ```mbt
/// let right: Either[Int, String] = right("hello")
/// assert_true(right is Right("hello"))
/// ```
pub fn[L, R] right(r : R) -> Either[L, R] {
  Right(r)
}

///|
/// Converts an `Option[L]` to `Either[L, R]`, placing the value in the Left variant.
/// Aborts if the option is None.
///
/// ```mbt
/// let some_value: Int? = Some(42)
/// let result : Either[Int, Unit] = from_option_left(some_value)
/// assert_true(result is Left(42))
/// ```
pub fn[L, R] from_option_left(v : L?) -> Either[L, R] {
  match v {
    Some(l) => Left(l)
    None => abort("Cannot create Either from None")
  }
}

///|
/// Converts an `Option[R]` to `Either[L, R]`, placing the value in the Right variant.
/// Aborts if the option is None.
///
/// ```mbt
/// let some_value: String? = Some("hello")
/// let result : Either[Unit, String] = from_option_right(some_value)
/// assert_true(result is Right("hello"))
/// ```
pub fn[L, R] from_option_right(v : R?) -> Either[L, R] {
  match v {
    Some(r) => Right(r)
    None => abort("Cannot create Either from None")
  }
}

///|
/// Converts an `Option[L]` to `Either[L, R]`, placing the value in the Left variant.
/// If the option is None, returns Right with the provided default value.
///
/// ```mbt
/// let some_value: Int? = Some(42)
/// let result = from_option_left_or(some_value, "default")
/// assert_true(result is Left(42))
///
/// let none_value: Int? = None
/// let result2 = from_option_left_or(none_value, "default")
/// assert_true(result2 is Right("default"))
/// ```
pub fn[L, R] from_option_left_or(v : L?, default : R) -> Either[L, R] {
  match v {
    Some(l) => Left(l)
    None => Right(default)
  }
}

///|
/// Converts an `Option[R]` to `Either[L, R]`, placing the value in the Right variant.
/// If the option is None, returns Left with the provided default value.
///
/// ```mbt
/// let some_value: String? = Some("hello")
/// let result = from_option_right_or(some_value, 42)
/// assert_true(result is Right("hello"))
///
/// let none_value: String? = None
/// let result2 = from_option_right_or(none_value, 42)
/// assert_true(result2 is Left(42))
/// ```
pub fn[L, R] from_option_right_or(v : R?, default : L) -> Either[L, R] {
  match v {
    Some(r) => Right(r)
    None => Left(default)
  }
}

///|
/// Converts an `Option[L]` to `Either[L, R]`, placing the value in the Left variant.
/// If the option is None, returns Right with the result of calling the provided function.
///
/// ```mbt
/// let some_value: Int? = Some(42)
/// let result = from_option_left_or_else(some_value, () => "computed")
/// assert_true(result is Left(42))
///
/// let none_value: Int? = None
/// let result2 = from_option_left_or_else(none_value, () => "computed")
/// assert_true(result2 is Right("computed"))
/// ```
pub fn[L, R] from_option_left_or_else(
  v : L?,
  f : () -> R raise?,
) -> Either[L, R] raise? {
  match v {
    Some(l) => Left(l)
    None => Right(f())
  }
}

///|
/// Converts an `Option[R]` to `Either[L, R]`, placing the value in the Right variant.
/// If the option is None, returns Left with the result of calling the provided function.
///
/// ```mbt
/// let some_value: String? = Some("hello")
/// let result = from_option_right_or_else(some_value, () => 42)
/// assert_true(result is Right("hello"))
///
/// let none_value: String? = None
/// let result2 = from_option_right_or_else(none_value, () => 42)
/// assert_true(result2 is Left(42))
/// ```
pub fn[L, R] from_option_right_or_else(
  v : R?,
  f : () -> L raise?,
) -> Either[L, R] raise? {
  match v {
    Some(r) => Right(r)
    None => Left(f())
  }
}

///|
/// Converts a `Result[R, L]` to `Either[L, R]`.
/// Success values become Right, error values become Left.
///
/// ```mbt
/// let ok_result: Result[String, Int] = Ok("success")
/// let either_ok = from_result(ok_result)
/// assert_true(either_ok is Right("success"))
///
/// let err_result: Result[String, Int] = Err(404)
/// let either_err = from_result(err_result)
/// assert_true(either_err is Left(404))
/// ```
pub fn[L, R] from_result(r : Result[R, L]) -> Either[L, R] {
  match r {
    Ok(v) => Right(v)
    Err(e) => Left(e)
  }
}

///|
/// Returns true if the Either is a Left variant.
///
/// ```mbt
/// let values : Array[Either[Int, String]] = [Left(1), Right("two"), Left(3)]
/// assert_true(values[0].is_left())
/// assert_false(values[1].is_left())
/// assert_true(values[2].is_left())
///
/// // Note: use `is` may be better.
/// assert_true(values[0] is Left(_))
/// assert_false(values[1] is Left(_))
/// assert_true(values[2] is Left(_))
/// ```
pub fn[L, R] Either::is_left(self : Self[L, R]) -> Bool {
  match self {
    Left(_) => true
    Right(_) => false
  }
}

///|
/// Returns true if the Either is a Right variant.
///
/// ```mbt
/// let values : Array[Either[Int, String]] = [Left(1), Right("two"), Left(3)]
/// assert_false(values[0].is_right())
/// assert_true(values[1].is_right())
/// assert_false(values[2].is_right())
///
/// // Note: use `is` may be better.
/// assert_false(values[0] is Right(_))
/// assert_true(values[1] is Right(_))
/// assert_false(values[2] is Right(_))
/// ```
pub fn[L, R] Either::is_right(self : Self[L, R]) -> Bool {
  match self {
    Left(_) => false
    Right(_) => true
  }
}

///|
/// Convert the left side of `Either[L, R]` to an `Option[L]`.
///
/// ```mbt
/// let values : Array[Either[Int, String]] = [Left(1), Right("two"), Left(3)]
/// assert_true(values[0].left() is Some(_))
/// assert_true(values[1].left() is None)
/// assert_true(values[2].left() is Some(_))
/// ```
pub fn[L, R] Either::left(self : Self[L, R]) -> L? {
  match self {
    Left(l) => Some(l)
    Right(_) => None
  }
}

///|
/// Convert the right side of `Either[L, R]` to an `Option[R]`.
/// 
/// ```mbt
/// let values : Array[Either[Int, String]] = [Left(1), Right("two"), Left(3)]
/// assert_true(values[0].right() is None)
/// assert_true(values[1].right() is Some(_))
/// assert_true(values[2].right() is None)
/// ```
pub fn[L, R] Either::right(self : Self[L, R]) -> R? {
  match self {
    Left(_) => None
    Right(r) => Some(r)
  }
}

///|
/// Converts an `Either[L, R]` to `Result[R, L]`.
/// Right values become Ok, Left values become Err.
///
/// ```mbt
/// let right_value: Either[String, Int] = Right(42)
/// let result_ok = right_value.to_result()
/// assert_true(result_ok is Ok(42))
///
/// let left_value: Either[String, Int] = Left("error")
/// let result_err = left_value.to_result()
/// assert_true(result_err is Err("error"))
/// ```
pub fn[L, R] Either::to_result(self : Self[L, R]) -> Result[R, L] {
  match self {
    Left(l) => Err(l)
    Right(r) => Ok(r)
  }
}

///|
/// Unwraps the Left value from an Either.
/// Aborts if the Either is a Right variant.
///
/// ```mbt
/// let left_value: Either[Int, String] = Left(42)
/// let unwrapped = left_value.left_unwrap()
/// assert_eq(unwrapped, 42)
/// ```
#alias(unwrap_left)
pub fn[L, R] Either::left_unwrap(self : Self[L, R]) -> L {
  match self {
    Left(l) => l
    Right(_) => abort("Either::unwrap_left called on Right value")
  }
}

///|
/// Unwraps the Right value from an Either.
/// Aborts if the Either is a Left variant.
///
/// ```mbt
/// let right_value: Either[Int, String] = Right("hello")
/// let unwrapped = right_value.right_unwrap()
/// assert_eq(unwrapped, "hello")
/// ```
#alias(unwrap_right)
pub fn[L, R] Either::right_unwrap(self : Self[L, R]) -> R {
  match self {
    Left(_) => abort("Either::unwrap_right called on Left value")
    Right(r) => r
  }
}

///|
/// Returns the Left value if present, otherwise returns the provided default.
///
/// ```mbt
/// let left_value: Either[Int, String] = Left(42)
/// assert_eq(left_value.left_or(0), 42)
///
/// let right_value: Either[Int, String] = Right("hello")
/// assert_eq(right_value.left_or(0), 0)
/// ```
pub fn[L, R] Either::left_or(self : Self[L, R], default : L) -> L {
  match self {
    Left(l) => l
    Right(_) => default
  }
}

///|
/// Returns the Right value if present, otherwise returns the provided default.
///
/// ```mbt
/// let right_value: Either[Int, String] = Right("hello")
/// assert_eq(right_value.right_or("default"), "hello")
///
/// let left_value: Either[Int, String] = Left(42)
/// assert_eq(left_value.right_or("default"), "default")
/// ```
pub fn[L, R] Either::right_or(self : Self[L, R], default : R) -> R {
  match self {
    Left(_) => default
    Right(r) => r
  }
}

///|
/// Returns the Left value if present, otherwise returns the result of calling the provided function.
///
/// ```mbt
/// let left_value: Either[Int, String] = Left(42)
/// assert_eq(left_value.left_or_else(() => 0), 42)
///
/// let right_value: Either[Int, String] = Right("hello")
/// assert_eq(right_value.left_or_else(() => 100), 100)
/// ```
pub fn[L, R] Either::left_or_else(
  self : Self[L, R],
  f : () -> L raise?,
) -> L raise? {
  match self {
    Left(l) => l
    Right(_) => f()
  }
}

///|
/// Returns the Right value if present, otherwise returns the result of calling the provided function.
///
/// ```mbt
/// let right_value: Either[Int, String] = Right("hello")
/// assert_eq(right_value.right_or_else(() => "default"), "hello")
///
/// let left_value: Either[Int, String] = Left(42)
/// assert_eq(left_value.right_or_else(() => "computed"), "computed")
/// ```
pub fn[L, R] Either::right_or_else(
  self : Self[L, R],
  f : () -> R raise?,
) -> R raise? {
  match self {
    Left(_) => f()
    Right(r) => r
  }
}

///|
/// Returns the Left value if present, otherwise aborts with the provided message.
///
/// ```mbt
/// let left_value: Either[Int, String] = Left(42)
/// let unwrapped = left_value.expect_left("Expected left value")
/// assert_eq(unwrapped, 42)
/// ```
pub fn[L, R] Either::expect_left(self : Self[L, R], msg : String) -> L {
  match self {
    Left(l) => l
    Right(_) => abort(msg)
  }
}

///|
/// Returns the Right value if present, otherwise aborts with the provided message.
///
/// ```mbt
/// let right_value: Either[Int, String] = Right("hello")
/// let unwrapped = right_value.expect_right("Expected right value")
/// assert_eq(unwrapped, "hello")
/// ```
pub fn[L, R] Either::expect_right(self : Self[L, R], msg : String) -> R {
  match self {
    Left(_) => abort(msg)
    Right(r) => r
  }
}

///|
/// Convert `Either[L, R]` to `Either[R, L]`.
///
/// ```mbt
/// let left : Either[Int, Unit] = Left(123)
/// assert_true(left.flip() is Right(123))
///
/// let right : Either[Unit, String] = Right("hello")
/// assert_true(right.flip() is Left("hello"))
/// ```
pub fn[L, R] Either::flip(self : Self[L, R]) -> Self[R, L] {
  match self {
    Left(l) => Right(l)
    Right(r) => Left(r)
  }
}

///|
/// Apply the function `f` on the value in the `Left` variant, if it is present
/// rewrapping the result in `Left`.
///
/// ```mbt
/// let left : Either[Int, Unit] = Left(123)
/// let new_left = left.map_left(x => x + 1)
/// assert_true(new_left is Left(124))
///
/// let right : Either[Int, String] = Right("hello")
/// let new_right = right.map_left(x => x + 1)
/// assert_true(new_right is Right("hello"))
/// ```
pub fn[L, R, U] Either::map_left(
  self : Self[L, R],
  f : (L) -> U raise?,
) -> Self[U, R] raise? {
  match self {
    Left(l) => Left(f(l))
    Right(r) => Right(r)
  }
}

///|
/// Apply the function `f` on the value in the `Right` variant, if it is present
/// rewrapping the result in `Right`.
///
/// ```mbt
/// let left : Either[Int, String] = Left(123)
/// let new_left = left.map_right(x => x + " world")
/// assert_true(new_left is Left(123))
///
/// let right : Either[Unit, String] = Right("hello")
/// let new_right = right.map_right(x => x + " world")
/// assert_true(new_right is Right("hello world"))
/// ```
pub fn[L, R, U] Either::map_right(
  self : Self[L, R],
  f : (R) -> U raise?,
) -> Self[L, U] raise? {
  match self {
    Left(l) => Left(l)
    Right(r) => Right(f(r))
  }
}

///|
/// Apply the function `f` to the value in either the Left or Right variant
/// when both variants have the same type.
///
/// ```mbt
/// let left : Either[Int, Int] = Left(5)
/// let new_left = left.map(x => x * 2)
/// assert_true(new_left is Left(10))
///
/// let right : Either[Int, Int] = Right(5)
/// let new_right = right.map(x => x * 2)
/// assert_true(new_right is Right(10))
/// ```
pub fn[T] Either::map(
  self : Self[T, T],
  f : (T) -> T raise?,
) -> Self[T, T] raise? {
  match self {
    Left(l) => Left(f(l))
    Right(r) => Right(f(r))
  }
}

///|
/// Apply the functions `f` and `g` to the `Left` and `Right` variants respectively.
///
/// This is equivalent to [bimap](https://hackage.haskell.org/package/base/docs/Data-Either.html#v:bimap) in Haskell.
///
/// ```mbt
/// let left : Either[Int, String] = Left(123)
/// let new_left = left.map_either(x => x + 1, s => s + " world")
/// assert_true(new_left is Left(124))
///
/// let right : Either[Int, String] = Right("hello")
/// let new_right = right.map_either(x => x + 1, s => s + " world")
/// assert_true(new_right is Right("hello world"))
/// ```
#alias(bimap)
pub fn[L, ML, R, MR] Either::map_either(
  self : Self[L, R],
  fl : (L) -> ML raise?,
  fr : (R) -> MR raise?,
) -> Self[ML, MR] raise? {
  match self {
    Left(l) => Left(fl(l))
    Right(r) => Right(fr(r))
  }
}

///|
/// Case analysis for Either. Applies the first function to Left values and 
/// the second function to Right values, returning the result.
///
/// ```mbt
/// let left : Either[Int, String] = Left(42)
/// let result1 = left.either(x => x * 2, s => s.length())
/// assert_eq(result1, 84)
///
/// let right : Either[Int, String] = Right("hello")
/// let result2 = right.either(x => x * 2, s => s.length())
/// assert_eq(result2, 5)
/// ```
pub fn[L, R, T] Either::either(
  self : Self[L, R],
  fl : (L) -> T raise?,
  fr : (R) -> T raise?,
) -> T raise? {
  match self {
    Left(l) => fl(l)
    Right(r) => fr(r)
  }
}

pub fn[L, R, S] Either::left_and_then(self: Self[L, R], f: (L) -> Either[S, R] raise?) -> Either[S, R] raise? {
  match self {
    Left(l) => f(l)
    Right(r) => Right(r)
  }
}

pub fn[L, R, S] Either::right_and_then(self: Self[L, R], f: (R) -> Either[L, S] raise?) -> Either[L, S] raise? {
  match self {
    Left(l) => Left(l)
    Right(r) => f(r)
  }
}

pub fn[L, R] Either::factor_none(self: Self[L?, R?]) -> Either[L, R]? {
  match self {
    Left(Some(l)) => Some(Left(l))
    Left(None) => None
    Right(Some(r)) => Some(Right(r))
    Right(None) => None
  }
}

pub fn[L, R, E] Either::factor_err(self: Self[Result[L, E], Result[R, E]]) -> Result[Either[L, R], E] {
  match self {
    Left(Ok(l)) => Ok(Left(l))
    Left(Err(e)) => Err(e)
    Right(Ok(r)) => Ok(Right(r))
    Right(Err(e)) => Err(e)
  }
}

pub fn[T, L, R] Either::factor_ok(self: Self[Result[T, L], Result[T, R]]) -> Result[T, Either[L, R]] {
  match self {
    Left(Ok(t)) => Ok(t)
    Left(Err(l)) => Err(Left(l))
    Right(Ok(t)) => Ok(t)
    Right(Err(r)) => Err(Right(r))
  }
}

pub fn[T, L, R] Either::factor_first(self: Self[(T, L), (T, R)]) -> (T, Self[L, R]) {
  match self {
    Left((t, l)) => (t, Left(l))
    Right((t, r)) => (t, Right(r))
  }
}

pub fn[T, L, R] Either::factor_second(self: Self[(L, T), (R, T)]) -> (Self[L, R], T) {
  match self {
    Left((l, t)) => (Left(l), t)
    Right((r, t)) => (Right(r), t)
  }
}


pub fn[L, R] partition(eithers: Array[Either[L, R]]) ->(Array[L], Array[R]) {
  let larr : Array[L] = Array::new()
  let rarr : Array[R] = Array::new()

  eithers.each(e => {
    match e {
      Left(l) => larr.push(l)
      Right(r) => rarr.push(r)
    }
  })
  (larr, rarr)
}

#alias(left_collect)
pub fn[L, R] collect_lefts(eithers: Array[Either[L, R]]) -> Array[L] {
  let larr : Array[L] = Array::new()
  eithers.each(e => {
    match e {
      Left(l) => larr.push(l)
      Right(_) => ()
    }
  })
  larr
}

#alias(right_collect)
pub fn[L, R] collect_rights(eithers: Array[Either[L, R]]) -> Array[R] {
  let rarr : Array[R] = Array::new()
  eithers.each(e => {
    match e {
      Left(_) => ()
      Right(r) => rarr.push(r)
    }
  })
  rarr
}
