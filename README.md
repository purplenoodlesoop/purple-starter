# functional_starter

Flutter project starter using updated MSWS architecture, providing pre-written modules, extensions, and included dependencies for functional Flutter apps.

## Overview

The starter contains included packages, pre-written boilerplate, and provides architectural guidance. It is highly opinionated.

The starter favors static to dynamic, immutability to mutability, functional approach to object-oriented approach, declarative style to imperative style, while not forcing any anti-patterns such as Singletons or others, that are unfortunately widely used.

It is highly functional and embraces the Functional Programming paradigm for every layer – from Business Logic to Widgets. It may seem hard to understand or even redundant, but such an approach solves a lot of issues and allows one to focus on meaningful tasks.

The starter provides a solution, in the form of a pre-written Module or simply included package, for the following problems:
- [x] HTTP requests
- [x] Local DB
- [x] State management
- [x] Navigation (may change)
- [x] Logging
- [ ] Theming 
- [ ] Localization 
- [ ] Authentication 
- [ ] Testing

Every of the listed solutions is easily substitutable, and any solution can be swapped to another one, or discarded altogether if not needed. 

## Layers

### Modules layer

Represent business logic as purely functional as possible. Consists of 3 sub-layers: Core, IO, and Program. 
- Core. Pure, non-IO, rarely `TaskEither`, functions that require little dependencies. Uses Reader monad to obtain dependencies.
- IO. IO and impure `Task`/`TaskEither` functions, usually need dynamic dependencies, such as HTTP and DB clients. Uses Reader monad/Parametrized Injection to obtain dynamic dependencies/some static dependencies, or Dependency Rejection on static dependencies.
- Program. Combines and wraps up two previous layers, uses Parametrized Injection for external dependencies, injects static dependencies in IO and Core functions.

### Store layer

Expressed through Msg Stores and Msgs, uses Modules, mostly the Program layer, and describes the state of the Feature/Screen. Does not depend on Flutter and is completely UI agnostic.

### Widgets layer

Split up into two sub-layers: Act and Display. Expressed through pure, top-level functions that has type signatures `(BuildContext) -> Widget` and `<ModelPart>(BuildContext, ModelPart) -> Widget`, respectively. Widgets layer never uses Store layer directly, instead, it takes the state as an argument and sends Msgs using context.

### Screens layer

Represents the layout of the screen. Host Store instance injected using `StoreProvider`, binding their lifecycle to their own, and supply selected state into widgets. Uses Stores to provide state to widgets, but never uses it itself and never uses modules. Uses `Binder`/`Selector` with Display widgets and `El` with Act widgets, supplying an Element to them.

## Folder structure

### Project

```
lib
├── common
│   ├── data
│   ├── enums
│   ├── models
│   ├── extensions
│   │   └── % Extensions structure %
│   └── modules
│       └── % Module structure %
├── features
│   ├── % Feature A %
│   │   └── % Feature Structure %
│   ├── % Feature B %
│   └── ...
└── main.dart
```

### Modules

```
modules
├── core (optional)
├── io (optional)
└── program (optional)
```

### Extensions

```
extensions
├── src
│   └── ...
└── extensions.dart
```

### Feature

```
% Feature %
├── models
├── data (optional)
├── enums (optional)
├── modules (optional)
│   └── % Modules structure %
├── extensions (optional)
│   └── % Extensions structure %
├── msg
│   ├── msgs.dart
│   └── store.dart
└── widgets
    └── screen.dart
```

## Included packages

List of default packages included in starter.

### FP
* fpdart
* pure 
* Fast Immutable Collections

### Remote and local data
* sembast
* http

### Code generation
* freezed
* freezed_annotation
* json_serializable
* build_runner

### State management
* provider_msg

## Included Modules

List of pre-written modules included in starter.

### Core

- Pattern-matching

### IO

- Logger
- Navigation
- DB client access
- HTTP client access
- HTTP requests

## Included extensions

- Context
    - IO msg
    - Localization (?, WIP)
- IO / Task
    - Put
    - As Unit
    - Perform IO and discard result 
- Object
    - Is null / is not null