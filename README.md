# diary_project

Flutter Diary App
A simple Flutter diary application that allows users to log their daily experiences, rate them, and view previous entries in chronological order.

Features
Add daily diary entries with descriptions and ratings.
View past diary entries in a reverse chronological order.
Delete specific entries.
Entries are stored locally using Hive, a lightweight database.
Setup & Installation
Ensure you have Flutter and Dart set up on your machine. If not, visit Flutter's official documentation to set it up.

Clone the repository:

bash
Copy code
git clone [repository_url]
Navigate to the app's root directory and install the dependencies:

bash
Copy code
flutter pub get
Run the application:

bash
Copy code
flutter run
Usage
Add Entry: Click on the '+' button on the main page to add a new diary entry. You can select a date, write a description, and provide a rating for the day.

View Entries: On the main page, previous entries are listed in reverse chronological order with their descriptions and ratings.

Delete Entry: Next to every diary entry in the list, there's a delete button. Clicking on it will remove that specific entry.

Future Improvements
Implement search functionality to easily find past entries.
Allow users to edit existing entries.
Add theming and allow users to switch between different themes.
Implement cloud backup to store entries remotely.
Contributing
Feel free to fork the repository, make changes, and submit pull requests. For major changes, please open an issue first to discuss what you'd like to change.

License
This project is open-source and available under the MIT License.

