# GymApplication

## Description

My Gym Mobile App is a cross-platform mobile application designed to help users track their fitness goals. It supports both Android and iOS platforms and offers features such as workout tracking, goal setting, and performance analysis.

## Features

- Cross-platform support for Android and iOS
- Workout tracking and goal setting

## Installation

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (for Flutter-based apps)
- [Android Studio](https://developer.android.com/studio) or [Xcode](https://developer.apple.com/xcode/) for development

### Clone the Repository

git clone https://github.com/SkyMatlani-a11y/GymApplication
cd your-repository

Android Setup
1) Open the project in Android Studio.
2) Set up an Android emulator or connect an Android device.
3) Run the app
4) flutter run

iOS Setup
1) Open the ios folder in Xcode.
2) Set up an iOS simulator or connect an iOS device.
3) Run the app
4) flutter run

## Architectural Choices and Third-Party Packages

### Architectural Choices

Our application is built using the following architectural principles:
- **Riverpod for State Management**: We use [Riverpod](https://pub.dev/packages/riverpod) for state management due to its improved type safety, modularity, and automatic disposal features. Riverpod allows us to manage state efficiently and provides a clear separation between the state and UI components.

- **GoRouter for Navigation**: We use [GoRouter](https://pub.dev/packages/go_router) to handle navigation and routing. GoRouter provides a declarative API for defining routes and supports nested routes and deep linking, making it easier to manage complex navigation scenarios.

### Third-Party Packages

Here is a list of third-party packages used in our project along with the reasons for their inclusion:

 **[Riverpod](https://pub.dev/packages/riverpod)**: 
  - **Reason**: Provides a modern and flexible state management solution with enhanced type safety and modularity. It simplifies state management by eliminating the need for `BuildContext` and automatically handles resource disposal.

**[GoRouter](https://pub.dev/packages/go_router)**: 
  - **Reason**: Simplifies navigation and routing in the app. It supports declarative routing, nested routes, and deep linking, making it a powerful choice for managing complex navigation needs.

**[Isar DB](https://pub.dev/packages/isar)**:
  - **Reason**: Isar DB is chosen for its high performance and ease of use. It is an object-oriented database that offers fast queries, real-time updates, and a simple API for managing complex data structures. Isar DB is used to handle local data storage efficiently with features such as automatic indexing and query optimization.

 **[Build Runner](https://pub.dev/packages/build_runner)**:
  -**Reason**: Build Runner is used for code generation in our project. It helps automate the generation of boilerplate code and supports custom code generation tasks. This tool is essential for managing and maintaining code consistency, especially in projects that use code generation libraries like `json_serializable` or `moor`.

### How to Add/Update Packages

To add or update packages in the project, follow these steps:

1. **Add to `pubspec.yaml`**:
   - Open the `pubspec.yaml` file and add the desired package under dependencies.

2. **Install Packages**:
   - Run `flutter pub get` in the terminal to fetch the new dependencies.

3. **Update Usage**:
   - Import the package into your Dart files and update the code to utilize the new functionality.

