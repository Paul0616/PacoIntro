import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/api_call_bloc.dart';
import 'package:pacointro/blocs/api_call_event.dart';
import 'package:pacointro/blocs/api_call_state.dart';
import 'package:pacointro/blocs/locations_bloc.dart';
import 'package:pacointro/blocs/locations_event.dart';
import 'package:pacointro/models/user_model.dart';
import 'package:pacointro/pages/login_page.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/widgets/top_bar.dart';

class LocationsPage extends StatefulWidget {
  static String route = '/LocationsPage';

  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  // LoginBloc1 _bloc;

  // String errorMessage;
  UserModel user;

  @override
  void didChangeDependencies() {
    // _bloc = Provider.of<LoginBloc1>(context);
    // _bloc.getCurrentUser();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ApiCallBloc(),
          ),
          BlocProvider(
            create: (_) => LocationsBloc(),
          ),
        ],
        child: Center(
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
                        child: BlocListener<ApiCallBloc, ApiCallState>(
                          listener: (context, apiListenerState) {
                            if (apiListenerState is ApiCallErrorState) {
                              dialogAlert(context, "Eroare",
                                  Text(apiListenerState.message),
                                  onPressedPositive: () {
                                Navigator.of(context)
                                    .pushReplacementNamed(LoginPage.route);
                                // BlocProvider.of<ApiCallBloc>(context)
                                //     .add(EmptyEvent());
                              });
                            }
                          },
                          child: BlocBuilder<ApiCallBloc, ApiCallState>(
                            builder: (context, apiState) {
                              if (apiState is ApiCallEmptyState) {
                                // if (errorMessage != null) {
                                //   BlocProvider.of<ApiCallBloc>(context)
                                //       .add(ApiCallErrorEvent(errorMessage));
                                //   errorMessage = null;
                                // } else {
                                BlocProvider.of<ApiCallBloc>(context)
                                    .add(CheckUserEvent());
                                // }
                              }
                              if (apiState is ApiCallLoadingState) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (apiState is ApiCallLoadedState) {
                                user = apiState.response as UserModel;
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      user != null ? user.locations.length : 0,
                                  itemBuilder: (context, index) =>
                                      MaterialButton(
                                    onPressed: () {
                                      BlocProvider.of<LocationsBloc>(context)
                                          .add(NavigateToHomePageEvent(
                                              user.locations[index]));
                                      // snapshot
                                      //     .data.data.locations[index]);
                                    },
                                    highlightColor: pacoAppBarColor,
                                    child: buildListTile(
                                        index,
                                        user != null
                                            ? user.locations.length
                                            : 0,
                                        user != null
                                            ? user.locations[index].name
                                            : ''),
                                  ),
                                ),
                              );
                            },
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
