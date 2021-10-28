# functional_starter

Flutter project starter using updated MSWS architecture, providing pre-written modules, extensions, and included dependencies for functional Flutter apps.

## Overview

The starter contains included packages, pre-written boilerplate, and provides architectural guidance. It is highly opinionated.

The starter favors static to dynamic, immutability to mutability, functional approach to object-oriented approach, declarative style to imperative style, while not forcing any anti-patterns such as Singletons or others, that are unfortunately widely used.

It is highly functional and embraces the Functional Programming paradigm for every layer – from Business Logic to Widgets. It may seem hard to understand or even redundant, but such an approach solves a lot of issues and allows one to focus on meaningful tasks.

The starter provides a solution, in the form of a pre-written Module or simply included package, for the following problems:
- [ ] HTTP requests
- [ ] Local DB
- [ ] State management
- [ ] Navigation
- [ ] Logging
- [ ] Theming 
- [ ] Localization 
- [ ] Authentication 
- [ ] Testing

Every of the listed solutions is easily substitutable, and any solution can be swapped to another one, or discarded altogether if not needed. 

## Purpose

### Core aspects.

The starter allows rapidly developing correct Flutter applications. It uses heavily Functional Programming, and was built with following aspects kept in mind:
- Correctness. Applications must function predictably and reliably in any case.
- Maintainability. Applications must be easy to maintain, both from cold and practical sense, and from psychological one. Code must not intimidate the developer, even after large intervals of time spent away from it.
- Conciseness and expressiveness. Applications must require little code actually written by the developer. This involves and is not limited to: using a correct paradigm, using code generation, using templates/snippets.
- Declarative style. Anything that can be done, derived or inferred automatically should be done, derived or inferred automatically. This includes, but not limited to: manual subscription or any other lifecycle management, both right and left side type declarations, reassigning of variables, imperative-style loops.

### Design decisions.

The following decisions were made while developing the Starter's design. 

#### Structure. 

Feature first vs Function first – Feature first. This approach scales better, enables more organic encapsulation and makes navigation easier.

#### Paradigm.

OOP vs FP – FP. Functional programming nicely aligns with the core aspects. It allows to write more correct, expressive and maintainable code – even in OOP language that is Dart.

#### Database type.

SQL vs NoSQL – NoSQL. NoSQL databases cover most of the needs of the modern Flutter applications, and helps to get rid of the headaches that SQL databases bring along with their requirements.

## Layers

### Modules layer

Represent business logic as purely functional as possible. Consists of 3 sub-layers: Core, IO, and Program. 
- Core. Pure, non-IO, rarely `Future`, functions that require little dependencies. Uses `Pure`'s Reader Monad / Parametrized Injection to obtain dependencies.
- IO. IO and impure `Future` functions, usually need dynamic dependencies, such as HTTP and DB clients. Uses Reader monad / Parametrized Injection to obtain dynamic dependencies/some static dependencies, or Dependency Rejection on static dependencies.
- Program. Combines and wraps up two previous layers, uses Parametrized Injection for external dependencies, injects static dependencies in IO and Core functions.

### State layer

Specific to concrete state manager. This starter does not force any state management, and end user is free to choose from available options. It's recommended to use any state manager that enforces immutable state, and `Cubit` from the package `flutter_bloc` is one of the options. Please, just don't use GetX.

### Widgets layer

WIP

Represents the layout of the screen. Host Store instance injected using `StoreProvider`, binding their lifecycle to their own, and supply selected state into widgets. Uses Stores to provide state to widgets, but never uses it itself and never uses modules. Uses `Binder`/`Selector` with Display widgets and `El` with Act widgets, supplying an Element to them.

## Code style

### It is a functional starter, and functional style is highly encouraged. 

Usage of non-data and non-widget classes should be limited, and functions must be used as a basic building block. For convenience, readability and discoverability, it is suggested to use named imports only on Modules.

### Decomposition and loose coupling should be always kept in mind. 

Achieving former is easily done in FP – since every function is pure, it can be safely fragmented into smaller ones. Latter is a bit more tricky, and instead of traditional Dependency Injection, several techniques can be used. Starter already forces layering functions from the more pure and abstract to the more impure and concrete, but to decouple thing even more, I suggest reading this cycle of articles – https://fsharpforfunandprofit.com/posts/dependencies/.

### Every function must be pure.

WIP

### Widgets must behave as pure functions

Widgets must behave as pure functions towards the actual UI, even if they are implemented through classes. It is discouraged to pollute feature-specific widgets with calls to the context, making them referentially non-transparent. 

Instead, widgets must accept models as parameters, and display only the information that was given as function arguments or class fields. To perform actions, widgets can directly locate the `Store`/`Cubit`/`BLoC` and add an event/call a method, since those abstractions already decouple state from UI.

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
├── % State management-specific %
└── widgets
    └── screen.dart
```

## Included packages

List of default packages included in starter.

### FP
* pure 
* Fast Immutable Collections

### Remote and local data
* objectbox
* http

### Code generation
* freezed
* freezed_annotation
* json_serializable
* build_runner

## Included Modules

List of pre-written modules included in starter.

### Core

- Logger

### IO

- Navigation
