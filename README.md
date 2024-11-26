# Recipe App

This project is a recipe app developed as a take-home project.

## Steps to Run the App

1. **Clone the repository** to your local machine.
2. **Open the project in Xcode** (version 14.0 or later).
3. **Set the target device** to either a simulator or a physical iOS device (iOS 16 or later required).
4. **Run the app** by pressing `Cmd + R` or clicking the "Run" button in Xcode.
5. The app will fetch and display a list of recipes and cache images as they load.

## Focus Areas

I focused on setting up a clear architecture that separates business logic from the UI, making each part easy to test and work with. Instead of using singletons, 
I applied a protocol-based approach to keep services like CacheService and the network service independent, so they can be easily tested on their own. 
I also used Swift’s concurrency tools, like Actor isolation in CacheService, to avoid race conditions and ensure safe, concurrent operations.

## Trade-offs and Decisions

- **In-Memory Caching**: I chose an in-memory caching strategy for simplicity and performance.
- **Simplified UI**: Limited the app to a single screen, which allowed me to focus on optimizing network handling and error feedback.

## Weakest Part of the Project

The weakest part may be:
- **Testing Coverage**: Due to time constraints, I focused primarily on unit tests for core functions in view models and did not have time to add test coverage for service classes.
- **Error State Simulations**: Testing for complex error scenarios (e.g., network interruptions, partial data loads) was limited.
- **Offline Support**: Currently, the app has limited offline support with in-memory caching only. Implementing persistent caching would allow users to access previously loaded data without an active internet connection

## External Code and Dependencies

No external libraries were used. The project is built entirely with **SwiftUI**, while caching is handled with a custom `CacheService` actor.

## Additional Information

- **Decoupling and Testing**: The protocol-oriented approach enables easy testing and makes each service (e.g., caching, network) modular and replaceable.
- **Async Image Loading**: I implemented image loading in a separate view model to avoid blocking the UI and ensure a responsive user experience.
