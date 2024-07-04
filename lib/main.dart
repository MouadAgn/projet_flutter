import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Détails des Livres',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BookPage(),
    );
  }
}

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late Future<List<Book>> futureBooks;

  @override
  void initState() {
    super.initState();
    futureBooks = fetchBooks();
  }

  Future<List<Book>> fetchBooks() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/leisures'));

    if (response.statusCode == 200) {
      List<dynamic> booksJson = jsonDecode(response.body);
      return booksJson.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des livres');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails des Livres'),
      ),
      body: Center(
        child: FutureBuilder<List<Book>>(
          future: futureBooks,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Book book = snapshot.data![index];
                  return ListTile(
                    title: Text(book.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Auteur ou Directeur: ${book.authorOrDirector}'),
                        Text('Date: ${book.date}'),
                        Text('Nombre de Pages: ${book.nbrPages}'),
                        Text('Catégorie: ${book.category.name}'),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class Book {
  final String name;
  final String authorOrDirector;
  final String date;
  final int nbrPages;
  final Category category;

  Book({
    required this.name,
    required this.authorOrDirector,
    required this.date,
    required this.nbrPages,
    required this.category,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
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

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}
