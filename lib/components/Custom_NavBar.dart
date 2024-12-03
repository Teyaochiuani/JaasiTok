import 'package:floein_social_app/Screens/DisCover/DiscoverScreen.dart';
import 'package:floein_social_app/Screens/Home/HomeScreen.dart';
import 'package:floein_social_app/Screens/Inbox/InboxScreen.dart';
import 'package:floein_social_app/Screens/profile/ProfileScreen.dart';
import 'package:floein_social_app/components/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    Route? route = ModalRoute.of(context);
    return Container(
      color: Colors.transparent,
      height: 140,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 5, 30, 30),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: Offset(0, 10),
                ),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón Home
                    GestureDetector(
                      onTap: () {
                        if (!(route!.settings.name == "/home"))
                          Navigator.pushNamed(context, HomeScreen.routeName);
                      },
                      child: Container(
                        decoration: MenuState.home == selectedMenu
                            ? BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 8,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              )
                            : null,
                        child: Column(
                          children: [
                            Container(
                              height: 45,
                              width: 60,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(18, 18, 18, 0),
                                child: SvgPicture.network(
                                  MenuState.home == selectedMenu
                                      ? "https://res.cloudinary.com/dnwmz8ss2/image/upload/v1733266857/home_owwjjr.svg"
                                      : "https://res.cloudinary.com/dnwmz8ss2/image/upload/v1733266857/home-outline_mvatpb.svg",
                                  color: MenuState.home == selectedMenu
                                      ? Color(0xff651CE5)
                                      : null,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Container(
                                child: Text(
                                  "Home",
                                  style: TextStyle(
                                      color: MenuState.home == selectedMenu
                                          ? Color(0xff651CE5)
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Botón Discover
                    GestureDetector(
                      onTap: () {
                        if (!(route!.settings.name == "/discover"))
                          Navigator.pushNamed(context, Discover.routeName);
                      },
                      child: Container(
                        decoration: MenuState.discover == selectedMenu
                            ? BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 8,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              )
                            : null,
                        child: Column(
                          children: [
                            Container(
                              height: 45,
                              width: 60,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(18, 18, 18, 0),
                                child: SvgPicture.network(
                                  MenuState.discover == selectedMenu
                                      ? "https://res.cloudinary.com/dnwmz8ss2/image/upload/v1733266857/discover_hldnhv.svg"
                                      : "https://res.cloudinary.com/dnwmz8ss2/image/upload/v1733266857/discover-outline_z8fi6a.svg",
                                  color: MenuState.discover == selectedMenu
                                      ? Color(0xff651CE5)
                                      : null,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Container(
                                child: Text(
                                  "Discover",
                                  style: TextStyle(
                                      color: MenuState.discover == selectedMenu
                                          ? Color(0xff651CE5)
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Botón Inbox
                    GestureDetector(
                      onTap: () {
                        if (!(route!.settings.name == "/inbox"))
                          Navigator.pushNamed(context, InboxScreen.routeName);
                      },
                      child: Container(
                        decoration: MenuState.inbox == selectedMenu
                            ? BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 8,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              )
                            : null,
                        child: Column(
                          children: [
                            Container(
                              height: 45,
                              width: 60,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                                child: SvgPicture.network(
                                  MenuState.inbox == selectedMenu
                                      ? "https://res.cloudinary.com/dnwmz8ss2/image/upload/v1733266857/mail_bta6wd.svg"
                                      : "https://res.cloudinary.com/dnwmz8ss2/image/upload/v1733266859/mail-outline_sdw8or.svg",
                                  color: MenuState.inbox == selectedMenu
                                      ? Color(0xff651CE5)
                                      : null,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Container(
                                child: Text(
                                  "Inbox",
                                  style: TextStyle(
                                      color: MenuState.inbox == selectedMenu
                                          ? Color(0xff651CE5)
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Botón Profile
                    GestureDetector(
                      onTap: () {
                        if (!(route!.settings.name == "/profile"))
                          Navigator.pushNamed(
                              context, ProfileScreen.routeName);
                      },
                      child: Container(
                        decoration: MenuState.profile == selectedMenu
                            ? BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 8,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              )
                            : null,
                        child: Column(
                          children: [
                            Container(
                              height: 45,
                              width: 60,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(18, 18, 18, 0),
                                child: SvgPicture.network(
                                  MenuState.profile == selectedMenu
                                      ? "https://res.cloudinary.com/dnwmz8ss2/image/upload/v1733266857/profile_hznb6e.svg"
                                      : "https://res.cloudinary.com/dnwmz8ss2/image/upload/v1733266859/profile-outline_xlu8zb.svg",
                                  color: MenuState.profile == selectedMenu
                                      ? Color(0xff651CE5)
                                      : null,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Container(
                                child: Text(
                                  "Profile",
                                  style: TextStyle(
                                      color: MenuState.profile == selectedMenu
                                          ? Color(0xff651CE5)
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
