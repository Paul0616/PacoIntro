import 'package:flutter/material.dart';
import 'package:pacointro/blocs/login_bloc.dart';
import 'package:pacointro/models/user_model.dart';
import 'package:pacointro/repository/api_response.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class LocationsPage extends StatefulWidget {
  static String route = '/LocationsPage';

  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  LoginBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = Provider.of<LoginBloc>(context);
    _bloc.getCurrentUser();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TopBar(),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Image(
                              width: MediaQuery.of(context).size.width * 0.5,
                              image: AssetImage('images/location.png'),
                            ))
                        : Container(),
                    Text(
                      'Alege magazin (gestiune):',
                      style: textStyle.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: pacoAppBarColor),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: StreamBuilder<ApiResponse<UserModel>>(
                        stream: _bloc.currentUserStream,
                        builder: (context, snapshot) => snapshot.hasData &&
                                snapshot.data.status == Status.COMPLETED
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      snapshot.data.data.locations.length,
                                  itemBuilder: (context, index) =>
                                      MaterialButton(
                                    onPressed: () {
                                      _bloc.navigateToHomePage(
                                          snapshot.data.data.locations[index]);
                                    },
                                    highlightColor: pacoAppBarColor,
                                    child: buildListTile(
                                        index,
                                        snapshot.data.data.locations.length,
                                        snapshot
                                            .data.data.locations[index].name),
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListTile(int index, int itemsCount, String locationName) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: pacoAppBarColor,
          width: 0.5,
        ),
        borderRadius: buildTileBorderRadius(index, itemsCount),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              locationName,
              style: textStyleBold,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: textGray,
          ),
        ],
      ),
    );
  }

  BorderRadius buildTileBorderRadius(int index, int itemCount) => itemCount == 1
      ? BorderRadius.circular(12)
      : index == 0
          ? BorderRadius.only(
              topRight: Radius.circular(12),
              topLeft: Radius.circular(12),
            )
          : index == itemCount - 1
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                )
              : null;
}
