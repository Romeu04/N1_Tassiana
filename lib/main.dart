import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filmes App',
      theme: ThemeData(
        primaryColor: Color(0xFFa14016), // Usada na AppBar
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Color(0xFFcc883a), // Usada no fundo da aplicação
          surface: Color(0xFFcfc89a),   // Usada nos Cards dos filmes
        ),
      ),
      home: MovieListScreen(),
    );
  }
}

class Movie {
  final String title;
  final String genre;
  final String image;

  Movie({required this.title, required this.genre, required this.image});
}

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  List<Movie> movies = [
    // Drama
    Movie(title: 'Gilmore Girls', genre: 'Drama', image: 'assets/gilmore_girls.jpg'),
    Movie(title: 'The Shawshank Redemption', genre: 'Drama', image: 'assets/shawshank_redemption.jpg'),
    Movie(title: 'Forrest Gump', genre: 'Drama', image: 'assets/forrest_gump.jpg'),

    // Comedy
    Movie(title: 'The Office', genre: 'Comedy', image: 'assets/the_office.jpg'),
    Movie(title: 'Parks and Recreation', genre: 'Comedy', image: 'assets/parks_and_rec.jpg'),
    Movie(title: 'The Good Place', genre: 'Comedy', image: 'assets/the_good_place.jpg'),

    // Action
    Movie(title: 'Outlaw King', genre: 'Action', image: 'assets/outlaw_king.jpg'),
    Movie(title: 'Mad Max: Fury Road', genre: 'Action', image: 'assets/mad_max_fury_road.jpg'),
    Movie(title: 'John Wick', genre: 'Action', image: 'assets/john_wick.jpeg'),

    // Horror
    Movie(title: 'The Haunting of Hill House', genre: 'Horror', image: 'assets/haunting_hill_house.jpg'),
    Movie(title: 'The Conjuring', genre: 'Horror', image: 'assets/the_conjuring.jpg'),
    Movie(title: 'Hereditary', genre: 'Horror', image: 'assets/hereditary.jpg'),

    // Romance
    Movie(title: 'Pride and Prejudice', genre: 'Romance', image: 'assets/pride_and_prejudice.jpg'),
    Movie(title: 'La La Land', genre: 'Romance', image: 'assets/la_la_land.png'),
    Movie(title: 'The Notebook', genre: 'Romance', image: 'assets/the_notebook.jpeg'),
  ];

  String? selectedGenre; // Gênero selecionado
  List<String> genres = ['Todos', 'Drama', 'Comedy', 'Action', 'Horror', 'Romance'];

  @override
  Widget build(BuildContext context) {
    // Filtra os filmes com base no gênero selecionado
    List<Movie> filteredMovies = selectedGenre == null || selectedGenre == 'Todos'
        ? movies
        : movies.where((movie) => movie.genre == selectedGenre).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Filmes'),
        backgroundColor: Theme.of(context).primaryColor, // Cor da AppBar
      ),
      body: Container(
        color: Theme.of(context).colorScheme.secondary, // Fundo da aplicação
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'Filtrar por gênero: ',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedGenre,
                    hint: Text('Selecione um gênero'),
                    items: genres.map((genre) {
                      return DropdownMenuItem<String>(
                        value: genre,
                        child: Text(genre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGenre = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: filteredMovies.map((movie) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(
                            movie: movie,
                            movies: movies,
                          ),
                        ),
                      );
                    },
                    child: MovieCard(movie: movie),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface, // Cor dos Cards
      margin: EdgeInsets.all(8),
      child: Row(
        children: [
          Image.asset(
            movie.image,
            width: 100,
            height: 150,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                movie.genre,
                style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 255, 255, 255)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  final List<Movie> movies;

  MovieDetailScreen({required this.movie, required this.movies});

  @override
  Widget build(BuildContext context) {
    // Filtra os filmes do mesmo gênero, excluindo o filme selecionado
    List<Movie> sameGenreMovies = movies
        .where((m) => m.genre == movie.genre && m.title != movie.title)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: Theme.of(context).primaryColor, // Cor da AppBar
      ),
      body: Container(
        color: Theme.of(context).colorScheme.secondary, // Fundo da aplicação
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              movie.image,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    movie.genre,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Outros filmes do mesmo gênero:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sameGenreMovies.length,
                itemBuilder: (context, index) {
                  return MovieCard(movie: sameGenreMovies[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
