import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/pages/home.dart';
import 'package:wordpress_app/utils/next_screen.dart';

class DonePage extends StatefulWidget {
  const DonePage({Key? key}) : super(key: key);

  @override
  _DonePageState createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2000))
    .then((value) => nextScreenCloseOthers(context, HomePage()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
          child: Container(
        height: 280,
        width: 280,
        child: FlareActor(
          Config.doneAnimation,
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: "done",
          color: Theme.of(context).primaryColor.withOpacity(0.6),
        ),
      )),
    );
  }
}
