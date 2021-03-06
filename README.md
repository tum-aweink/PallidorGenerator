# PallidorGenerator

<p align="center">
  <img width="150" src="https://github.com/Apodini/PallidorGenerator/blob/develop/Images/pallidor-icon.png">
</p>

<p align="center">
    <a href="LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/Swift-5.3-blue.svg" alt="Swift 5.3">
    </a>
    <a href="https://github.com/Apodini/PallidorGenerator">
        <img src="https://github.com/Apodini/PallidorGenerator/workflows/Build%20and%20Test/badge.svg" alt="Build and Test">
    </a>
</p>

<p>

`PallidorGenerator` is a Swift package to parse OpenAPI specifications and generate the library layer of a Swift package for client applications. 
It is part of [**Pallidor**](https://github.com/Apodini/Pallidor), a commandline tool which automatically migrates client applications after a Web API dependency changed.

</p>

## Requirements
This library requires at least Swift 5.3 and macOS 10.15.
## Integration
To integrate the `PallidorGenerator` library in your SwiftPM project, add the following line to the dependencies in your `Package.swift` file:
```swift
.package(url: "https://github.com/Apodini/PallidorGenerator.git", .branch("develop"))
```
Since `PallidorGenerator` is currently under active development, there is no guarantee for source-stability.

## Usage
To get started with `PallidorGenerator` you first need to create an instance of it, providing the path to the directory in which the source files are located, as well as the content of the OpenAPI specification (v3):
```swift
var specification : String = ...
let generator = try PallidorGenerator(specification: specification)
```
To start generating the OpenAPI library, you need to call the `generate()` method, providing a `Path` to the target directory where the generated files should be located and a `name` for the package.
```swift
var path: Path = ...
var packageName: String = ...
try generator.generate(target: path, package: packageName)
```
All generated API files will be located under `{targetDirectory}/Models` or `{targetDirectory}/APIs`.
Additionally several meta files which are required for a SPM library are also generated and located under their respective folder in `{targetDirectory}`.

## Documentation
The documentation for this package is generated with [jazzy](https://github.com/realm/jazzy) and can be found [here](https://apodini.github.io/PallidorGenerator/). 

## Contributing
Contributions to this projects are welcome. Please make sure to read the [contribution guidelines](https://github.com/Apodini/.github/blob/release/CONTRIBUTING.md) first.

## License
This project is licensed under the MIT License. See [License](https://github.com/Apodini/Template-Repository/blob/release/LICENSE) for more information.
