import 'package:flutter/material.dart';
import 'package:widget_demo/wrap_widget.dart';

// paint_effect
import 'package:widget_demo/paint_effect/BackdropFilter.dart';
import 'package:widget_demo/paint_effect/ClipXXX.dart';
import 'package:widget_demo/paint_effect/CustomPaint.dart';
import 'package:widget_demo/paint_effect/DecoratedBox.dart';
import 'package:widget_demo/paint_effect/FractionalTranslation.dart';
import 'package:widget_demo/paint_effect/Opacity.dart';
import 'package:widget_demo/paint_effect/RotatedBox.dart';
import 'package:widget_demo/paint_effect/Transform.dart';

// layout
import 'package:widget_demo/layout/Align.dart';
import 'package:widget_demo/layout/AspectRatio.dart';
import 'package:widget_demo/layout/Baseline.dart';
import 'package:widget_demo/layout/Center.dart';
import 'package:widget_demo/layout/ConstrainedBox.dart';
import 'package:widget_demo/layout/Container.dart';
import 'package:widget_demo/layout/CustomSingleChildLayout.dart';
import 'package:widget_demo/layout/FlexClass.dart';
import 'package:widget_demo/layout/FittedBox.dart';
import 'package:widget_demo/layout/FractionallySizedBox.dart';
import 'package:widget_demo/layout/IntrinsicHW.dart';
import 'package:widget_demo/layout/LimitedBox.dart';
import 'package:widget_demo/layout/Offstage.dart';
import 'package:widget_demo/layout/OverflowBox.dart';
import 'package:widget_demo/layout/Padding.dart';
import 'package:widget_demo/layout/SizedBox.dart';
import 'package:widget_demo/layout/SizedOverflowBox.dart';
import 'package:widget_demo/layout/CustomMultiChildLayout.dart';
import 'package:widget_demo/layout/Flow.dart';
import 'package:widget_demo/layout/GridView.dart';
import 'package:widget_demo/layout/IndexedStack.dart';
import 'package:widget_demo/layout/LayoutBuilder.dart';
import 'package:widget_demo/layout/ListBody.dart';
import 'package:widget_demo/layout/ListView.dart';
import 'package:widget_demo/layout/Stack.dart';
import 'package:widget_demo/layout/Table.dart';
import 'package:widget_demo/layout/Wrap.dart';

// scrolling
import 'package:widget_demo/scrolling/CustomScrollView.dart';
import 'package:widget_demo/scrolling/NestedScrollView.dart';
import 'package:widget_demo/scrolling/NotificationListener.dart';
import 'package:widget_demo/scrolling/PageView.dart';
import 'package:widget_demo/scrolling/RefreshIndicator.dart';
import 'package:widget_demo/scrolling/ScrollConfiguration.dart';
import 'package:widget_demo/scrolling/Scrollable.dart';
import 'package:widget_demo/scrolling/Scrollbar.dart';
import 'package:widget_demo/scrolling/SingleChildScrollView.dart';

// material buttons
import 'package:widget_demo/material/buttons/ButtonBar.dart';
import 'package:widget_demo/material/buttons/DropdownButton.dart';
import 'package:widget_demo/material/buttons/XXXButton.dart';
import 'package:widget_demo/material/buttons/FloatingActionButton.dart';
import 'package:widget_demo/material/buttons/PopupMenuButton.dart';

// material input&selections
import 'package:widget_demo/material/input_selections/InputSelections.dart';

// material dialogs&alerts&panels
import 'package:widget_demo/material/dialogs_alerts_panels/DialogAlertsPanels.dart';

// material information&displays
import 'package:widget_demo/material/information_displays/InformationDisplays.dart';

// material layout
import 'package:widget_demo/material/layout/Layout.dart';

// animation&motion
import 'package:widget_demo/animation_motion/transition.dart';
import 'package:widget_demo/animation_motion/animate_widget.dart';

class WidgetFactory {
  static WidgetFactory _factory;

  Map<String, List<WrapWidget>> _widgets;

  WidgetFactory._internal() {
    _widgets = Map<String, List<WrapWidget>>();

    // paint_effect
    _addGroup(<WrapWidget>[
      BackdropFilterWidget(),
      ClipWidget(),
      CustomPaintWidget(),
      DecoratedBoxWidget(),
      FractionalTranslationWidget(),
      OpacityWidget(),
      RotatedBoxWidget(),
      TransformWidget(),
    ]);

    // layout
    _addGroup(<WrapWidget>[
      AlignWidget(),
      AspectRatioWidget(),
      BaselineWidget(),
      CenterWidget(),
      ConstrainedBoxWidget(),
      ContainerWidget(),
      CustomSingleChildLayoutWidget(),
      FlexClassWidget(),
      FittedBoxWidget(),
      FractionallySizedBoxWidget(),
      IntrinsicWidget(),
      LimitedBoxWidget(),
      OffstageWidget(),
      OverflowBoxWidget(),
      PaddingWidget(),
      SizedBoxWidget(),
      SizedOverflowBoxWidget(),
      CustomMultiChildLayoutWidget(),
      FlowWidget(),
      GridViewWidget(),
      IndexedStackWidget(),
      LayoutBuilderWidget(),
      ListBodyWidget(),
      ListViewWidget(),
      StackWidget(),
      TableWidget(),
      WrapTheWidget(),
    ]);

    // scrolling
    _addGroup(<WrapWidget>[
      CustomScrollViewWidget(),
      NestedScrollViewWidget(),
      NotificationListenerWidget(),
      PageViewWidget(),
      RefreshIndicatorWidget(),
      ScrollConfigurationWidget(),
      ScrollableWidget(),
      ScrollbarWidget(),
      SingleChildScrollViewWidget()
    ]);

    // material buttons
    _addGroup(<WrapWidget>[
      ButtonBarWidget(),
      DropdownButtonWidget(),
      XXXButtonWidget(),
      FloatingActionButtonWidget(),
      PopupMenuButtonWidget()
    ]);

    // material input&selections
    _addGroup(<WrapWidget>[InputSelectionsWidget()]);

    // material dialogs&alerts&panels
    _addGroup(<WrapWidget>[DialogAlertsPanelsWidget()]);

    // material information&displays
    _addGroup(<WrapWidget>[InformationDisplaysWidget()]);

    // material layout
    _addGroup(<WrapWidget>[LayoutWidget()]);

    // animation&motion
    _addGroup(<WrapWidget>[TransitionWidget(), AnimatedTheWidget()]);
  }

  void _addGroup(List<WrapWidget> widgets) {
    widgets.forEach((widget) {
      var group = widget.group;
      if (!_widgets.containsKey(group)) {
        _widgets[group] = widgets;
      }
    });
  }

  factory WidgetFactory() {
    if (_factory == null) {
      _factory = WidgetFactory._internal();
    }
    return _factory;
  }

  List<WrapWidget> getWidgets(String group) => _widgets[group];

  List<String> geGroups() => _widgets.keys.toList();
}
