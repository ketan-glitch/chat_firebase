import 'package:flutter/material.dart';

import 'custom_image.dart';

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight) : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {Key? key,
      this.title,
      this.actions,
      this.leading,
      this.backButtonColor,
      this.isHome = false,
      this.centerTitle = false,
      this.backgroundColor = Colors.transparent,
      this.fontColor,
      this.bottom})
      : /*preferredSize = _PreferredAppBarSize(toolbarHeight, bottom?.preferredSize.height),*/
        super(key: key);

  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backButtonColor;
  final Color? backgroundColor;
  final Color? fontColor;
  final bool isHome;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  static double preferredHeightFor(BuildContext context, Size preferredSize) {
    if (preferredSize is _PreferredAppBarSize && preferredSize.toolbarHeight == null) {
      return (AppBarTheme.of(context).toolbarHeight ?? kToolbarHeight) + (preferredSize.bottomHeight ?? 0);
    }
    return preferredSize.height;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: centerTitle,
      leading: Navigator.canPop(context)
          ? Builder(builder: (context) {
              if (Navigator.canPop(context)) {
                if (leading != null) {
                  return leading!;
                }
                return BackButton(
                  color: backButtonColor ?? Theme.of(context).primaryColor,
                );
              }
              return const SizedBox.shrink();
            })
          : null,
      title: Builder(builder: (context) {
        if (isHome) {
          return const CustomAssetImage(
            height: 35,
            path: Assets.imagesLogo,
          );
        } else {
          if (title != null) {
            return Text(
              title!,
              style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 18.0, color: fontColor),
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      }),
      actions: actions,
      bottom: bottom,
    );
  }
}
