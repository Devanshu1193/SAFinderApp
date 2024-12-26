# SAFinder iOS Application

## Overview

SAFinder is an iOS application designed to assist students in locating and managing rental properties near their educational institutions. The app provides a comprehensive guide to finding accommodations, including detailed property views, a favorites system, and responsive layouts for both phones and tablets. Custom gestures and smooth animations enhance the user experience.

## Features

- **Accommodation Listings**: Browse a variety of rental properties with detailed descriptions and photos.
- **Favorites System**: Save and manage preferred listings for easy access.
- **Custom Gestures**: Includes press&hold-to-delete, pinch-to-zoom, and double-tap for editing listings.
- **Smooth Animations**: Enhances transitions and interactions throughout the app.
- **Optional Features**: Geolocation for nearby listings, live data integration via APIs, and notifications for updates on saved properties.

## Technologies Used

- **Programming Language**: Swift
- **IDE**: Xcode
- **Frameworks**: UIKit, CoreData, Foundation
- **Architecture**: MVVM (Model-View-ViewModel)
- **API Integration**: JSON API for live data

## Installation

1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/Devanshu1193/SAFinder.git
   ```
2. Navigate to the project directory:
   ```bash
   cd SAFinder
   ```
3. Open the project in Xcode:
   ```bash
   open SAFinder.xcodeproj
   ```
4. Install dependencies if required using Swift Package Manager.
5. Build and run the project on a simulator or a physical device.

## Usage

1. Launch the app and start from the main screen, which introduces the app.
2. Navigate to the listing page via a double-tap gesture on the main screen.
3. Browse accommodation listings and select any to view detailed information.
4. Add listings to your favorites page or edit details like images and rent pricing.
5. Use gestures such as press&hold-to-delete to manage your favorites.

## Screens

- **Main Screen**: Provides an introduction to the app with a double-tap gesture to access the listing page.
- **Listing Page**: Displays all accommodation listings.
- **Detail Page**: Includes images, rent prices, location, and descriptions, along with options to add to favorites.
- **Favorites Page**: Lists all saved accommodations with options to edit or remove them.

## Gestures

- **Swipe-to-Delete**: Remove listings from the favorites page.
- **Pinch-to-Zoom**: Zoom in and out of listing images.
- **Double-Tap**: Edit listing details, such as images and pricing.

## Custom Animations

- **Listing Detail Transition**: Smooth slide or fade when navigating from the listing page to the detail view.
- **Favorite Button Animation**: Heart or star icon scales up briefly when adding/removing a listing from favorites.

## Data Persistence

The app uses **CoreData** to persist:

- Accommodation listings with details like location, rent, and photos.
- User favorites for consistent access across sessions.
- CRUD operations for seamless data management.

## Future Enhancements

- **User Authentication**: Accounts for saving preferences.
- **Advanced Filters**: Search by price range, location, and amenities.
- **Localization**: Support for multiple languages.
- **Community Features**: A forum for users to share experiences.

## Contributions

Contributions are welcome! If you want to contribute:

1. Fork the repository:
   ```bash
   git fork https://github.com/Devanshu1193/SAFinder.git
   ```
2. Create a new branch for your feature or bug fix:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes and push them to your branch:
   ```bash
   git add .
   git commit -m "Description of your changes"
   git push origin feature-name
   ```
4. Create a pull request on GitHub and describe your changes.

## Contact

For any queries or feedback, feel free to reach out:

- **Name**: Devanshu
- **Email**: [devanshusuthar1193@gmail.com]
- **LinkedIn**: [Your LinkedIn Profile](https://in.linkedin.com/in/devanshu-suthar-7b0190243)
- **Website**: [https://devanshusuthar.com/]

---

Thank you for using SAFinder! Together, we simplify finding accommodations for students.

