# Either

A MoonBit library providing the `Either` type for representing values with two possible types, inspired by Rust's either library and Haskell's either library.

The `Either` type is a simple but powerful sum type that can hold one of two possible values: `Left(L)` or `Right(R)`. It's commonly used for error handling, representing success/failure scenarios, or any situation where you need to choose between two alternative types.

## Basic Usage

### Creating Either Values

```moonbit
test "creating either values" {
  // Create Left and Right values
  let left_val : Either[Int, String] = left(42)
  let right_val : Either[Int, String] = right("hello")
  
  // Using constructors directly
  let left_direct : Either[Int, Unit] = Left(42)
  let right_direct : Either[Unit, String] = Right("hello")
  
  assert_true(left_val is Left(42))
  assert_true(right_val is Right("hello"))
  assert_true(left_direct is Left(42))
  assert_true(right_direct is Right("hello"))
}
```

### Checking Either Variants

```moonbit
test "checking variants" {
  let values : Array[Either[Int, String]] = [Left(1), Right("two"), Left(3)]
  
  // Using is_left() and is_right()
  assert_true(values[0].is_left())
  assert_true(values[1].is_right())
  assert_false(values[2].is_right())
  
  // Using pattern matching with `is` (preferred)
  assert_true(values[0] is Left(_))
  assert_true(values[1] is Right(_))
  assert_false(values[2] is Right(_))
}
```

### Extracting Values

```moonbit
test "extracting values" {
  let left_val : Either[Int, String] = Either::Left(42)
  let right_val : Either[Int, String] = Either::Right("hello")
  
  // Extract as Option
  assert_true(left_val.left() is Some(42))
  assert_true(left_val.right() is None)
  assert_true(right_val.right() is Some("hello"))
  assert_true(right_val.left() is None)
  
  // Extract with default values
  assert_eq(left_val.left_or(0), 42)
  assert_eq(left_val.right_or("default"), "default")
  assert_eq(right_val.left_or(0), 0)
  assert_eq(right_val.right_or("default"), "hello")
}
```

## Transformations

### Mapping Operations

```moonbit
test "mapping operations" {
  let left : Either[Int, String] = Left(10)
  let right : Either[Int, String] = Right("hello")
  
  // Map left side only
  let mapped_left = left.map_left(x => x * 2)
  assert_true(mapped_left is Left(20))
  
  // Map right side only  
  let mapped_right = right.map_right(s => s + " world")
  assert_true(mapped_right is Right("hello world"))
  
  // Map both sides (bimap)
  let bimapped = left.map_either(x => x * 2, s => s + " world")
  assert_true(bimapped is Left(20))
}
```

### Type Conversions

```moonbit
test "type conversions" {
  // From Option
  let some_val: Int? = Some(42)
  let none_val: Int? = None
  
  let either_from_some = from_option_left_or(some_val, "default")
  assert_true(either_from_some is Left(42))
  
  let either_from_none = from_option_left_or(none_val, "default")
  assert_true(either_from_none is Right("default"))
  
  // From Result
  let ok_result: Result[String, Int] = Ok("success")
  let err_result: Result[String, Int] = Err(404)
  
  let either_ok = from_result(ok_result)
  assert_true(either_ok is Right("success"))
  
  let either_err = from_result(err_result)
  assert_true(either_err is Left(404))
  
  // To Result
  let left_either : Either[Int, String] = Left(404)
  let result_from_either = left_either.to_result()
  assert_true(result_from_either is Err(404))
}
```

## Utility Operations

```moonbit
test "utility operations" {
  let left : Either[Int, String] = Left(42)
  let right : Either[Int, String] = Right("hello")
  
  // Flip Left and Right
  assert_true(left.flip() is Right(42))
  assert_true(right.flip() is Left("hello"))
  
  // Expect operations (abort on wrong variant)
  assert_eq(left.expect_left("Expected left"), 42)
  assert_eq(right.expect_right("Expected right"), "hello")
  
  // Or else operations with lazy evaluation
  let computed_left = right.left_or_else(() => 100)
  assert_eq(computed_left, 100)
  
  let computed_right = left.right_or_else(() => "computed")
  assert_eq(computed_right, "computed")
}
```

## Advanced Usage

```moonbit
test "advanced usage" {
  // Chain operations
  let result = Left(5)
    |> Either::map_left(x => x * 2)  // Left(10)
    |> Either::map_right(x => x + 1) // Still Left(10)
    |> Either::flip()                // Right(10)
    |> Either::map_right(x => x + 5) // Right(15)
  
  assert_true(result is Right(15))
  
  // Combining with control flow
  let values: Array[Either[Int, String]] = [Left(1), Right("two"), Left(3)]
  let lefts = []
  let rights = []
  
  for either in values {
    match either {
      Either::Left(x) => lefts.push(x)
      Either::Right(s) => rights.push(s)
    }
  }
  
  assert_eq(lefts, [1, 3])
  assert_eq(rights, ["two"])
}
```

## API Reference

The library provides comprehensive functionality for working with `Either` values:

- **Constructors**: `left()`, `right()`
- **Type checks**: `is_left()`, `is_right()`  
- **Value extraction**: `left()`, `right()`, `left_or()`, `right_or()`, `left_or_else()`, `right_or_else()`
- **Safe unwrapping**: `expect_left()`, `expect_right()`, `left_unwrap()`, `right_unwrap()`
- **Transformations**: `map_left()`, `map_right()`, `map_either()`, `flip()`
- **Case analysis**: `either()`
- **Conversions**: `from_option_*()`, `from_result()`, `to_result()`

This library makes it easy to work with sum types in a functional programming style, providing a robust foundation for error handling and representing alternative outcomes.
