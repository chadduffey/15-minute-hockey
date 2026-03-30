# 15 Minute Hockey

`15 Minute Hockey` is a simple iPhone app for building a daily field hockey habit.

The idea is straightforward: put in 15 minutes a day, log what you practiced, and keep your momentum going.

## What It Does

- Log a daily 15-minute practice session
- Track your streak and weekly consistency
- Record the skills you worked on
- Set a goal and target date
- Customize your profile, photo, and color theme
- Schedule a daily reminder notification

## Built With

- SwiftUI
- XcodeGen
- Local on-device persistence with `UserDefaults`
- Local notifications with `UserNotifications`

## Running The App

1. Install [Xcode](https://developer.apple.com/xcode/)
2. Install [XcodeGen](https://github.com/yonaskolb/XcodeGen)
3. Generate the project:

```sh
xcodegen generate
```

4. Open the project:

```sh
open 15Minutes.xcodeproj
```

5. Build and run on an iPhone simulator or device

## Project Structure

- [15Minutes](/Users/chad/code/15minutes/15Minutes): app source
- [project.yml](/Users/chad/code/15minutes/project.yml): XcodeGen project definition
- [15Minutes.xcodeproj](/Users/chad/code/15minutes/15Minutes.xcodeproj): generated Xcode project

## Notes

This project is currently designed as a lightweight, local-first app. Practice data, profile settings, and reminders are managed on-device.
