/*
AppBar class
A material design app bar.

An app bar consists of a toolbar and potentially other widgets, such as a TabBar and a FlexibleSpaceBar. App bars typically expose one or more common actions with IconButtons which are optionally followed by a PopupMenuButton for less common operations (sometimes called the "overflow menu").

App bars are typically used in the Scaffold.appBar property, which places the app bar as a fixed-height widget at the top of the screen. For a scrollable app bar, see SliverAppBar, which embeds an AppBar in a sliver for use in a CustomScrollView.

When not used as Scaffold.appBar, or when wrapped in a Hero, place the app bar in a MediaQuery to take care of the padding around the content of the app bar if needed, as the padding will not be handled by Scaffold.

The AppBar displays the toolbar widgets, leading, title, and actions, above the bottom (if any). The bottom is usually used for a TabBar. If a flexibleSpace widget is specified then it is stacked behind the toolbar and the bottom widget. The following diagram shows where each of these slots appears in the toolbar when the writing language is left-to-right (e.g. English):

The leading widget is in the top left, the actions are in the top right,
the title is between them. The bottom is, naturally, at the bottom, and the
flexibleSpace is behind all of them.

If the leading widget is omitted, but the AppBar is in a Scaffold with a Drawer, then a button will be inserted to open the drawer. Otherwise, if the nearest Navigator has any previous routes, a BackButton is inserted instead. This behavior can be turned off by setting the automaticallyImplyLeading to false. In that case a null leading widget will result in the middle/title widget stretching to start.
* */