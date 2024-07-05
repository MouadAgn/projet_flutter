import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netfloox',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.network(
              'https://t3.ftcdn.net/jpg/04/06/92/60/360_F_406926005_dGy1iIhhadwEGOTFJjw2q1ir7lrYjg3C.jpg',
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              'Netfloox',
              style: TextStyle(
                fontFamily: 'FiraSans',
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF1E3A8A),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBar(),
              SizedBox(height: 16),
              AddLeisureButton(),
              SizedBox(height: 16),
              TopFiveSection(category: _getCategoryName(currentIndex)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Livres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Films',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Series',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Mangas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Bandes Dessinées',
          ),
        ],
        selectedItemColor: Color(0xFF1E3A8A),
        unselectedItemColor: Colors.grey[400],
        selectedFontSize: 18,
        unselectedFontSize: 18,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontFamily: 'FiraSans',
          color: Colors.white,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'FiraSans',
          color: const Color.fromARGB(255, 227, 26, 26),
        ),
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  String _getCategoryName(int index) {
    switch (index) {
      case 0:
        return 'Livres';
      case 1:
        return 'Films';
      case 2:
        return 'Series';
      case 3:
        return 'Mangas';
      case 4:
        return 'Bandes Dessinées';
      default:
        return 'Films';
    }
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Rechercher un loisir',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class AddLeisureButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddLeisurePage()),
        );
      },
      child: Text('Ajouter un loisir'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1E3A8A),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}

class AddLeisurePage extends StatefulWidget {
  @override
  _AddLeisurePageState createState() => _AddLeisurePageState();
}

class _AddLeisurePageState extends State<AddLeisurePage> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? category;
  String? authorOrDirector;
  String? date;
  int? nbrPages;

  final List<String> categories = ['Livres', 'Films', 'Series', 'Mangas', 'Bandes Dessinées'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un loisir'),
        backgroundColor: Color(0xFF1E3A8A),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
                onSaved: (value) => name = value,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Catégorie'),
                items: categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner une catégorie';
                  }
                  return null;
                },
                onChanged: (value) => category = value as String,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Auteur/Réalisateur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un auteur ou réalisateur';
                  }
                  return null;
                },
                onSaved: (value) => authorOrDirector = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                onSaved: (value) => date = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre de pages'),
                keyboardType: TextInputType.number,
                onSaved: (value) => nbrPages = int.tryParse(value ?? ''),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Ajouter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E3A8A),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.parse('http://127.0.0.1:8000/api/add-leisure');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'category_name': category,
          'authorOrDirector': authorOrDirector,
          'date': date,
          'nbrPages': nbrPages,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loisir ajouté avec succès')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout du loisir')),
        );
      }
    }
  }
}

class Leisure {
  final int id;
  final String name;
  final String authorOrDirector;
  final String? date;
  final int? nbrPages;
  final Category category;

  Leisure({
    required this.id,
    required this.name,
    required this.authorOrDirector,
    this.date,
    this.nbrPages,
    required this.category,
  });

  factory Leisure.fromJson( <String, dynamic> json) {
    return Leisure(
      id: json['id'],
      name: json['name'],
      authorOrDirector: json['authorOrDirector'],
      date: json['date'],
      nbrPages: json['nbrPages'],
      category: Category.fromJson(json['category']),
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

class TopFiveSection extends StatefulWidget {
  final String category;

  const TopFiveSection({Key? key, required this.category}) : super(key: key);

  @override
  _TopFiveSectionState createState() => _TopFiveSectionState();
}

class _TopFiveSectionState extends State<TopFiveSection> {
  String sortBy = 'alphabetical';
  List<Leisure> allLeisures = [];
  List<Leisure> filteredLeisures = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLeisures();
  }

  @override
  void didUpdateWidget(TopFiveSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category) {
      filterLeisures();
    }
  }

  Future<void> fetchLeisures() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/leisures'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        allLeisures = jsonData.map((json) => Leisure.fromJson(json)).toList();
        filterLeisures();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load leisures');
    }
  }

  void filterLeisures() {
    filteredLeisures = allLeisures
        .where((leisure) => leisure.category.name.toLowerCase() == widget.category.toLowerCase())
        .toList();
    _sortLeisures();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Top 5 des ${widget.category}'),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Trier par: '),
            DropdownButton<String>(
              value: sortBy,
              onChanged: (String? newValue) {
                setState(() {
                  sortBy = newValue!;
                  _sortLeisures();
                });
              },
              items: <String>['alphabetical', 'date', 'rating']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value == 'alphabetical'
                        ? 'alphabétique'
                        : value == 'date'
                            ? 'date'
                            : 'note',
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        isLoading
            ? CircularProgressIndicator()
            : TopFiveList(leisures: filteredLeisures.take(5).toList()),
      ],
    );
  }

  void _sortLeisures() {
    filteredLeisures.sort((a, b) {
      if (sortBy == 'alphabetical') {
        return a.name.compareTo(b.name);
      } else if (sortBy == 'date') {
        return (b.date ?? '').compareTo(a.date ?? '');
      }
      return 0;
    });
    setState(() {});
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'FiraSans',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class TopFiveList extends StatelessWidget {
  final List<Leisure> leisures;

  const TopFiveList({Key? key, required this.leisures}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: leisures.length,
        itemBuilder: (context, index) {
          final leisure = leisures[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    category: leisure.category.name,
                    index: index,
                    name: leisure.name,
                    description: leisure.authorOrDirector,
                    initialRating: 0,
                    date: leisure.date != null ? DateTime.parse(leisure.date!) : DateTime.now(),
                  ),
                ),
              );
            },
            child: TopFiveCard(
              category: leisure.category.name,
              index: index,
              name: leisure.name,
              description: leisure.authorOrDirector,
              rating: 0,
              date: leisure.date != null ? DateTime.parse(leisure.date!) : DateTime.now(),
            ),
          );
        },
      ),
    );
  }
}

