## Date Tab Pager

Date-driven TabBar and TabView with linked navigation and infinite scroll.

This package replaces [`weekly_tab_pager`](https://pub.dev/packages/weekly_tab_pager), which is no longer maintained.

The package is used in the real-world application [Student Planner](https://play.google.com/store/apps/details?id=com.indentix.studentplanner).


Feel free to use this library if you find it useful!

<table>
  <tr>
    <td align="center">
      <img src="https://raw.githubusercontent.com/azalessky/weekly_tab_pager/main/daily-demo.gif" height="400"/><br/>
      <sub>Daily View</sub>
    </td>
    <td align="center">
      <img src="https://raw.githubusercontent.com/azalessky/weekly_tab_pager/main/weekly-demo.gif" height="400"/><br/>
      <sub>Weekly View</sub>
    </td>
  </tr>
</table>

## Features

 - Synchronized TabBar and TabView with a single controller
 - Smooth animated navigation between tabs and pages
 - Infinite scroll in both directions (past & future)
 - Flexible tab modes: display daily or weekly tabs
 - Callbacks for tab/page changes for full control

## Installation

Add the following line to `pubspec.yaml`:

```yaml
dependencies:
  date_tab_pager: ^0.0.5
```
Import the package in your code:
```dart
import 'package:date_tab_pager/date_tab_pager.dart';
```

## Usage

### Step 1: Controller

PositionController manages the current date and settings such as weekdays and maximum visible items.
```dart
final controller = PositionController(
  initialDate: DateTime.now(),
  weekdays: [1, 2, 3, 4, 5, 6],
  maxItems: 100,
);
controller.animateTo(DateTime.now());
```

### Step 2: Synchronization

SyncController provides two-way synchronization between TabBar and TabView, keeping the selected tab and the scroll position in sync for smooth interactions.
```dart
final sync = SyncController();
```

### Step 3: Tab Bar

DailyTabBar builds daily tabs.
```dart
DailyTabBar(
  controller: controller,
  sync: sync,
  height: 48.0,
  tabBuilder: (context, date) => Text('${date.day}'),
)
```

WeeklyTabBar builds weekly tabs.
```dart
WeeklyTabBar(
  controller: controller,
  sync: sync,
  height: 48.0,
  tabBuilder: (context, date) => Text('Week ${weekNumber(date)}'),
)
```

### Step 4: Tab View
DailyTabView builds pages for each day.
```dart
DailyTabView(
  controller: controller,
  sync: sync,
  pageBuilder: (context, date) => Center(child: Text('${date.day}')),
)
```

WeeklyTabView builds pages for each week.
```dart
WeeklyTabView(
  controller: controller,
  sync: sync,
  pageBuilder: (context, date) => Center(child: Text('Week ${weekNumber(date)}')),
)
```

### Step 5: Integration

Combine TabBar, TabView, PositionController, and SyncController for fully synchronized tabs and pages.

```dart
Column(
  children: [
    DailyTabBar(
      controller: controller,
      sync: sync, tabBuilder:
      _buildTab,
    ),
    Expanded(
      child: DailyTabView(
        controller: controller,
        sync: sync, 
        pageBuilder: _buildPage,
      ),
    ),
  ],
)
```

### Step 6: Callbacks

You can listen to navigation events:
```dart
onTabScrolled: (date) => print('Tab scrolled to $date'),
onTabChanged: (date) => print('Tab changed to $date'),
onPageChanged: (date) => print('Page changed to $date'),
```

Make sure to check out [example](https://github.com/azalessky/date_tab_pager/tree/main/example) for more details.