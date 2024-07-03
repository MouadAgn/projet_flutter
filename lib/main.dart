import 'package:flutter/material.dart';
import 'dart:math';

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

class HomePage extends StatelessWidget {
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
              TopFiveSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Littérature',
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
        ],
        selectedItemColor: Color(0xFF1E3A8A),
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

class TopFiveSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Top 5 des Films'),
        TopFiveList(category: 'Films'),
        SectionTitle(title: 'Top 5 des Livres'),
        TopFiveList(category: 'Livres'),
        SectionTitle(title: 'Top 5 des Mangas'),
        TopFiveList(category: 'Mangas'),
        SectionTitle(title: 'Top 5 des Séries'),
        TopFiveList(category: 'Séries'),
        SectionTitle(title: 'Top 5 des Bandes Dessinées'),
        TopFiveList(category: 'Bandes Dessinées'),
      ],
    );
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

  const TopFiveList({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    category: category,
                    index: index,
                  ),
                ),
              );
            },
            child: TopFiveCard(category: category, index: index),
          );
        },
      ),
    );
  }
}

class TopFiveCard extends StatelessWidget {
  final String category;
  final int index;

  const TopFiveCard({Key? key, required this.category, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final int rating = 1 + random.nextInt(5);

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
            '$category $index',
            style: TextStyle(
              fontFamily: 'FiraSans',
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Description brève du $category $index.',
            style: TextStyle(
              fontFamily: 'Numans',
            ),
          ),
          Row(
            children: List.generate(5, (i) {
              return Icon(
                Icons.star,
                color: i < rating ? Colors.amber : Colors.grey[400],
                size: 16,
              );
            }),
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

  const DetailPage({Key? key, required this.category, required this.index}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late int currentRating;
  late int userRating;

  @override
  void initState() {
    super.initState();
    final random = Random();
    currentRating = 1 + random.nextInt(5);
    userRating = currentRating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails'),
        backgroundColor: Color(0xFF1E3A8A),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              _getImageUrlForCategory(widget.category),
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              '${widget.category} ${widget.index}',
              style: TextStyle(
                fontFamily: 'FiraSans',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Description détaillée du ${widget.category} ${widget.index}. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
              style: TextStyle(
                fontFamily: 'Numans',
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Note actuelle : ',
                  style: TextStyle(
                    fontFamily: 'FiraSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      Icons.star,
                      color: i < currentRating ? Colors.amber : Colors.grey[400],
                      size: 24,
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Votre note :',
              style: TextStyle(
                fontFamily: 'FiraSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      userRating = index + 1;
                    });
                  },
                  child: Icon(
                    Icons.star,
                    color: index < userRating ? Colors.amber : Colors.grey[400],
                    size: 40,
                  ),
                );
              }),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.category} ${widget.index} ajouté aux favoris.'),
                    duration: Duration(seconds: 2),

                    
                  ),
                );
              },
              child: Text('Ajouter aux favoris'),
            
              
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