class TopFiveCard extends StatelessWidget {
  final String category;
  final int index;
  final String name;
  final String description;
  final int rating;
  final DateTime date;

  const TopFiveCard({
    Key? key,
    required this.category,
    required this.index,
    required this.name,
    required this.description,
    required this.rating,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    return Container(
      width: 150,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            _getImageUrlForCategory(category),
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontFamily: 'FiraSans',
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontFamily: 'Numans',
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: index < rating ? Colors.amber : Colors.grey,
                size: 16,
              );
            }),
          ),
          SizedBox(height: 4),
          Text(
            'Date de sortie: ${formatter.format(date)}',
            style: TextStyle(
              fontFamily: 'Numans',
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  String _getImageUrlForCategory(String category) {
    switch (category) {
      case 'Films':
        return 'https://t3.ftcdn.net/jpg/05/90/75/40/360_F_590754013_CoFRYEcAmLREfB3k8vjzuyStsDbMAnqC.jpg';
      case 'Livres':
        return 'https://t4.ftcdn.net/jpg/02/36/41/51/360_F_236415197_aHuHuTomAaURIX0UKAGCdWkOGTO4qBfH.jpg';
      case 'Mangas':
        return 'https://upload.wikimedia.org/wikipedia/fr/9/96/Logo-mangaschaine2022.png';
      case 'Series':
        return 'https://t4.ftcdn.net/jpg/02/36/41/51/360_F_236415197_aHuHuTomAaURIX0UKAGCdWkOGTO4qBfH.jpg';
      case 'Bandes Dessinées':
        return 'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/comic-logo-design-template-fecbd8dc44fc05424ad9ed9408b43d3e_screen.jpg?ts=1679878648';
      default:
        return '';
    }
  }
}

class DetailPage extends StatefulWidget {
  final String category;
  final int index;
  final String name;
  final String description;
  final int initialRating;
  final DateTime date;

  const DetailPage({
    Key? key,
    required this.category,
    required this.index,
    required this.name,
    required this.description,
    required this.initialRating,
    required this.date,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late int _rating;
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Color(0xFF1E3A8A),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                _getImageUrlForCategory(widget.category),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Text(
                widget.description,
                style: TextStyle(
                  fontFamily: 'Numans',
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Votre note: ',
                    style: TextStyle(
                      fontFamily: 'FiraSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: index < _rating ? Colors.amber : Colors.grey,
                          size: 24,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isFavorited = !isFavorited;
                  });
                  // Ajouter la logique pour ajouter aux favoris ici
                },
                child: Text(
                  isFavorited ? 'Retirer des favoris' : 'Ajouter aux favoris',
                  style: TextStyle(
                    fontFamily: 'FiraSans',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFavorited ? Colors.grey : Color(0xFF1E3A8A),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Date de sortie: ${formatter.format(widget.date)}',
                style: TextStyle(
                  fontFamily: 'Numans',
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getImageUrlForCategory(String category) {
    switch (category) {
      case 'Films':
        return 'https://t3.ftcdn.net/jpg/05/90/75/40/360_F_590754013_CoFRYEcAmLREfB3k8vjzuyStsDbMAnqC.jpg';
      case 'Livres':
        return 'https://t4.ftcdn.net/jpg/02/36/41/51/360_F_236415197_aHuHuTomAaURIX0UKAGCdWkOGTO4qBfH.jpg';
      case 'Mangas':
        return 'https://upload.wikimedia.org/wikipedia/fr/9/96/Logo-mangaschaine2022.png';
      case 'Series':
        return 'https://t4.ftcdn.net/jpg/02/36/41/51/360_F_236415197_aHuHuTomAaURIX0UKAGCdWkOGTO4qBfH.jpg';
      case 'Bandes Dessinées':
        return 'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/comic-logo-design-template-fecbd8dc44fc05424ad9ed9408b43d3e_screen.jpg?ts=1679878648';
      default:
        return '';
    }
  }
}