import 'package:flutter/material.dart';

import 'dc_slider_config.dart';
import 'dc_slider_listener.dart';
import 'dc_slider_painter.dart';

typedef ValueChange<T> = void Function(T value);

// ignore: must_be_immutable
class DCSliderView extends StatefulWidget {
  final DCSliderConfig sliderConfig;

  // 是否是黑色模式
  final bool? isBlack;

  final double? percentTagLong;

  final double? percentTagShort;

  //清理数据
  final bool cleanData;

  final int initValue;

  final ValueChange<int>? valueChange;

  final VoidCallback? onTapDown;

  const DCSliderView(
    this.sliderConfig, {
    super.key,
    this.isBlack,
    this.initValue = 0,
    this.valueChange,
    this.cleanData = false,
    this.onTapDown,
    this.percentTagLong,
    this.percentTagShort,
  });

  static DCSliderView style1(
    ValueChange valueChange,
    bool clearData, {
    bool forDialog = false,
    int initValue = 0,
    double height = 50,
  }) {


    return DCSliderView(
      DCSliderConfig(
          height: height),
      isBlack: false,
      initValue: initValue,
      valueChange: valueChange,
      cleanData: clearData,
    );
  }

  @override
  State<StatefulWidget> createState() => _LxpNodeView();
}

class _LxpNodeView extends State<DCSliderView> implements DCSliderListener {
  //清理数据
  bool? cleanData;

  //移动距离
  double distance = 0;
  int progress = 0;
  int value = 0;
  int initValue = 0;
  bool initFinish = false;
  double? width;

  bool updateWidget = true;

  //图片
  // ui.Image? _image;

  //滑动类型
  NodeScrollType? nodeScrollType;

  @override
  void initState() {
    super.initState();
    cleanData = widget.cleanData;
    value = widget.initValue;
  }

  @override
  void onProgressChange(int value) {
    progress = value;
  }

  @override
  void onValueChange(int value) {
    this.value = value;
  }

  @override
  Widget build(BuildContext context) {
    if (cleanData == true) {
      distance = 0;
      progress = 0;
    }

    return LayoutBuilder(builder: (context, constraintType) {
      width = constraintType.maxWidth - 16;

      DCSliderConfig sliderConfig = widget.sliderConfig.copy();
      sliderConfig.distance = distance;
      sliderConfig.value = value;
      sliderConfig.initFinish = initFinish;
      sliderConfig.mProgress = progress;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: widget.sliderConfig.bgColor,
          width: constraintType.maxWidth,
          padding: const EdgeInsets.only(left: 8, right: 8),
          height: widget.sliderConfig.height,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: DCSliderPainter(
                context: context,
                textColor: widget.sliderConfig.textColor,
                valueChange: widget.valueChange,
                onNodeViewListener: this,
                nodeScrollType: nodeScrollType,
                config: sliderConfig,
              ),
            ),
          ),
        ),
        onTapDown: (event) {
          widget.onTapDown?.call();
          cleanData = false;
          double tapPosition = event.localPosition.dx;
          double sliderWidth = constraintType.maxWidth - 16;
          double tapPercent = tapPosition / sliderWidth;

          // 如果点击位置在25%、50%、75%附近（例如±5%），则自动设置成25%、50%、75%
          if ((tapPercent - 0.25).abs() <= 0.05) {
            distance = sliderWidth * 0.25;
          } else if ((tapPercent - 0.5).abs() <= 0.05) {
            distance = sliderWidth * 0.5;
          } else if ((tapPercent - 0.75).abs() <= 0.05) {
            distance = sliderWidth * 0.75;
          } else {
            distance = tapPosition;
          }
          _setScrollState(
              NodeScrollType.down, distance, event.localPosition.dy, true);
          // widget.valueChange?.call(value);
        },
        onTapCancel: () {
          _setScrollState(NodeScrollType.up, 0, 0, false);
        },
        onHorizontalDragDown: (event) {
          cleanData = false;
          _setScrollState(NodeScrollType.down, event.localPosition.dx,
              event.localPosition.dy, true);
        },
        onHorizontalDragEnd: (DragEndDetails event) {
          _setScrollState(NodeScrollType.up, 0, 0, false);
        },
        onHorizontalDragUpdate: (DragUpdateDetails event) {
          cleanData = false;
          _setScrollState(NodeScrollType.drag, event.localPosition.dx,
              event.localPosition.dy, true);
        },
        onHorizontalDragStart: (event) {
        },
      );
    });
  }

  @override
  void didUpdateWidget(covariant DCSliderView oldWidget) {
    super.didUpdateWidget(oldWidget);
    cleanData = widget.cleanData;
    if (oldWidget.initValue != widget.initValue ||
        widget.sliderConfig.max != oldWidget.sliderConfig.max ||
        widget.sliderConfig.min != oldWidget.sliderConfig.min) {
      updateWidget = true;
    }
  }

  void _setScrollState(NodeScrollType type, double x, double y, bool flag) {
    initFinish = true;
    setState(() {
      if (flag) {
        distance = x;
      }
      nodeScrollType = type;
    });
  }
}
