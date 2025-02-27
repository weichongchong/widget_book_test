import 'dart:core';
import 'dart:ui' as ui;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'dc_slider_config.dart';

class DCSliderDrawUtils {
  DCSliderConfig config;

  DCSliderDrawUtils(this.config);

  void checkOutOf(Size size) {
    // debugPrint("------百分比config.distance.  ${config.distance}");
    if (config.distance >= size.width) {
      config.distance = size.width;
      // debugPrint("-----end百分比config.distance.  ${config.distance}");
    }
    if (config.distance < 1) {
      config.distance = 0;
    }
  }

  ///绘制拖动节点
  void drawDragNode(Offset center, Canvas canvas, Paint paint) {
    paint.color = config.selectColor;
    canvas.drawCircle(center, config.selectCircleRadius, paint);
    paint.color = config.bgColor;
    canvas.drawCircle(center, config.selectCircleRadius - 2, paint);
  }

  //绘制气泡-文字信息
  void drawBubble(
      Offset center, Canvas canvas, Paint paint, double w, double h) {
    paint.color = config.bubbleColor;
    double bubbleR = 5;
    // double bubbleH = h;

    // double diffY = (bubbleH - bubbleR * 2) / 2;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: center,
              width: w,
              height: h,
            ),
            Radius.circular(bubbleR)),
        paint);
    // 绘制箭头
    // canvas.drawPath(
    //     Path()
    //       ..addPolygon([
    //         Offset(center.dx - 7, center.dy + diffY),
    //         Offset(center.dx + 7, center.dy + diffY),
    //         Offset(center.dx, center.dy + bubbleH - 4)
    //       ], true),
    //     paint..style = PaintingStyle.fill);
  }

  // 检测边界不越界
  void checkImageOutOf(Size size, ui.Image? imageNode) {
    if (config.distance > size.width) {
      config.distance = size.width;
    }
    if (config.distance < 0) {
      config.distance = 0;
    }
  }

  // 检测边界不越界
  void checkNodeOutOf(Size size) {
    if (config.distance > size.width) {
      config.distance = size.width;
    }
    if (config.distance < 1) {
      config.distance = 0;
    }
  }

  /// 百分比
  int percentage(Size size) {
    int percentage = (config.distance / size.width * 100.0).toInt();
    if (percentage > 100) {
      percentage = 100;
    }
    if (percentage < 0) {
      percentage = 0;
    }
    return percentage;
  }

  ///百分比获取距离位置
  double dxByPercent(Size size, double percent) {
    return (percent * size.width).toDouble();
  }

  /// 绘制背景
  void drawBg(Size size, Paint paint, Canvas canvas) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.color = Colors.transparent;
    canvas.drawRect(rect, paint);
  }

  /// 绘制线
  void drawLine(double startX, double startY, double endX, double endY,
      Paint paint, Canvas canvas) {
    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
  }

  ///绘制多空降档标示
  void drawLongShorLeverageTag(
      double dy, Size size, Paint paint, Canvas canvas) {
    if (config.leverNode == null) return;
    LeverNodeInfo leverNode = config.leverNode!;
    if (leverNode.longPercent != null) {
      double dx = dxByPercent(size, leverNode.longPercent!);
      if (leverNode.longColor != null) {
        paint.color = leverNode.longColor!;
        drawNode(canvas, dx, dy, paint);
      }
      if (config.distance > dx) {
        paint.color = leverNode.lineColor!;
        canvas.drawLine(
            Offset(dx + 2.5, dy), Offset(config.distance, dy), paint);
      }
    }
    if (leverNode.shortPercent != null) {
      double dx = dxByPercent(size, leverNode.shortPercent!);
      if (leverNode.shortColor != null) {
        paint.color = leverNode.shortColor!;
        drawNode(canvas, dx, dy, paint);
      }
      if (config.distance > dx) {
        paint.color = leverNode.lineColor!;
        canvas.drawLine(
            Offset(dx + 2.5, dy), Offset(config.distance, dy), paint);
      }
    }
  }

  ///绘制线和节点
  void drawFormLeft(double sy, Size size, Paint paint, Canvas canvas) {
    ///选中的线
    paint.color = config.selectColor;
    canvas.drawLine(Offset(0, sy), Offset(config.distance, sy), paint);

    ///绘制多空梯度标识
    drawLongShorLeverageTag(sy, size, paint, canvas);
    int i = 0;
    //第一个点位置
    double cw = (size.width) / (config.count - 1);
    while (i < config.count) {
      double dx, dy = sy;
      if (i == 0) {
        //起始位置
        dx = 0;
      } else if (i == config.count - 1) {
        //最后一个位置
        dx = size.width;
      } else {
        dx = cw * i;
//        debugPrint("tradePaint  i: $i  dx: $dx  ");
      }
      if (config.distance > (dx - config.circleRadius)) {
        //绘制选中区域
        paint.color = config.selectColor;
        drawNode(canvas, dx, dy, paint);
      } else {
        paint.color = config.normalColor;
        drawNode(canvas, dx, dy, paint);
      }
      i++;
    }
  }

  //绘制节点
  void drawNode(ui.Canvas canvas, double dx, double dy, ui.Paint paint) {
    // canvas.drawRRect(
    //     RRect.fromRectAndRadius(
    //         Rect.fromCenter(center: Offset(dx, dy), width: 5.dp, height: 9.dp),
    //         const Radius.circular(1)),
    //     paint);

    Color tempColor = paint.color;
    paint.color = config.bgColor;
    canvas.drawCircle(Offset(dx, dy), 6, paint);
    paint.color = tempColor;
    canvas.drawCircle(Offset(dx, dy), 4, paint);
  }

  ///绘制节点,以中心点计算
  void drawFromCenter(double sy, Size size, Paint paint, Canvas canvas) {
    int i = 0;
    //第一个点位置
    double cw = (size.width) / (config.count - 1);
    //中心位置
    double centerX = size.width / 2;
    while (i < config.count) {
      double dx, dy = sy;
      if (i == 0) {
        //起始位置
        dx = 0;
      } else if (i == config.count - 1) {
        //最后一个位置
        dx = size.width;
      } else {
        dx = cw * i;
//        debugPrint("tradePaint  i: $i  dx: $dx  ");
      }
      //左边，
      bool centerLeft = config.distance <= centerX;

      double radius = (10 / 2);
      if (centerLeft) {
        ///选中的线
        paint.color = config.centerLeftNodeColor;
        canvas.drawLine(
            Offset(centerX - radius, sy), Offset(config.distance, sy), paint);
        if (dx >= config.distance && dx <= centerX) {
          if (i == (config.count / 2).floorToDouble()) {
            paint.color = config.centerNodeColor;
            canvas.drawCircle(Offset(dx, dy), radius, paint);
          } else {
            paint.color = config.centerLeftNodeColor;
            drawNode(canvas, dx, dy, paint);
          }
        } else {
          paint.color = config.normalColor;
          drawNode(canvas, dx, dy, paint);
        }
      } else {
        ///选中的线
        paint.color = config.centerRightNodeColor;
        canvas.drawLine(
            Offset(centerX + radius, sy), Offset(config.distance, sy), paint);
        if (dx <= config.distance && dx >= centerX) {
          if (i == (config.count / 2).floorToDouble()) {
            paint.color = config.centerNodeColor;
            canvas.drawCircle(Offset(dx, dy), radius, paint);
          } else {
            paint.color = config.centerRightNodeColor;
            drawNode(canvas, dx, dy, paint);
          }
        } else {
          paint.color = config.normalColor;
          drawNode(canvas, dx, dy, paint);
        }
      }
      i++;
    }
  }
}
