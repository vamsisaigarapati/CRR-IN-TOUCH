import './custom_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class CollapsingNavigationDrawer extends StatefulWidget {
  @override
  CollapsingNavigationDrawerState createState() {
    return new CollapsingNavigationDrawerState();
  }
}

class CollapsingNavigationDrawerState extends State<CollapsingNavigationDrawer>
    with SingleTickerProviderStateMixin {
  double maxWidth = 210;
  double minWidth = 70;
  bool isCollapsed = false;
  AnimationController _animationController;
  Animation<double> widthAnimation;
  int currentSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth)
        .animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, widget) => getWidget(context, widget),
    );
  }

  Widget getWidget(context, widget) {
    return Material(
      elevation: 80.0,
      child: Container(
        width: widthAnimation.value,
        color: drawerBackgroundColor,
        child: Column(
          children: <Widget>[
            InkWell(
              child: Container(
                  height: (MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top) *
                      0.15,
                  child: CollapsingListTile(
                    title: 'Profile',
                    icon: Icons.person,
                    animationController: _animationController,
                  )),
              onTap: () => Navigator.of(context).pushNamed('profile'),
            ),
            Divider(
              color: Colors.grey,
              height: 40.0,
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, counter) {
                  return Divider(height: 12.0);
                },
                itemBuilder: (context, counter) {
                  return CollapsingListTile(
                    onTap: () {
                      if (Provider.of<Auth>(context).isTeacher) {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pushNamed(navigationItems[counter].staffRoute);
                      } else {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pushNamed(navigationItems[counter].studentRoute);
                      }
                      setState(() {
                        currentSelectedIndex = counter;
                      });
                    },
                    isSelected: currentSelectedIndex == counter,
                    title: Provider.of<Auth>(context).isTeacher
                        ? navigationItems[counter].staffTitile
                        : navigationItems[counter].studentTitle,
                    icon: navigationItems[counter].icon,
                    animationController: _animationController,
                  );
                },
                itemCount: navigationItems.length,
              ),
            ),
           
            InkWell(
              onTap: () {
                setState(() {
                  isCollapsed = !isCollapsed;
                  isCollapsed
                      ? _animationController.forward()
                      : _animationController.reverse();
                });
              },
              child: AnimatedIcon(
                icon: AnimatedIcons.close_menu,
                progress: _animationController,
                color: selectedColor,
                size: 50.0,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            CollapsingListTile(
              title: "Logout",
              icon: Icons.exit_to_app,
              animationController: _animationController,
              onTap: () {
                Provider.of<Auth>(context, listen: false).logout().then((_) {
                  Navigator.of(context).pushReplacementNamed('/');
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
