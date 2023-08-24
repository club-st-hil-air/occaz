import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import '../models/article.dart';

List<Article>? articles = [];
List<Article>? articlesFiltered = [];

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  String _chosenType = 'Tout type';
  String _chosenHomologation = 'Toute homologation';

  _DataSource _data = _DataSource([], []);
  bool isLoaded = false;

  // Récupère les données de l'API du stand
  // Ref: https://stackoverflow.com/questions/53288493/how-do-you-convert-a-list-future-to-a-list-to-use-as-a-variable-not-a-widget
  Future<List<Article>> getArticleList() async {
    final response = await http.get(Uri.parse(
        "https://stand-consult-public.s3.eu-west-3.amazonaws.com/standoccaz.json"));
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Article> articles = items.map<Article>((json) {
      return Article.fromJson(json);
    }).toList();
    if (!isLoaded) {
      setState(() {
        _data = _DataSource(
            articles,
            articles
                //.where((article) => article.statut.contains('En vente'))
                .toList()); // Au départ, on affiche tous les types d'article
        isLoaded = true;
        print("Appel de l'API, retour de " +
            articles.length.toString() +
            " articles.");
      });
    }
    return articles;
  }

  @override
  void initState() {
    super.initState();
  }

  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  @override
  Widget build(BuildContext context) {
    getArticleList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Occasions du Club St Hil\'Air'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Card(
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                      // BUG: on ne peut pas taper des espaces dans la version Desktop Windows.
                      //      Cela fonctionne sur la version web. https://github.com/flutter/flutter/issues/81233
                      controller: controller,
                      textAlign: TextAlign.left,
                      decoration: new InputDecoration(
                          hintText:
                              'Recherche dans n° coupon, type, marque, modèle, homologation, commentaires',
                          border: InputBorder.none),
                      onChanged: (value) {
                        setState(() {
                          _searchResult = value;
                          _data.articlesFiltered = _data.articles
                              .where((article) => _searchResult
                                  .toLowerCase()
                                  .split(" ")
                                  .every((s) =>
                                      (article.numeroCoupon.toString() +
                                              article.type +
                                              article.marque +
                                              article.modele +
                                              article.homologation +
                                              article.couleur +
                                              article.commentaire)
                                          .toLowerCase()
                                          .contains(s)))
                              .toList();
                          if (_chosenType != 'Tout type') {
                            _data.articlesFiltered = _data.articlesFiltered
                                .where((article) =>
                                    article.type.contains(_chosenType))
                                .toList();
                          }
                          if (_chosenHomologation != 'Toute homologation') {
                            _data.articlesFiltered = _data.articlesFiltered
                                .where((article) => article.homologation
                                    .contains(_chosenHomologation))
                                .toList();
                          }
                          _data.notifyListeners();
                        });
                      }),
                  trailing: new IconButton(
                    icon: new Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        controller.clear();
                        _searchResult = '';
                        _data.articlesFiltered = _data.articles;
                        if (_chosenType != 'Tout type') {
                          _data.articlesFiltered = _data.articlesFiltered
                              .where((article) =>
                                  article.type.contains(_chosenType))
                              .toList();
                        }
                        if (_chosenHomologation != 'Toute homologation') {
                          _data.articlesFiltered = _data.articlesFiltered
                              .where((article) => article.homologation
                                  .contains(_chosenHomologation))
                              .toList();
                        }
                        _data.notifyListeners();
                      });
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    //width: 200, // Your width for dropdowns
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _chosenType,
                        style: TextStyle(color: Colors.black),
                        items: <String>[
                          'Tout type',
                          '🪂Voile',
                          '💺Sellette',
                          '🆘Secours',
                          '🛠️Accessoire'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _chosenHomologation = 'Toute homologation';
                            _chosenType = value!;
                            _data.articlesFiltered = _data.articles
                                .where((article) => _searchResult
                                    .toLowerCase()
                                    .split(" ")
                                    .every((s) =>
                                        (article.numeroCoupon.toString() +
                                                article.type +
                                                article.marque +
                                                article.modele +
                                                article.homologation +
                                                article.couleur +
                                                article.commentaire)
                                            .toLowerCase()
                                            .contains(s)))
                                .toList();
                            if (_chosenType != 'Tout type') {
                              _data.articlesFiltered = _data.articlesFiltered
                                  .where((article) =>
                                      article.type.contains(_chosenType))
                                  .toList();
                            }
                            if (_chosenHomologation != 'Toute homologation') {
                              _data.articlesFiltered = _data.articlesFiltered
                                  .where((article) => article.homologation
                                      .contains(_chosenHomologation))
                                  .toList();
                            }
                            _data.notifyListeners();
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    //width: 200, // Your width for dropdowns
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _chosenHomologation,
                        style: TextStyle(color: Colors.black),
                        items: <String>[
                          'Toute homologation',
                          'EN A',
                          'EN B',
                          'EN C',
                          'EN D'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _chosenType = '🪂Voile';
                            _chosenHomologation = value!;
                            _data.articlesFiltered = _data.articles
                                .where((article) => _searchResult
                                    .toLowerCase()
                                    .split(" ")
                                    .every((s) =>
                                        (article.numeroCoupon.toString() +
                                                article.type +
                                                article.marque +
                                                article.modele +
                                                article.homologation +
                                                article.couleur +
                                                article.commentaire)
                                            .toLowerCase()
                                            .contains(s)))
                                .toList();
                            if (_chosenType != 'Tout type') {
                              _data.articlesFiltered = _data.articlesFiltered
                                  .where((article) =>
                                      article.type.contains(_chosenType))
                                  .toList();
                            }
                            if (_chosenHomologation != 'Toute homologation') {
                              _data.articlesFiltered = _data.articlesFiltered
                                  .where((article) => article.homologation
                                      .contains(_chosenHomologation))
                                  .toList();
                            }
                            _data.notifyListeners();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              PaginatedDataTable(
                source: _data,
                key:
                    UniqueKey(), // permet de repasser en première page après recherche
                header: Text('Lots en vente'),
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                columns: [
                  // DataColumn(
                  //     label: Text('Lot'),
                  //     onSort: (columnIndex, ascending) {
                  //       _data._sort((item) => item.idLot, ascending);
                  //       refreshAfterSort(columnIndex, ascending);
                  //     }),
                  DataColumn(
                      label: Text('Coupon'),
                      onSort: (columnIndex, ascending) {
                        _data._sort((item) => item.numeroCoupon, ascending);
                        refreshAfterSort(columnIndex, ascending);
                      }),
                  DataColumn(
                      label: Text('Type'),
                      onSort: (columnIndex, ascending) {
                        _data._sort((item) => item.type, ascending);
                        refreshAfterSort(columnIndex, ascending);
                      }),
                  DataColumn(
                      label: Text('Marque'),
                      onSort: (columnIndex, ascending) {
                        _data._sort((item) => item.marque, ascending);
                        refreshAfterSort(columnIndex, ascending);
                      }),
                  DataColumn(
                      label: Text('Modèle'),
                      onSort: (columnIndex, ascending) {
                        _data._sort((item) => item.modele, ascending);
                        refreshAfterSort(columnIndex, ascending);
                      }),
                  DataColumn(
                      label: Text('PTV Min'),
                      onSort: (columnIndex, ascending) {
                        _data._sort((item) => int.tryParse(item.pTVMin) ?? 0,
                            ascending);
                        refreshAfterSort(columnIndex, ascending);
                      }),
                  DataColumn(
                      label: Text('PTV Max'),
                      onSort: (columnIndex, ascending) {
                        _data._sort((item) => int.tryParse(item.pTVMax) ?? 0,
                            ascending);
                        refreshAfterSort(columnIndex, ascending);
                      }),
                  DataColumn(
                      label: Text('Prix'),
                      onSort: (columnIndex, ascending) {
                        _data._sort(
                            (item) => int.parse(item.prixVente), ascending);
                        refreshAfterSort(columnIndex, ascending);
                      }),
                  DataColumn(
                      label: Text('Homologation'),
                      onSort: (columnIndex, ascending) {
                        _data._sort((item) => item.homologation, ascending);
                        refreshAfterSort(columnIndex, ascending);
                      }),
                  DataColumn(
                      label: Text('Couleur'),
                      onSort: (columnIndex, ascending) {
                        _data._sort((item) => item.couleur, ascending);
                        refreshAfterSort(columnIndex, ascending);
                      }),
                  DataColumn(label: Text('Commentaires')),
                ],
                columnSpacing: 15,
                horizontalMargin: 10,
                rowsPerPage: 10,
                showCheckboxColumn: false,
                showFirstLastButtons: true,
                actions: <IconButton>[
                  IconButton(
                    splashColor: Colors.transparent,
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      // Refresh the data and reset filters
                      setState(() {
                        _data = _DataSource([], []);
                        _chosenType = 'Tout type';
                        _chosenHomologation = 'Toute homologation';
                        isLoaded = false;
                      });
                      getArticleList();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void refreshAfterSort(int columnIndex, bool ascending) {
    //_data.articlesFiltered = _data.articles;
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }
}

class _DataSource extends DataTableSource {
  // Dans la DataSource, on garde la liste complète des articles
  // venant de l'appel API, mais on affiche les articles filtrés
  // dans la DataTable.
  final List<Article> articles;
  List<Article> articlesFiltered;
  _DataSource(this.articles, this.articlesFiltered);

  bool get isRowCountApproximate => false;
  int get rowCount => articlesFiltered.length;
  int get selectedRowCount => 0;
  DataRow getRow(int index) {
    return DataRow(cells: [
      //DataCell(Text(articlesFiltered[index].idLot)),
      DataCell(Text(articlesFiltered[index].numeroCoupon.toString())),
      DataCell(Text(articlesFiltered[index].type)),
      DataCell(Text(articlesFiltered[index].marque)),
      DataCell(GestureDetector(
          child: Text(articlesFiltered[index].modele,
              style: TextStyle(decoration: TextDecoration.underline)),
          onTap: () => launchUrl(Uri.parse(
              'https://www.ecosia.org/search?method=index&q=' +
                  articlesFiltered[index].marque +
                  " " +
                  articlesFiltered[index].modele)))),
      DataCell(Text(articlesFiltered[index].pTVMin)),
      DataCell(Text(articlesFiltered[index].pTVMax)),
      DataCell(Text(articlesFiltered[index].prixVente + "€")),
      DataCell(Text(articlesFiltered[index].homologation)),
      DataCell(Text(articlesFiltered[index].couleur)),
      DataCell(Text(articlesFiltered[index].commentaire)),
    ]);
  }

  void _sort<T>(Comparable<T> Function(Article art) getField, bool ascending) {
    articlesFiltered.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
  }

  notifyListeners();
}
