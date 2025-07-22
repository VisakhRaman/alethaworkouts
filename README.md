# alethaworkouts
This is a simple Flutter application designed to help users track their exercise routines. It demonstrates fundamental mobile app development concepts using Flutter and the BLoC state management pattern.

**Capabilities**
Exercise List: Fetches a list of exercises from a remote API, displaying their names and durations on the home screen.

Exercise Details: Tapping on an exercise reveals a detailed view, showing the exercise's name, description, duration, and difficulty.

Interactive Timer: Each exercise detail screen includes a "Start" button. Upon clicking, a countdown timer begins for the specified exercise duration.

Completion Tracking: Once the timer concludes, the app notifies the user that the exercise is completed and locally marks that specific exercise as done on the home screen.

Progress Tracking (Optional): The home screen includes a basic tracker to indicate if an exercise has been completed on consecutive days.

**Technologies Used**
Flutter & Dart: For cross-platform mobile app development.

BLoC: A powerful state management solution for predictable and testable application states.

http package: For making network requests to retrieve exercise data from the API.

shared_preferences: For lightweight local data storage, used to persist completed exercise statuses and track continuous exercise days.

circular_countdown_timer: A Flutter package for displaying a visual countdown timer.

**AI Tools Used** 
Google Gemini (2.5 Flash) used for Local Storage error fixing, Syntax errors while development  

**API Endpoint**
The app retrieves exercise data from the following mock API endpoint:
GET https://68252ec20f0188d7e72c394f.mockapi.io/dev/workouts


![Screenshot_2025-07-22-19-52-01-80_6483b4ce367980c316b2161fc2d0fc46](https://github.com/user-attachments/assets/cbded964-a603-4247-bbbb-7b8484bd7f49)
![Screenshot_2025-07-22-19-51-41-74_6483b4ce367980c316b2161fc2d0fc46](https://github.com/user-attachments/assets/c9f65090-0d96-448e-b659-0ff070147216)
![Screenshot_2025-07-22-19-51-36-21_6483b4ce367980c316b2161fc2d0fc46](https://github.com/user-attachments/assets/5259cbe3-c37c-43c6-9fc1-72a797b19883)
![Screenshot_2025-07-22-19-51-21-36_6483b4ce367980c316b2161fc2d0fc46](https://github.com/user-attachments/assets/7bbc17c7-feda-43d9-9dcd-527b355db1f4)
![Screenshot_2025-07-22-19-50-58-41_6483b4ce367980c316b2161fc2d0fc46](https://github.com/user-attachments/assets/ca5e2dae-9b2e-4f3c-a959-04e7978f721a)
