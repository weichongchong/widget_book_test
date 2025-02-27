import 'package:flutter/material.dart';
import 'package:widget_book_test/dcslider/dc_slider_view.dart';
import 'package:widgetbook/widgetbook.dart';

import 'button.dart';

void main() {
  runApp(const HotReload());
}

class HotReload extends StatelessWidget {
  const HotReload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhone13, // 添加 iPhone 13
            Devices.ios.iPhoneSE, // 添加 iPhone SE
            Devices.ios.iPhone13ProMax,
          ],
        ),
        ThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: ThemeData.light()), // 浅色主题
            WidgetbookTheme(name: 'Dark', data: ThemeData.dark()), // 深色主题
            WidgetbookTheme(
              name: 'Custom Blue',
              data: ThemeData(
                primarySwatch: Colors.blue,
                brightness: Brightness.light,
              ),
            ), // 自定义蓝色主题
          ], themeBuilder: (BuildContext context, ThemeData theme, Widget child) {
          return Theme(
            data: theme,
            child: Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor, // 统一背景色
              body: Center(child: child,), // 组件 UI
            ),
          );
        },
        ),
      ],
      directories: [
        buildWidgetbookCategory(),
        buildWidgetbookCategory2(),
      ],
    );
  }
}

WidgetbookCategory buildWidgetbookCategory() {
  return WidgetbookCategory(
    name: '公共组件',
    children: [
      WidgetbookComponent(
        name: '按钮',
        useCases: [
          WidgetbookUseCase.child(
            name: "DCButton.style1",
            child: Center(child: MyElevatedButton(text: "测试按钮1",)),
          ),
          WidgetbookUseCase.child(
            name: "DCButton.style2",
            child: MyElevatedButton(text: "测试按钮2",),
          ),
        ],
      ),
      WidgetbookComponent(
        name: '滑杆',
        useCases: [
          WidgetbookUseCase.child(
            name: "DCSliderView.style1",
            child: DCSliderView.style1((v){
            },false),
          ),
        ],
      ),
    ],
  );
}
WidgetbookCategory buildWidgetbookCategory2() {
  return WidgetbookCategory(
    name: '业务组件',
    children: [
      WidgetbookComponent(
        name: '按钮',
        useCases: [
          WidgetbookUseCase.child(
            name: "DCButton.style1",
            child: MyElevatedButton(text: "测试按钮1",),
          ),
        ],
      ),
      WidgetbookComponent(
        name: '滑杆',
        useCases: [
          WidgetbookUseCase.child(
            name: "DCButton.style3",
            child: MyElevatedButton(text: "测试按钮1",),
          ),
        ],
      ),
    ],
  );
}