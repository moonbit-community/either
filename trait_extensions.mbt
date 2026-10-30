///|
pub extend Either with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Either with Eq::{not_equal, equal}

///|
pub extend Either with Hash::{hash, hash_combine}

///|
pub extend Either with Show::{to_string, output}
