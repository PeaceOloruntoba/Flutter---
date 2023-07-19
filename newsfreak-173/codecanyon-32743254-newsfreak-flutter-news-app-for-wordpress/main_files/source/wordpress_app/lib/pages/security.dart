import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../blocs/user_bloc.dart';
import '../config/config.dart';
import '../utils/toast.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {


  _openDeleteDialog() {
    
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('account-delete-title').tr(),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleRequestDeleteAccount();
                },
                child: Text('account-delete-confirm', style: TextStyle(
                  fontWeight: FontWeight.w600
                ),).tr(),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('cancel').tr())
            ],
          );
        });
  }

  _handleRequestDeleteAccount() async {
    final ub = context.read<UserBloc>();
    final Uri uri = Uri(
      scheme: 'mailto',
      path: Config.supportEmail,
      query: 'subject=${Config.appName} - Account Delete Request&body=Hi there, \nI want to delete my account from the ${Config.appName} App. \n\nUsername: ${ub.name} \nEmail Address: ${ub.email} \n\nSo, Please delete my account.\nThanks', //add subject and body here
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      openToast1(context, "Can't open the email app");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('security').tr(),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(15),
                isThreeLine: false,
                title: Text(
                  'request-account-delete',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ).tr(),
                leading: CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 20,
                  child: Icon(
                    Feather.trash,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                onTap: _openDeleteDialog,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
