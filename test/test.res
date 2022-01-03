module Map = Js_map

open Ava

test("Map.make()", t => {
  let map = Map.make()

  t->true_(map->Map.size == 0, ())
})

test("Map.make(entries)", t => {
  let map = Map.fromEntries([("hello", "world")])

  t->true_(map->Map.size == 1, ())

  let map = Map.fromEntries([(12, ())])

  t->true_(map->Map.size == 1, ())

  let map = Map.fromEntries([(Js.null, Js.undefined)])

  t->true_(map->Map.size == 1, ())
})

test("Map.has(map, key)", t => {
  let map = Map.fromEntries([("hello", "world")])

  t->true_(map->Map.has("hello"), ())
})

test("Map.clear(map)", t => {
  let map = Map.fromEntries([("hello", "world")])

  t->true_(map->Map.has("hello"), ())
  t->true_(map->Map.size == 1, ())
  map->Map.clear
  t->false_(map->Map.has("hello"), ())
  t->true_(map->Map.size == 0, ())
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
  t->true_(map->Map.size == 0, ())
  t->true_(map->Map.get("foo") == None, ())

  map->Map.set("foo", "bar")->ignore

  t->true_(map->Map.has("foo"), ())
  t->true_(map->Map.size == 1, ())
  t->true_(map->Map.get("foo") == Some("bar"), ())

  let map = Map.make()

  t->false_(map->Map.has(42), ())
  t->true_(map->Map.size == 0, ())
  t->true_(map->Map.get(42) == None, ())

  map->Map.set(42, "bar")->ignore

  t->true_(map->Map.has(42), ())
  t->true_(map->Map.size == 1, ())
  t->true_(map->Map.get(42) == Some("bar"), ())

  let map = Map.make()
  let fnKey = () => 1
  let fnVal = rest => "12" ++ rest

  t->false_(map->Map.has(fnKey), ())
  t->true_(map->Map.size == 0, ())
  t->true_(map->Map.get(fnKey) == None, ())

  map->Map.set(fnKey, fnVal)->ignore

  t->true_(map->Map.has(fnKey), ())
  t->true_(map->Map.size == 1, ())
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
  let next = iterator->Map.Iterator.next

  t->false_(next->Map.Iterator.done, ())
  t->true_(next->Map.Iterator.value == Some("a"), ())

  let next = iterator->Map.Iterator.next

  t->false_(next->Map.Iterator.done, ())
  t->true_(next->Map.Iterator.value == Some("b"), ())

  let next = iterator->Map.Iterator.next

  t->true_(next->Map.Iterator.done, ())
  t->true_(next->Map.Iterator.value == None, ())

  let next = iterator->Map.Iterator.next

  t->true_(next->Map.Iterator.done, ())
  t->true_(next->Map.Iterator.value == None, ())
})

test("Map.values(map)", t => {
  let map = Map.fromEntries([("1", 1), ("2", 2)])

  let iterator = map->Map.values
  let next = iterator->Map.Iterator.next

  t->false_(next->Map.Iterator.done, ())
  t->true_(next->Map.Iterator.value == Some(1), ())

  let next = iterator->Map.Iterator.next

  t->false_(next->Map.Iterator.done, ())
  t->true_(next->Map.Iterator.value == Some(2), ())

  let next = iterator->Map.Iterator.next

  t->true_(next->Map.Iterator.done, ())
  t->true_(next->Map.Iterator.value == None, ())

  let next = iterator->Map.Iterator.next

  t->true_(next->Map.Iterator.done, ())
  t->true_(next->Map.Iterator.value == None, ())
})

test("Map.entries(map)", t => {
  let map = Map.fromEntries([("1", 1), ("2", 2)])

  let iterator = map->Map.entries
  let next = iterator->Map.Iterator.next

  t->false_(next->Map.Iterator.done, ())
  t->true_(next->Map.Iterator.value == Some(("1", 1)), ())

  let next = iterator->Map.Iterator.next

  t->false_(next->Map.Iterator.done, ())
  t->true_(next->Map.Iterator.value == Some(("2", 2)), ())

  let next = iterator->Map.Iterator.next

  t->true_(next->Map.Iterator.done, ())
  t->true_(next->Map.Iterator.value == None, ())

  let next = iterator->Map.Iterator.next

  t->true_(next->Map.Iterator.done, ())
  t->true_(next->Map.Iterator.value == None, ())
})

test("Map.forEach(map, fn)", t => {
  let map = {
    Map.make()->Map.set("hello", "world")->Map.set("foo", "bar")->Map.set("cheese", "burger")
  }

  let size = ref(0)
  let keyChain = ref("")
  let valueChain = ref("")

  map->Map.forEach((value, key) => {
    size := size.contents + 1
    keyChain := keyChain.contents ++ key
    valueChain := valueChain.contents ++ value
  })

  t->true_(size.contents == 3, ())
  t->true_(keyChain.contents == "hellofoocheese", ())
  t->true_(valueChain.contents == "worldbarburger", ())
})

test("Map.forEachWithMap(map, fn)", t => {
  let map = {
    Map.make()->Map.set(12, "world")->Map.set(12, "bar")->Map.set(10, "burger")
  }

  let size = ref(0)
  let keyChain = ref(0)
  let valueChain = ref("")

  map->Map.forEachWithMap((value, key, this) => {
    size := size.contents + 1
    keyChain := keyChain.contents + key
    valueChain := valueChain.contents ++ value

    t->true_(map == this, ())
    t->true_(map === this, ())
  })

  t->true_(size.contents == 2, ())
  t->true_(keyChain.contents == 22, ())
  t->true_(valueChain.contents == "barburger", ())
})
