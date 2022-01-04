# Rescript JS Map

Rescript JS Map is a [ReScript](https://rescript-lang.org/) library that provides bindings to the JavaScript [Map data type](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map).

## Installation

Using `yarn` or `npm`:

```bash
yarn add rescript-js-map
npm install --save rescript-js-map
```

In your `bsconfig.json`, add:

```json
{
  "bs-dependencies": ["rescript-js-map"]
}
```

## Usage

```rescript
module Map = Js_map
let map = Map.make()

let mutatedMap = map->Map.set("hello", "world")
let isPhysicallyEqual = map === mutatedMap // true
let hello = map->Map.get("hello") // Some("world")
let hasHello = map->Map.has("hello") // true
let foo = map->Map.get("bar") // None
let size = map->Map.size // 1
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
