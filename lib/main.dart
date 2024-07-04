import 'package:flutter/material.dart';
import 'dart:math';
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
  int currentIndex = 1; // Définit l'onglet actif. 1 correspond à 'Films'.

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
              // Affiche le contenu en fonction de l'onglet sélectionné
              currentIndex == 0
                  ? TopFiveSection(category: 'Livres')
                  : currentIndex == 1
                      ? TopFiveSection(category: 'Films')
                      : currentIndex == 2
                          ? TopFiveSection(category: 'Séries')
                          : currentIndex == 3
                              ? TopFiveSection(category: 'Mangas')
                              : TopFiveSection(category: 'Bandes Dessinées'),
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
            label: 'Séries',
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
            currentIndex = index; // Met à jour l'onglet actif
          });
        },
      ),
    );
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

class TopFiveSection extends StatefulWidget {
  final String category;

  const TopFiveSection({Key? key, required this.category}) : super(key: key);

  @override
  _TopFiveSectionState createState() => _TopFiveSectionState();
}

class _TopFiveSectionState extends State<TopFiveSection> {
  String sortBy = 'alphabetical';
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    items = _generateItems(widget.category);
  }

  List<Map<String, dynamic>> _generateItems(String category) {
    List<Map<String, dynamic>> generatedItems = List.generate(5, (index) {
      final random = Random();
      String categoryName = _getCategoryDisplayName(category);
      return {
        'index': index,
        'name': '$categoryName ${index + 1}',
         'description': 'Description brève de $categoryName ${index + 1}.',
        'rating': 1 + random.nextInt(5),
        'date': DateTime.now().subtract(Duration(days: random.nextInt(1000))),
      };
    });

    generatedItems.sort((a, b) {
      if (sortBy == 'alphabetical') {
        return a['name'].compareTo(b['name']);
      } else if (sortBy == 'date') {
        return b['date'].compareTo(a['date']);
      } else if (sortBy == 'rating') {
        return b['rating'].compareTo(a['rating']);
      }
      return 0;
    });

    return generatedItems;
  }

  void _addItem(Map<String, dynamic> newItem) {
  setState(() {
    items.add(newItem);
    items.sort((a, b) {
      if (sortBy == 'alphabetical') {
        return a['name'].compareTo(b['name']);
      } else if (sortBy == 'date') {
        return b['date'].compareTo(a['date']);
      } else if (sortBy == 'rating') {
        return b['rating'].compareTo(a['rating']);
      }
      return 0;
    });
  });

  // Afficher un SnackBar pour indiquer que le loisir a été ajouté
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Le loisir "${newItem['name']}" a été ajouté avec succès!'),
      duration: Duration(seconds: 3), // Durée d'affichage du SnackBar
      action: SnackBarAction(
        label: 'Fermer',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
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
                  items.sort((a, b) {
                    if (sortBy == 'alphabetical') {
                      return a['name'].compareTo(b['name']);
                    } else if (sortBy == 'date') {
                      return b['date'].compareTo(a['date']);
                    } else if (sortBy == 'rating') {
                      return b['rating'].compareTo(a['rating']);
                    }
                    return 0;
                  });
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
        TopFiveList(category: widget.category, items: items),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddLeisureForm(category: widget.category, onAdd: _addItem),
              ),
            );
          },
          child: Text('Ajouter un loisir'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF806491),
          ),
        ),
      ],
    );
  }
}

 String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'Films':
        return 'Film';
      case 'Livres':
        return 'Livre';
      case 'Mangas':
        return 'Manga';
      case 'Séries':
        return 'Série';
      case 'Bandes Dessinées':
        return 'Bande Dessinée';
      default:
        return 'Loisir';
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
  final String category;
  final List<Map<String, dynamic>> items;

  const TopFiveList({Key? key, required this.category, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    category: category,
                    index: item['index'],
                    name: item['name'],
                    description: item['description'],
                    initialRating: item['rating'], // Note initiale de l'élément
                    date: item['date'],
                  ),
                ),
              );
            },
            child: TopFiveCard(
              category: category,
              index: item['index'],
              name: item['name'],
              description: item['description'],
              rating: item['rating'],
              date: item['date'],
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
      case 'Séries':
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
  final int initialRating; // Note initiale de l'élément
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
  late int _rating; // Variable pour stocker la note choisie par l'utilisateur
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating; // Initialise la note avec la valeur initiale
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Color(0xFF1E3A8A),
      ),
      body: Padding(
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
                          _rating = index + 1; // Met à jour la note sélectionnée
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
                backgroundColor: isFavorited ? Colors.grey : Color(0xFF806491),
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
      case 'Séries':
        return 'https://t4.ftcdn.net/jpg/02/36/41/51/360_F_236415197_aHuHuTomAaURIX0UKAGCdWkOGTO4qBfH.jpg';
      case 'Bandes Dessinées':
        return 'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/comic-logo-design-template-fecbd8dc44fc05424ad9ed9408b43d3e_screen.jpg?ts=1679878648';
      default:
        return '';
    }
  }
}

class AddLeisureForm extends StatefulWidget {
  final String category;
  final Function(Map<String, dynamic>) onAdd;

  const AddLeisureForm({Key? key, required this.category, required this.onAdd})
      : super(key: key);

  @override
  _AddLeisureFormState createState() => _AddLeisureFormState();
}

class _AddLeisureFormState extends State<AddLeisureForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _typeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un loisir'),
        backgroundColor: Color(0xFF1E3A8A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une catégorie';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date de sortie',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une date de sortie';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newLeisure = {
                      'index': Random().nextInt(1000), // Génère un ID aléatoire
                      'name': _titleController.text,
                      'description': _descriptionController.text,
                      'rating': Random().nextInt(5) + 1,
                      'date': DateTime.parse(_dateController.text),
                    };

                    widget.onAdd(newLeisure); // Appelle la fonction onAdd pour ajouter le loisir

                    Navigator.pop(context); // Retourne à la page précédente
                  }
                },
                child: Text('Enregistrer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF806491),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
