/*
A material widget that's displayed at the bottom of an app for selecting among a small number of views, typically between three and five.

The bottom navigation bar consists of multiple items in the form of text labels, icons, or both, laid out on top of a piece of material. It provides quick navigation between the top-level views of an app. For larger screens, side navigation may be a better fit.

A bottom navigation bar is usually used in conjunction with a Scaffold, where it is provided as the Scaffold.bottomNavigationBar argument.

The bottom navigation bar's type changes how its items are displayed. If not specified, then it's automatically set to BottomNavigationBarType.fixed when there are less than four items, and BottomNavigationBarType.shifting otherwise.

BottomNavigationBarType.fixed, the default when there are less than four items. The selected item is rendered with the selectedItemColor if it's non-null, otherwise the theme's ThemeData.primaryColor is used. If backgroundColor is null, The navigation bar's background color defaults to the Material background color, ThemeData.canvasColor (essentially opaque white).
BottomNavigationBarType.shifting, the default when there are four or more items. If selectedItemColor is null, all items are rendered in white. The navigation bar's background color is the same as the BottomNavigationBarItem.backgroundColor of the selected item. In this case it's assumed that each item will have a different background color and that background color will contrast well with white.
*/