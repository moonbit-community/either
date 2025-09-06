
///|
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
pub fn[L, R] left(l: L) -> Either[L, R] {
  Left(l)
}

///|
/// Creates a new Right variant of Either.
///
/// ```mbt
/// let right: Either[Int, String] = right("hello")
/// assert_true(right is Right("hello"))
/// ```
pub fn[L, R] right(r: R) -> Either[L, R] {
  Right(r)
}

pub fn[L, R] from_option_left(v: L?) -> Either[L, R] {
  match v {
    Some(l) => Left(l)
    None => abort("Cannot create Either from None")
  }
}

pub fn[L, R] from_option_right(v: R?) -> Either[L, R] {
  match v {
    Some(r) => Right(r)
    None => abort("Cannot create Either from None")
  }
}

pub fn[L, R] from_option_left_or(v: L?, default: R) -> Either[L, R] {
  match v {
    Some(l) => Left(l)
    None => Right(default)
  }
}

pub fn[L, R] from_option_right_or(v: R?, default: L) -> Either[L, R] {
  match v {
    Some(r) => Right(r)
    None => Left(default)
  }
}

pub fn[L, R] from_option_left_or_else(v: L?, f: () -> R raise?) -> Either[L, R] raise? {
  match v {
    Some(l) => Left(l)
    None => Right(f())
  }
}

pub fn[L, R] from_option_right_or_else(v: R?, f: () -> L raise?) -> Either[L, R] raise? {
  match v {
    Some(r) => Right(r)
    None => Left(f())
  }
}

pub fn[L, R] from_result(r: Result[R, L]) -> Either[L, R] {
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
pub fn[L, R] Either::is_left(self: Self[L, R]) -> Bool {
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
pub fn[L, R] Either::is_right(self: Self[L, R]) -> Bool {
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
pub fn[L, R] Either::left(self: Self[L, R]) -> L? {
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
pub fn[L, R] Either::right(self: Self[L, R]) -> R? {
  match self {
    Left(_) => None
    Right(r) => Some(r)
  }
}

///|
pub fn[L, R] Either::to_result(self: Self[L, R]) -> Result[R, L] {
  match self {
    Left(l) => Err(l)
    Right(r) => Ok(r)
  }
}

///|
#alias(unwrap_left)
pub fn[L, R] Either::left_unwrap(self: Self[L, R]) -> L {
  match self {
    Left(l) => l
    Right(_) => abort("Either::unwrap_left called on Right value")
  }
}

///|
#alias(unwrap_right)
pub fn[L, R] Either::right_unwrap(self: Self[L, R]) -> R {
  match self {
    Left(_) => abort("Either::unwrap_right called on Left value")
    Right(r) => r
  }
}

///|
pub fn[L, R] Either::left_or(self: Self[L, R], default: L) -> L {
  match self {
    Left(l) => l
    Right(_) => default
  }
}

///|
pub fn[L, R] Either::right_or(self: Self[L, R], default: R) -> R {
  match self {
    Left(_) => default
    Right(r) => r
  }
}

///|
pub fn[L, R] Either::left_or_else(self: Self[L, R], f: () -> L raise?) -> L raise? {
  match self {
    Left(l) => l
    Right(_) => f()
  }
}

///|
pub fn[L, R] Either::right_or_else(self: Self[L, R], f: () -> R raise?) -> R raise? {
  match self {
    Left(_) => f()
    Right(r) => r
  }
}

///|
pub fn[L, R] Either::expect_left(self: Self[L, R], msg: String) -> L {
  match self {
    Left(l) => l
    Right(_) => abort(msg)
  }
}

///|
pub fn[L, R] Either::expect_right(self: Self[L, R], msg: String) -> R {
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
pub fn[L, R] Either::flip(self: Self[L, R]) -> Self[R, L] {
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
pub fn[L, R, U] Either::map_left(self: Self[L, R], f: (L) -> U raise?) -> Self[U, R] raise? {
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
pub fn[L, R, U] Either::map_right(self: Self[L, R], f: (R) -> U raise?) -> Self[L, U] raise? {
  match self {
    Left(l) => Left(l)
    Right(r) => Right(f(r))
  }
}

pub fn[T] Either::map(self: Self[T, T], f: (T) -> T raise?) -> Self[T, T] raise? {
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
pub fn[L, ML, R, MR] Either::map_either(self: Self[L, R], fl: (L) -> ML raise?, fr: (R) -> MR raise?) -> Self[ML, MR] raise? {
  match self {
    Left(l) => Left(fl(l))
    Right(r) => Right(fr(r))
  }
}

///|
pub fn[L, R, T] Either::either(self: Self[L, R], fl: (L) -> T raise?, fr: (R) -> T raise?) -> T raise? {
  match self {
    Left(l) => fl(l)
    Right(r) => fr(r)
  }
}

