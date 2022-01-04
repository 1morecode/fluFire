// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class CustomListTile extends StatefulWidget {
//   final Widget trailing;
//   final String title;
//   final TextStyle titleStyle;
//   final String subTitle;
//   final TextStyle subTitleStyle;
//   final Widget leading;
//   final Color borderColor;
//   final VoidCallback onPressed;
//   final double size;
//   final double contentSpacing;
//   final EdgeInsets padding;
//   final Color tileColor;
//
//   const CustomListTile(
//       {key,
//       this.trailing,
//       this.title,
//       this.titleStyle,
//       this.subTitle,
//       this.subTitleStyle,
//       this.leading,
//       this.borderColor,
//       this.onPressed,
//       this.size,
//       this.contentSpacing,
//       this.padding,
//       this.tileColor})
//       : super(key: key);
//
//   @override
//   _CustomListTileState createState() => _CustomListTileState();
// }
//
// class _CustomListTileState extends State<CustomListTile> {
//   @override
//   Widget build(BuildContext context) {
//     ColorScheme colorScheme = Theme.of(context).colorScheme;
//     return widget.onPressed != null
//         ? CupertinoButton(
//             minSize: 35,
//             borderRadius: BorderRadius.circular(0),
//             padding: EdgeInsets.all(0),
//             onPressed: widget.onPressed,
//             child: new Container(
//               margin: EdgeInsets.only(bottom: 1),
//               constraints:
//                   BoxConstraints(minHeight: 35, minWidth: double.infinity),
//               padding: widget.padding != null
//                   ? widget.padding
//                   : EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//               alignment: Alignment.centerLeft,
//               decoration: BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(
//                         color: widget.borderColor != null
//                             ? widget.borderColor
//                             : colorScheme.secondaryVariant.withOpacity(0.3),
//                         width: 1),
//                   ),
//                   color: widget.tileColor != null
//                       ? widget.tileColor
//                       : colorScheme.onPrimary),
//               width: widget.size,
//               child: new Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   widget.leading != null ? widget.leading : new Container(),
//                   SizedBox(
//                     width: widget.contentSpacing != null
//                         ? widget.contentSpacing
//                         : 10.0,
//                   ),
//                   new Expanded(
//                     child: new Column(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         widget.title != null
//                             ? new Text(
//                                 "${widget.title}",
//                                 style: widget.titleStyle != null
//                                     ? widget.titleStyle
//                                     : TextStyle(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onSecondary,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w400),
//                               )
//                             : new Container(),
//                         widget.subTitle != null
//                             ? new Text(
//                                 "${widget.subTitle}",
//                                 style: widget.subTitleStyle != null
//                                     ? widget.subTitleStyle
//                                     : TextStyle(
//                                         color: colorScheme.secondaryVariant,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600),
//                               )
//                             : new Container(),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     width: widget.contentSpacing != null
//                         ? widget.contentSpacing
//                         : 10.0,
//                   ),
//                   widget.trailing != null ? widget.trailing : new Container(),
//                 ],
//               ),
//             ),
//           )
//         : new Container(
//             margin: EdgeInsets.only(bottom: 1),
//             constraints:
//                 BoxConstraints(minHeight: 35, minWidth: double.infinity),
//             padding: widget.padding != null
//                 ? widget.padding
//                 : EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//             alignment: Alignment.centerLeft,
//             decoration: BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(
//                       color: widget.borderColor != null
//                           ? widget.borderColor
//                           : colorScheme.secondaryVariant.withOpacity(0.3),
//                       width: 1),
//                 ),
//                 color: widget.tileColor != null
//                     ? widget.tileColor
//                     : colorScheme.onPrimary),
//             width: widget.size,
//             child: new Row(
//               children: [
//                 widget.leading,
//                 SizedBox(
//                   width: widget.contentSpacing != null
//                       ? widget.contentSpacing
//                       : 10.0,
//                 ),
//                 new Expanded(
//                   child: new Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       widget.title != null
//                           ? new Text(
//                               "${widget.title}",
//                               style: widget.titleStyle != null
//                                   ? widget.titleStyle
//                                   : TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSecondary,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w400),
//                             )
//                           : new Container(),
//                       widget.subTitle != null
//                           ? new Text(
//                               "${widget.subTitle}",
//                               style: widget.subTitleStyle != null
//                                   ? widget.subTitleStyle
//                                   : TextStyle(
//                                       color: colorScheme.secondaryVariant,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600),
//                             )
//                           : new Container(),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   width: widget.contentSpacing != null
//                       ? widget.contentSpacing
//                       : 10.0,
//                 ),
//                 widget.trailing != null ? widget.trailing : new Container(),
//               ],
//             ),
//           );
//   }
// }
