module Map = Js_map
module Iterator = Map.Iterator

open Ava

test("Map.make()", t => {
  let map = Map.make()

  t->is(map->Map.size, 0, ())
})

test("Map.make(entries)", t => {
  let map = Map.fromEntries([("hello", "world")])

  t->is(map->Map.size, 1, ())

  let map = Map.fromEntries([(12, ())])

  t->is(map->Map.size, 1, ())

  let map = Map.fromEntries([(Js.null, Js.undefined)])

  t->is(map->Map.size, 1, ())
})

test("Map.has(map, key)", t => {
  let map = Map.fromEntries([("hello", "world")])

  t->true_(map->Map.has("hello"), ())
})

test("Map.clear(map)", t => {
  let map = Map.fromEntries([("hello", "world")])

  t->true_(map->Map.has("hello"), ())
  t->is(map->Map.size, 1, ())
  map->Map.clear
  t->false_(map->Map.has("hello"), ())
  t->is(map->Map.size, 0, ())
})

test("Map.get(map, key)", t => {
  let map = Map.fromEntries([("hello", "world")])

  t->true_(map->Map.get("hello") == Some("world"), ())
})

test("Map.delete(map, key)", t => {
  let map = Map.fromEntries([("hello", "world")])

  t->true_(map->Map.has("hello"), ())
  t->true_(map->Map.get("hello") == Some("world"), ())

  map->Map.delete("hello")

  t->true_(map->Map.get("hello") == None, ())
  t->false_(map->Map.has("hello"), ())
})

test("Map.set(map, key, value)", t => {
  let map = Map.make()

  t->false_(map->Map.has("foo"), ())
  t->is(map->Map.size, 0, ())
  t->true_(map->Map.get("foo") == None, ())

  let prevMap = map
  let map = map->Map.set("foo", "bar")

  t->true_(prevMap == map, ())
  t->true_(prevMap === map, ())
  t->true_(map->Map.has("foo"), ())
  t->is(map->Map.size, 1, ())
  t->true_(map->Map.get("foo") == Some("bar"), ())

  let map = Map.make()

  t->false_(map->Map.has(42), ())
  t->is(map->Map.size, 0, ())
  t->true_(map->Map.get(42) == None, ())

  map->Map.set(42, "bar")->ignore

  t->true_(map->Map.has(42), ())
  t->is(map->Map.size, 1, ())
  t->true_(map->Map.get(42) == Some("bar"), ())

  let map = Map.make()
  let fnKey = () => 1
  let fnVal = rest => "12" ++ rest

  t->false_(map->Map.has(fnKey), ())
  t->is(map->Map.size, 0, ())
  t->true_(map->Map.get(fnKey) == None, ())

  map->Map.set(fnKey, fnVal)->ignore

  t->true_(map->Map.has(fnKey), ())
  t->is(map->Map.size, 1, ())
  /*
   * This is dangerous, the compiler throws if comparing functions.
   * We get away with it due to the Some() wrapper outputting an object
   */
  t->true_(map->Map.get(fnKey) == Some(fnVal), ())

  switch map->Map.get(fnKey) {
  | None => t->fail()
  | Some(fn) => t->true_(fn("34") == "1234", ())
  }
})

test("Map.keys(map)", t => {
  let map = Map.fromEntries([("a", "a"), ("b", "b")])

  let iterator = map->Map.keys
  let next = iterator->Iterator.next

  t->false_(next->Iterator.done, ())
  t->true_(next->Iterator.value == Some("a"), ())

  let next = iterator->Iterator.next

  t->false_(next->Iterator.done, ())
  t->true_(next->Iterator.value == Some("b"), ())

  let next = iterator->Iterator.next

  t->true_(next->Iterator.done, ())
  t->true_(next->Iterator.value == None, ())

  let next = iterator->Iterator.next

  t->true_(next->Iterator.done, ())
  t->true_(next->Iterator.value == None, ())
})

test("Map.values(map)", t => {
  let map = Map.fromEntries([("1", 1), ("2", 2)])

  let iterator = map->Map.values
  let next = iterator->Iterator.next

  t->false_(next->Iterator.done, ())
  t->true_(next->Iterator.value == Some(1), ())

  let next = iterator->Iterator.next

  t->false_(next->Iterator.done, ())
  t->true_(next->Iterator.value == Some(2), ())

  let next = iterator->Iterator.next

  t->true_(next->Iterator.done, ())
  t->true_(next->Iterator.value == None, ())

  let next = iterator->Iterator.next

  t->true_(next->Iterator.done, ())
  t->true_(next->Iterator.value == None, ())
})

test("Map.entries(map)", t => {
  let map = Map.fromEntries([("1", 1), ("2", 2)])

  let iterator = map->Map.entries
  let next = iterator->Iterator.next

  t->false_(next->Iterator.done, ())
  t->true_(next->Iterator.value == Some(("1", 1)), ())

  let next = iterator->Iterator.next

  t->false_(next->Iterator.done, ())
  t->true_(next->Iterator.value == Some(("2", 2)), ())

  let next = iterator->Iterator.next

  t->true_(next->Iterator.done, ())
  t->true_(next->Iterator.value == None, ())

  let next = iterator->Iterator.next

  t->true_(next->Iterator.done, ())
  t->true_(next->Iterator.value == None, ())
})

test("Map.forEach(map, fn)", t => {
  let map = {
    Map.make()->Map.set("hello", "world")->Map.set("foo", "bar")->Map.set("cheese", "burger")
  }

  let size = ref(0)
  let keys = ref("")
  let values = ref("")

  map->Map.forEach((value, key) => {
    size := size.contents + 1
    keys := keys.contents ++ key
    values := values.contents ++ value
  })

  t->is(size.contents, 3, ())
  t->is(keys.contents, "hellofoocheese", ())
  t->is(values.contents, "worldbarburger", ())
})

test("Map.forEachWithMap(map, fn)", t => {
  let map = {
    Map.make()->Map.set(12, "world")->Map.set(12, "bar")->Map.set(10, "burger")
  }

  let size = ref(0)
  let keys = ref(0)
  let values = ref("")

  map->Map.forEachWithMap((value, key, this) => {
    size := size.contents + 1
    keys := keys.contents + key
    values := values.contents ++ value

    t->true_(map == this, ())
    t->true_(map === this, ())
  })

  t->is(size.contents, 2, ())
  t->is(keys.contents, 22, ())
  t->is(values.contents, "barburger", ())
})
