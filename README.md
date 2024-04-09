# msplabs-project


## FVM Installation

Do install fvm, FVM used 
```
dart pub global activate fvm
```

## Melos Installation

Reference: https://melos.invertase.dev/getting-started#setup
```
dart pub global activate melos
```

## Dependencies Installation

Install yq
```
brew install yq
```

## Creating New Package

To create new package run this command:

```
fvm flutter create --template=package <package_name>
```

## Melos Command

* `melos run analyze` : To analyze all the module
* `melos run pub:get` : To fetch all dependencies within module

## Project Structure

msplabs-project
├── apps
│   ├── apps_1
│   └── apps_2
├── shared_components
│   ├── package_1
│   └── package_2
├── melos.yaml
├── pubspec.yaml
└── README.md
