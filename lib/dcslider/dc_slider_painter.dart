import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'dc_slider_config.dart';
import 'dc_slider_draw_utils.dart';
import 'dc_slider_listener.dart';
import 'dc_slider_view.dart';

///按下。拖动。离开
enum NodeScrollType { down, drag, up }

class DCSliderPainter extends CustomPainter {
  Paint paintNode = Paint();

  Color? textColor;

  ///滑动条
  ui.Image? imageNode;

  BuildContext? context;

  ///参数配置
  DCSliderConfig config;

  ///绘制方法
  late DCSliderDrawUtils drawUtils;

  ///回调
  DCSliderListener? onNodeViewListener;

  ///类型
  NodeScrollType? nodeScrollType;

  ValueChange<int>? valueChange;

  DCSliderPainter({
    required this.config,
    this.imageNode,
    this.context,
    this.nodeScrollType,
    this.textColor,
    this.valueChange,
    this.onNodeViewListener,
  }) {
    paintNode.color = Colors.red;
    paintNode.style = PaintingStyle.fill;
    paintNode.strokeWidth = config.lineHeight;
    drawUtils = DCSliderDrawUtils(config);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // config.distance = (mProgress * size.width / 100);

    /// 绘制背景
    drawUtils.drawBg(size, paintNode, canvas);

    ///绘制线 线的位置在中心 p1 起始位置的x和y  p2截止位置的x和y
    ///起始位置的 y 为 高度 - 线的高度 - 圆的直径
    /// double sy = size.height - config.lineHeight * 2 - config.circleRadius;
    double sy = size.height / 2;
    paintNode.color = config.normalColor;
    canvas.drawLine(Offset(0, sy), Offset(size.width, sy), paintNode);

    ///检测是否越界
    drawUtils.checkOutOf(size);

    if (config.mode == DCSliderMode.Left2Right) {
      drawUtils.drawFormLeft(sy, size, paintNode, canvas);
    } else {
      drawUtils.drawFromCenter(sy, size, paintNode, canvas);
    }

    ///百分比计算
    int? p = drawUtils.percentage(size);
    int value = _countValue(size.width);

    ///显示的文本
    if (nodeScrollType == NodeScrollType.drag) {
      String temp;
      if (config.type == DCSliderType.Value) {
        temp = "$value";
      } else if (config.type == DCSliderType.ValueWithPercent) {
        temp = "$value%";
      } else {
        temp = '$p%';
      }
      double diffY = 24; //y偏移
      TextPainter textPainter = TextPainter(
          locale: Localizations.localeOf(context!),
          text: TextSpan(
              text: temp, style: TextStyle(fontSize: 14.0, color: textColor)),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center)
        ..layout(
          maxWidth: 90,
          minWidth: 30,
        );

      double padding = 2;
      double maxR = 0;
      if (config.selectCircleRadius > config.circleRadius) {
        maxR = config.selectCircleRadius / 2;
      } else {
        maxR = config.circleRadius / 2;
      }
      double bubbleX = config.distance;

      ///检查右边是否越界
      double outOfSizeR = config.distance +
          (textPainter.width) / 2 +
          padding +
          -maxR -
          size.width;
      if (outOfSizeR > 0) {
        bubbleX = bubbleX - outOfSizeR;
      }

      ///左边是否越界
      double outOfSizeL =
          config.distance - (textPainter.width) / 2 - padding + maxR;
      if (outOfSizeL < 0) {
        bubbleX = bubbleX - outOfSizeL;
      }

      drawUtils.drawBubble(
          Offset(bubbleX, sy - diffY),
          canvas,
          paintNode,
          textPainter.width + padding * 2,
          textPainter.height + padding * 2);

      textPainter.paint(
          canvas,
          Offset(bubbleX - textPainter.width / 2,
              sy - diffY - textPainter.height / 2));
    }


    canvas.restore();

    ///回调
    _scrollStatus(p, size.width, value);
  }

  int _countValue(double width) {
    double temp = config.distance /
            width *
            (config.max - config.min) +
        config.min;
    // debugPrint(
    //     "henry__valueChange$temp--${temp.roundToDouble()}--${temp.roundToDouble().toInt()}====${config.distance}/${width}/${(config.max)}-${config.min} ---");

    return temp.roundToDouble().toInt();
  }

  void _scrollStatus(int progress, double width, int value) {
    if (config.type == DCSliderType.Value ||
        config.type == DCSliderType.ValueWithPercent) {
      if (config.value != value) {
        if (config.initFinish) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            ///四舍五入
            onNodeViewListener?.onValueChange(value);
            valueChange?.call(value);
          });
        }
        config.initFinish = true;
        onNodeViewListener?.onProgressChange(progress);
      }
    } else {
      if (config.mProgress != progress) {
        if (config.initFinish) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            ///四舍五入
            onNodeViewListener?.onValueChange(value);
            valueChange?.call(progress);
          });
        }
        config.initFinish = true;
        onNodeViewListener?.onProgressChange(progress);
      }
    }
  }

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  bool shouldRepaint(DCSliderPainter oldDelegate) {
    // debugPrint("------百分比config.distance.  ${oldDelegate.config.distance.toInt() != config.distance.toInt()}");
    if (oldDelegate.config.distance != config.distance) {
      return true;
    }

    return oldDelegate.config.distance.toInt() != config.distance.toInt() ||
        oldDelegate.textColor != textColor ||
        oldDelegate.config.leverNode != config.leverNode ||
        oldDelegate.nodeScrollType != nodeScrollType;
  }
}
