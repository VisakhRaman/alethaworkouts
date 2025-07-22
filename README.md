# alethaworkouts
This is a simple Flutter application designed to help users track their exercise routines. It demonstrates fundamental mobile app development concepts using Flutter and the BLoC state management pattern.

Capabilities
Exercise List: Fetches a list of exercises from a remote API, displaying their names and durations on the home screen.

Exercise Details: Tapping on an exercise reveals a detailed view, showing the exercise's name, description, duration, and difficulty.

Interactive Timer: Each exercise detail screen includes a "Start" button. Upon clicking, a countdown timer begins for the specified exercise duration.

Completion Tracking: Once the timer concludes, the app notifies the user that the exercise is completed and locally marks that specific exercise as done on the home screen.

Progress Tracking (Optional): The home screen includes a basic tracker to indicate if an exercise has been completed on consecutive days.

Technologies Used
Flutter & Dart: For cross-platform mobile app development.

BLoC: A powerful state management solution for predictable and testable application states.

http package: For making network requests to retrieve exercise data from the API.

shared_preferences: For lightweight local data storage, used to persist completed exercise statuses and track continuous exercise days.

circular_countdown_timer: A Flutter package for displaying a visual countdown timer.

API Endpoint
The app retrieves exercise data from the following mock API endpoint:
GET https://68252ec20f0188d7e72c394f.mockapi.io/dev/workouts