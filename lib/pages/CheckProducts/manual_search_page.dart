import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pacointro/blocs/api_call_bloc.dart';
import 'package:pacointro/blocs/api_call_event.dart';
import 'package:pacointro/blocs/api_call_state.dart';

import 'package:pacointro/blocs/manual_search_bloc.dart';
import 'package:pacointro/blocs/manual_search_event.dart';
import 'package:pacointro/blocs/manual_search_state.dart';
import 'package:pacointro/models/paginated_model.dart';
import 'package:pacointro/models/product_model.dart';
import 'package:pacointro/pages/CheckProducts/price_page.dart';
import 'package:pacointro/utils/constants.dart';
import 'package:pacointro/utils/nav_key.dart';

import 'package:pacointro/widgets/search_field.dart';
import 'package:pacointro/widgets/top_bar.dart';

class ManualSearchingPage extends StatefulWidget {
  static String route = "/ManualSearchingPage";

  @override
  _ManualSearchingPageState createState() => _ManualSearchingPageState();
}

class _ManualSearchingPageState extends State<ManualSearchingPage> {
  ManualSearchBloc _bloc = ManualSearchBloc();
  List<ProductModel> _products = List<ProductModel>();
  ScrollController _scrollController = ScrollController();
  SearchType _searchType;
  bool _isLoading = false;
  bool _hasMoreItems = true;
  int _page = 1;

  _listenScrollController(BuildContext context) {
    _scrollController.addListener(() {
      _onScroll(context);
    });
  }

  @override
  void initState() {
    super.initState();
  } // @override
  // bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    _searchType = ModalRoute.of(context).settings.arguments;
    _products.clear();
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        return true;
      },
      child: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => _bloc,
            ),
            BlocProvider(
              create: (_) => ApiCallBloc(),
            )
          ],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TopBar(
                withBackNavigation: true,
                bottomMargin: 16,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        _searchType == SearchType.BY_CODE
                            ? 'Codul de bare trebuie să fie exact, fără spații...'
                            : 'Tastati cel putin 3 caractere continute in numele produsului...',
                        style: textStyle.copyWith(fontSize: 12),
                      ),
                      BlocBuilder<ManualSearchBloc, ManualSearchState>(
                          builder: (context, state) {
                        bool isSearchEnable = false;
                        print(state);
                        _listenScrollController(context);
                        if (state is EmptyState) {
                          print('validate');
                          _bloc.add(ValidateSearchTextEvent('', _searchType));
                        }
                        if (state is SearchWidgetEnabledState) {
                          print(state.isEnabled);
                          isSearchEnable = state.isEnabled;
                        }
                        return SearchFieldWidget(
                          hint: _searchType == SearchType.BY_CODE
                              ? 'Cod de bare'
                              : 'Nume produs',
                          keyboardShouldBeNumeric:
                              _searchType == SearchType.BY_CODE,
                          disabled: !isSearchEnable,
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _isLoading = true;
                            _page = 1;
                            _products.clear();
                            BlocProvider.of<ApiCallBloc>(context).add(
                                GetProductsEvent(
                                    _searchType, _bloc.searchText, _page));
                          },
                          onChanged: (text) {
                            _bloc.add(
                                ValidateSearchTextEvent(text, _searchType));
                          },
                        );
                      }),
                      // SizedBox(
                      //   height: 4,
                      // ),
                      BlocListener<ApiCallBloc, ApiCallState>(
                        listener: _errorListener,
                        child: BlocBuilder<ApiCallBloc, ApiCallState>(
                            builder: (context, state) {
                          print(state);
                          if (state is ApiCallLoadingState) {
                            return Expanded(
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            );
                          }
                          if (state is ApiCallLoadedState) {
                            _isLoading = false;
                            _hasMoreItems =
                                !(state.response as PaginatedModel).isLastPage;
                            if (_products.contains(null))
                              _products.remove(null);
                            _products.addAll(
                                (state.response as PaginatedModel).products);
                            if (_hasMoreItems) _products.add(null);
                            return _buildListView();
                          }
                          return Container();
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Expanded _buildListView() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: _products.length,
        itemBuilder: (context, index) {
          if (_products[index] == null)
            return Padding(
              padding: EdgeInsets.all(8),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          return ListTile(
            onTap: () {
              print(_products[index].price);
              final navKey = NavKey.navKey;
              navKey.currentState.popAndPushNamed(PricePage.route,
                  arguments: _products[index]);
            },
            title: Text(
              '${_products[index].name}',
              style: textStyleBold,
            ),
            subtitle: Text(
              '${_products[index].id}',
              style: textStyle,
            ),
          );
        },
      ),
    );
  }

  _onScroll(BuildContext context) {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    // print(
    //     'isLoading $_isLoading hasMoreItems $_hasMoreItems _onScroll $maxScroll $currentScroll');
    if (maxScroll == currentScroll) {
      if (!_isLoading && _hasMoreItems) {
        _page++;
        _isLoading = !_isLoading;
        BlocProvider.of<ApiCallBloc>(context)
            .add(GetProductsEvent(_searchType, _bloc.searchText, _page));
      }
    }
  }

  _errorListener(BuildContext context, ApiCallState state) {
    if (state is ApiCallErrorState) {
      if (state.message.isNotEmpty) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(state.message),
        ));
      }
    }
  }
}
