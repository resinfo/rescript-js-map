type t<'key, 'value>

/*
 * Constructor
 */
@ocaml.doc("Creates a new `Map` object.") @new
external make: unit => t<'key, 'value> = "Map"

@ocaml.doc("Creates a new `Map` object.") @new
external fromEntries: array<('key, 'value)> => t<'key, 'value> = "Map"

/*
 * Instance properties
 */
@ocaml.doc("Returns the number of key/value pairs in the `Map` object.") @get
external size: t<'key, 'value> => int = "size"

/*
 * Instance methods
 */
@ocaml.doc("Removes all key-value pairs from the `Map` object.") @send
external clear: t<'key, 'value> => unit = "clear"

@ocaml.doc(
  "Returns `true` if an element in the `Map` object existed and has been removed, or `false` if the element does not exist. `Map.prototype.has(key)` will return `false` afterwards."
)
@send
external delete: (t<'key, 'value>, 'key) => unit = "delete"

@ocaml.doc("Returns the value associated to the key, or `undefined` if there is none.") @send
external get: (t<'key, 'value>, 'key) => option<'value> = "get"

@ocaml.doc(
  "Returns a boolean asserting whether a value has been associated to the key in the `Map` object or not."
)
@send
external has: (t<'key, 'value>, 'key) => bool = "has"

@ocaml.doc("Sets the value for the key in the `Map` object. Returns the `Map` object.") @send
external set: (t<'key, 'value>, 'key, 'value) => t<'key, 'value> = "set"

/*
 * Iteration methods
 */
@ocaml.doc(
  "Returns a new `Iterator` object that contains the keys for each element in the `Map` object in insertion order."
)
@send
external keys: t<'key, 'value> => Js_iterator.t<'key> = "keys"

@ocaml.doc(
  "Returns a new `Iterator` object that contains the values for each element in the `Map` object in insertion order."
)
@send
external values: t<'key, 'value> => Js_iterator.t<'value> = "values"

@ocaml.doc(
  "Returns a new `Iterator` object that contains an array of [key, value] for each element in the `Map` object in insertion order."
)
@send
external entries: t<'key, 'value> => Js_iterator.t<('key, 'value)> = "entries"

@ocaml.doc(
  "Calls `callbackFn` once for each key-value pair present in the `Map` object, in insertion order."
)
@send
external forEach: (t<'key, 'value>, ('value, 'key) => unit) => unit = "forEach"

@ocaml.doc(
  "Calls `callbackFn` once for each key-value pair present in the `Map` object, in insertion order."
)
@send
external forEachWithMap: (t<'key, 'value>, ('value, 'key, t<'key, 'value>) => unit) => unit =
  "forEach"
