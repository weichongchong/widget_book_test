import 'package:flutter/material.dart';

enum DCSliderType {
  Percent, //显示百分比
  Value, //显示百分比转换的数据
  ValueWithPercent, //显示百分比转换的数据,后面带上百分号
}

enum DCSliderMode {
  Left2Right, //左向右
  Center, //中间向两遍
}

class DCSliderConfig {
  DCSliderType type = DCSliderType.Percent;
  DCSliderMode mode = DCSliderMode.Left2Right;

  //线高度
  double lineHeight;

  double height = 100;

  Color circleColor;

  Color bgColor;

  Color bubbleColor;

  //圆半径
  double circleRadius;

  double selectCircleRadius;

  //绘制多少个点
  int count;

  //字体颜色
  Color? textColor;

  //未选中的颜色
  Color normalColor;

  //选中的颜色
  Color selectColor;

  //中间节点左边的颜色
  Color centerLeftNodeColor;

  //中间节点右边的颜色
  Color centerRightNodeColor;

  //中间节点颜色
  Color centerNodeColor;

  //选中位置的距离
  double distance;

  bool showViewPoP = true;

  int max;

  int min = 0;

  bool initFinish = false;

  int mProgress = 0;

  int value = 0;
  LeverNodeInfo? leverNode;

  DCSliderConfig({
    this.height = 130,
    this.count = 5,
    this.lineHeight = 2,
    this.circleRadius = 6,
    this.selectCircleRadius = 6,
    this.initFinish = false,
    this.min = 0,
    this.max = 100,
    this.mProgress = 0,
    this.value = 0,
    this.distance = 0,
    this.bgColor = Colors.transparent,
    this.textColor,
    this.normalColor = Colors.greenAccent,
    this.selectColor = Colors.blue,
    this.bubbleColor = Colors.blue,
    this.circleColor = Colors.blue,
    this.centerLeftNodeColor = Colors.blue,
    this.centerRightNodeColor = Colors.blue,
    this.centerNodeColor = Colors.blue,
    this.showViewPoP = true,
    this.type = DCSliderType.Percent,
    this.mode = DCSliderMode.Left2Right,
    this.leverNode,
  });

  DCSliderConfig copy() {
    return DCSliderConfig(
        height: height,
        count: count,
        lineHeight: lineHeight,
        circleRadius: circleRadius,
        selectCircleRadius: selectCircleRadius,
        initFinish: initFinish,
        min: min,
        max: max,
        mProgress: mProgress,
        value: value,
        distance: distance,
        bgColor: bgColor,
        textColor: textColor,
        normalColor: normalColor,
        selectColor: selectColor,
        bubbleColor: bubbleColor,
        circleColor: circleColor,
        centerLeftNodeColor: centerLeftNodeColor,
        centerNodeColor: centerNodeColor,
        centerRightNodeColor: centerRightNodeColor,
        showViewPoP: showViewPoP,
        type: type,
        mode: mode,
        leverNode: leverNode);
  }
}

class LeverNodeInfo {
  ///多仓标示
  double? longPercent;

  Color? longColor;

  //空仓标示
  double? shortPercent;

  Color? shortColor;

  Color? lineColor;

  LeverNodeInfo(this.longPercent, this.longColor, this.shortPercent,
      this.shortColor, this.lineColor);
}
