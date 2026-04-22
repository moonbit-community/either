# Either

[中文版](#chinese-version)

A MoonBit library providing the `Either` type for representing values with two possible types, inspired by Rust's either library and Haskell's either library.

The `Either` type is a simple but powerful sum type that can hold one of two possible values: `Left(L)` or `Right(R)`. It's commonly used for error handling, representing success/failure scenarios, or any situation where you need to choose between two alternative types.

## Basic Usage

### Creating Either Values

```moonbit nocheck
///|
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

```moonbit nocheck
///|
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

```moonbit nocheck
///|
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

```moonbit nocheck
///|
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

```moonbit nocheck
///|
test "type conversions" {
  // From Option
  let some_val : Int? = Some(42)
  let none_val : Int? = None

  let either_from_some = from_option_left_or(some_val, "default")
  assert_true(either_from_some is Left(42))

  let either_from_none = from_option_left_or(none_val, "default")
  assert_true(either_from_none is Right("default"))

  // From Result
  let ok_result : Result[String, Int] = Ok("success")
  let err_result : Result[String, Int] = Err(404)

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

```moonbit nocheck
///|
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

```moonbit nocheck
///|
test "advanced usage" {
  // Chain operations
  let result = Left(5)
    |> Either::map_left(x => x * 2) // Left(10)
    |> Either::map_right(x => x + 1) // Still Left(10)
    |> Either::flip() // Right(10)
    |> Either::map_right(x => x + 5) // Right(15)

  assert_true(result is Right(15))

  // Combining with control flow
  let values : Array[Either[Int, String]] = [Left(1), Right("two"), Left(3)]
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

This library makes it easy to work with sum types in a functional programming style, providing a robust foundation for representing alternative outcomes.

---

<a name="chinese-version"></a>
# Either (中文版)

一个 MoonBit 库，提供 `Either` 类型，用于表示具有两种可能类型的值，其灵感来源于 Rust 的 `either` 库和 Haskell 的 `either` 库。

`Either` 类型是一个简单但功能强大的和类型，可以容纳两个可能值之一：`Left(L)` 或 `Right(R)`。它通常用于任何需要在两种备选类型之间进行选择的情况。

## 基本用法

### 创建 Either 值

```moonbit nocheck
///|
test "creating either values" {
  // 创建 Left 和 Right 值
  let left_val : Either[Int, String] = left(42)
  let right_val : Either[Int, String] = right("hello")

  // 直接使用构造函数
  let left_direct : Either[Int, Unit] = Left(42)
  let right_direct : Either[Unit, String] = Right("hello")

  assert_true(left_val is Left(42))
  assert_true(right_val is Right("hello"))
  assert_true(left_direct is Left(42))
  assert_true(right_direct is Right("hello"))
}
```

### 检查 Either 变体

```moonbit nocheck
///|
test "checking variants" {
  let values : Array[Either[Int, String]] = [Left(1), Right("two"), Left(3)]

  // 使用 is_left() 和 is_right()
  assert_true(values[0].is_left())
  assert_true(values[1].is_right())
  assert_false(values[2].is_right())

  // 使用 `is` 进行模式匹配 (首选)
  assert_true(values[0] is Left(_))
  assert_true(values[1] is Right(_))
  assert_false(values[2] is Right(_))
}
```

### 提取值

```moonbit nocheck
///|
test "extracting values" {
  let left_val : Either[Int, String] = Either::Left(42)
  let right_val : Either[Int, String] = Either::Right("hello")

  // 提取为 Option
  assert_true(left_val.left() is Some(42))
  assert_true(left_val.right() is None)
  assert_true(right_val.right() is Some("hello"))
  assert_true(right_val.left() is None)

  // 使用默认值提取
  assert_eq(left_val.left_or(0), 42)
  assert_eq(left_val.right_or("default"), "default")
  assert_eq(right_val.left_or(0), 0)
  assert_eq(right_val.right_or("default"), "hello")
}
```

## 转换

### 映射操作

```moonbit nocheck
///|
test "mapping operations" {
  let left : Either[Int, String] = Left(10)
  let right : Either[Int, String] = Right("hello")

  // 只映射 left
  let mapped_left = left.map_left(x => x * 2)
  assert_true(mapped_left is Left(20))

  // 只映射 right
  let mapped_right = right.map_right(s => s + " world")
  assert_true(mapped_right is Right("hello world"))

  // 映射两边 (bimap)
  let bimapped = left.map_either(x => x * 2, s => s + " world")
  assert_true(bimapped is Left(20))
}
```

### 类型转换

```moonbit nocheck
///|
test "type conversions" {
  // 从 Option
  let some_val : Int? = Some(42)
  let none_val : Int? = None

  let either_from_some = from_option_left_or(some_val, "default")
  assert_true(either_from_some is Left(42))

  let either_from_none = from_option_left_or(none_val, "default")
  assert_true(either_from_none is Right("default"))

  // 从 Result
  let ok_result : Result[String, Int] = Ok("success")
  let err_result : Result[String, Int] = Err(404)

  let either_ok = from_result(ok_result)
  assert_true(either_ok is Right("success"))

  let either_err = from_result(err_result)
  assert_true(either_err is Left(404))

  // 转换为 Result
  let left_either : Either[Int, String] = Left(404)
  let result_from_either = left_either.to_result()
  assert_true(result_from_either is Err(404))
}
```

## 实用操作

```moonbit nocheck
///|
test "utility operations" {
  let left : Either[Int, String] = Left(42)
  let right : Either[Int, String] = Right("hello")

  // 翻转 Left 和 Right
  assert_true(left.flip() is Right(42))
  assert_true(right.flip() is Left("hello"))

  // Expect 操作 (在错误的变体上会中止)
  assert_eq(left.expect_left("Expected left"), 42)
  assert_eq(right.expect_right("Expected right"), "hello")

  // 使用惰性求值的 or_else 操作
  let computed_left = right.left_or_else(() => 100)
  assert_eq(computed_left, 100)

  let computed_right = left.right_or_else(() => "computed")
  assert_eq(computed_right, "computed")
}
```

## 高级用法

```moonbit nocheck
///|
test "advanced usage" {
  // 链式操作
  let result = Left(5)
    |> Either::map_left(x => x * 2) // Left(10)
    |> Either::map_right(x => x + 1) // 仍然是 Left(10)
    |> Either::flip() // Right(10)
    |> Either::map_right(x => x + 5) // Right(15)

  assert_true(result is Right(15))

  // 与控制流结合
  let values : Array[Either[Int, String]] = [Left(1), Right("two"), Left(3)]
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

## API 参考

该库为使用 `Either` 值提供了全面的功能：

- **构造函数**: `left()`, `right()`
- **类型检查**: `is_left()`, `is_right()`  
- **值提取**: `left()`, `right()`, `left_or()`, `right_or()`, `left_or_else()`, `right_or_else()`
- **安全解包**: `expect_left()`, `expect_right()`, `left_unwrap()`, `right_unwrap()`
- **转换**: `map_left()`, `map_right()`, `map_either()`, `flip()`
- **情况分析**: `either()`
- **转换**: `from_option_*()`, `from_result()`, `to_result()`

该库使以函数式编程风格使用和类型变得容易，为表示备选结果提供了坚实的基础。
