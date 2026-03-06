import Foundation

final class MovieDatabase {
    static let shared = MovieDatabase()

    let allMovies: [Movie]

    private init() {
        if let url = Bundle.main.url(forResource: "movies", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let movies = try? JSONDecoder().decode([Movie].self, from: data) {
            allMovies = movies
        } else {
            allMovies = Self.builtInMovies
        }
    }

    // MARK: - Query Methods

    func trending() -> [Movie] {
        allMovies.sorted { $0.rating > $1.rating }
    }

    func byGenre(_ genre: String) -> [Movie] {
        allMovies.filter { $0.genres.contains(genre) }
    }

    func byPlatform(_ platform: OTTPlatform) -> [Movie] {
        allMovies.filter { $0.availableOn.contains(platform.name) }
    }

    func byLanguage(_ language: String) -> [Movie] {
        allMovies.filter { $0.language?.lowercased() == language.lowercased() }
    }

    func movie(byId imdbId: String) -> Movie? {
        allMovies.first { $0.imdbId == imdbId }
    }

    func search(query: String) -> [Movie] {
        let q = query.lowercased()
        return allMovies.filter {
            $0.title.lowercased().contains(q) ||
            $0.cast?.lowercased().contains(q) == true ||
            $0.director?.lowercased().contains(q) == true ||
            $0.genres.joined(separator: " ").lowercased().contains(q)
        }
    }

    func similar(to movie: Movie) -> [Movie] {
        let movieGenres = Set(movie.genres)
        return allMovies
            .filter { $0.imdbId != movie.imdbId }
            .map { other in
                let commonGenres = Set(other.genres).intersection(movieGenres).count
                return (other, commonGenres)
            }
            .filter { $0.1 > 0 }
            .sorted { $0.1 > $1.1 || ($0.1 == $1.1 && $0.0.rating > $1.0.rating) }
            .prefix(10)
            .map { $0.0 }
    }

    // MARK: - Built-in Movie Data (IMDb sourced)

    static let builtInMovies: [Movie] = [
        // Bollywood - Action/Thriller
        Movie(imdbId: "tt9179730", title: "Jawan", year: 2023, genres: ["Action", "Thriller", "Drama"], rating: 6.8, summary: "A prison warden recruits inmates to commit outrageous crimes that shed light on corruption and injustice, while keeping his identity a secret.", posterURL: "https://m.media-amazon.com/images/M/MV5BYjk1ZTMxOWQtYWFkMy00YjFlLTliMTgtNGRjOTg5OGY4OWEzXkEyXkFqcGc@._V1_.jpg", cast: "Shah Rukh Khan, Nayanthara, Vijay Sethupathi", director: "Atlee", runtime: "2h 49m", language: "Hindi", availableOn: ["Netflix"]),

        Movie(imdbId: "tt10665338", title: "Pathaan", year: 2023, genres: ["Action", "Thriller"], rating: 6.3, summary: "An Indian spy takes on the leader of a group of mercenaries who have nefarious plans to target his homeland.", posterURL: "https://m.media-amazon.com/images/M/MV5BM2QzNjRhZjUtZThiYS00MDBhLWEzZDctNjY3NTkzNjliYTcxXkEyXkFqcGc@._V1_.jpg", cast: "Shah Rukh Khan, Deepika Padukone, John Abraham", director: "Siddharth Anand", runtime: "2h 26m", language: "Hindi", availableOn: ["Prime Video"]),

        Movie(imdbId: "tt15354916", title: "Animal", year: 2023, genres: ["Action", "Crime", "Drama"], rating: 6.2, summary: "The son of a wealthy businessman becomes violent and ruthless as he tries to impress his neglectful father and protect the family empire.", posterURL: "https://m.media-amazon.com/images/M/MV5BNGViZGM1OTktZTRiOS00YzUwLTgxNTAtYjFmMjUxMmY0NjYwXkEyXkFqcGc@._V1_.jpg", cast: "Ranbir Kapoor, Anil Kapoor, Bobby Deol", director: "Sandeep Reddy Vanga", runtime: "3h 21m", language: "Hindi", availableOn: ["Netflix"]),

        Movie(imdbId: "tt12844910", title: "Kalki 2898 AD", year: 2024, genres: ["Sci-Fi", "Action", "Fantasy"], rating: 6.3, summary: "In a dystopian future set in 2898 AD, a modern-day avatar of Vishnu battles to protect the unborn child destined to save the world.", posterURL: "https://m.media-amazon.com/images/M/MV5BYjFjMTVhMjgtZmIwNy00MjExLWJkMjQtOTk3Y2M5OGI3NjgxXkEyXkFqcGc@._V1_.jpg", cast: "Prabhas, Amitabh Bachchan, Deepika Padukone", director: "Nag Ashwin", runtime: "2h 61m", language: "Telugu", availableOn: ["Netflix", "Prime Video"]),

        // Bollywood - Drama
        Movie(imdbId: "tt15428134", title: "12th Fail", year: 2023, genres: ["Drama"], rating: 9.2, summary: "The real-life story of IPS officer Manoj Kumar Sharma who despite numerous setbacks rose from a small village to crack one of the toughest exams in India.", posterURL: "https://m.media-amazon.com/images/M/MV5BYjUyOTYzMDAtOWRjNy00MDlhLTkxYTgtZTU1YTE2OWI5MzBiXkEyXkFqcGc@._V1_.jpg", cast: "Vikrant Massey, Medha Shankr", director: "Vidhu Vinod Chopra", runtime: "2h 27m", language: "Hindi", availableOn: ["Hotstar"]),

        Movie(imdbId: "tt5966426", title: "Dangal", year: 2016, genres: ["Action", "Drama"], rating: 8.3, summary: "Former wrestler Mahavir Singh Phogat trains his daughters Geeta and Babita to become India's first world-class female wrestlers.", posterURL: "https://m.media-amazon.com/images/M/MV5BMTQ4MzQzMzM2Nl5BMl5BanBnXkFtZTgwMTQ1NzU3MDI@._V1_.jpg", cast: "Aamir Khan, Fatima Sana Shaikh", director: "Nitesh Tiwari", runtime: "2h 41m", language: "Hindi", availableOn: ["Netflix", "Prime Video"]),

        Movie(imdbId: "tt0986264", title: "3 Idiots", year: 2009, genres: ["Comedy", "Drama"], rating: 8.4, summary: "Two friends search for their long-lost companion, recounting the days of their engineering college, where they challenged the conventional education system.", posterURL: "https://m.media-amazon.com/images/M/MV5BNTkyOGVjMGEtNmQzZi00NzFlLTlhOWQtODYyMDc2ZGJmYzFhXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_.jpg", cast: "Aamir Khan, Madhavan, Sharman Joshi", director: "Rajkumar Hirani", runtime: "2h 50m", language: "Hindi", availableOn: ["Netflix", "Prime Video"]),

        Movie(imdbId: "tt1187043", title: "PK", year: 2014, genres: ["Comedy", "Drama", "Sci-Fi"], rating: 8.1, summary: "An alien on Earth loses the remote control to his spaceship and must navigate Indian society and its religious dogma to find it.", posterURL: "https://m.media-amazon.com/images/M/MV5BMTYzOTE2NjkxN15BMl5BanBnXkFtZTgwMDgzMTg0MzE@._V1_.jpg", cast: "Aamir Khan, Anushka Sharma, Sushant Singh Rajput", director: "Rajkumar Hirani", runtime: "2h 33m", language: "Hindi", availableOn: ["Netflix", "ZEE5"]),

        Movie(imdbId: "tt6439020", title: "Tumbbad", year: 2018, genres: ["Drama", "Fantasy", "Horror"], rating: 8.2, summary: "A mythological story about a goddess who created the entire universe. The plot revolves around the consequences when humans defy the laws of nature.", posterURL: "https://m.media-amazon.com/images/M/MV5BMGE3NzQ1OGMtZTBhNi00NjI2LWIxZTAtMzk2NzUwYmVjZGFlXkEyXkFqcGc@._V1_.jpg", cast: "Sohum Shah, Jyoti Malshe", director: "Rahi Anil Barve", runtime: "1h 44m", language: "Hindi", availableOn: ["Prime Video", "Hotstar"]),

        Movie(imdbId: "tt8239946", title: "Gully Boy", year: 2019, genres: ["Drama", "Music"], rating: 7.9, summary: "A street rapper from the Mumbai slums rises to fame as he channels his anger and ambitions into his music.", posterURL: "https://m.media-amazon.com/images/M/MV5BZDkzMjU0YTctYmNhOS00MGJhLWJmZTMtYjE2YmNkNjgzNDI4XkEyXkFqcGc@._V1_.jpg", cast: "Ranveer Singh, Alia Bhatt", director: "Zoya Akhtar", runtime: "2h 34m", language: "Hindi", availableOn: ["Prime Video"]),

        Movie(imdbId: "tt12844910", title: "Stree 2", year: 2024, genres: ["Comedy", "Horror"], rating: 6.8, summary: "The residents of Chanderi face a new supernatural threat as the headless entity Sarkata terrorizes the town, and Stree must return to save them.", posterURL: "https://m.media-amazon.com/images/M/MV5BMGE4MmQ3ZmYtM2QzNC00MGUyLTkyOTEtOGM0YTU2ZjJjZDcxXkEyXkFqcGc@._V1_.jpg", cast: "Rajkummar Rao, Shraddha Kapoor, Pankaj Tripathi", director: "Amar Kaushik", runtime: "2h 30m", language: "Hindi", availableOn: ["Prime Video"]),

        // Tamil Cinema
        Movie(imdbId: "tt15671028", title: "Ponniyin Selvan: I", year: 2022, genres: ["Action", "Adventure", "Drama"], rating: 7.1, summary: "An adaptation of Kalki Krishnamurthy's epic novel set during the Chola dynasty, following the adventures of Vandiyathevan and the power struggles within the kingdom.", posterURL: "https://m.media-amazon.com/images/M/MV5BYWI0MzZlZWMtMmM2ZC00YWNjLWJlNTQtNWU2NDIzYzcxZTJlXkEyXkFqcGc@._V1_.jpg", cast: "Vikram, Aishwarya Rai, Karthi", director: "Mani Ratnam", runtime: "2h 47m", language: "Tamil", availableOn: ["Prime Video"]),

        Movie(imdbId: "tt9900782", title: "Jai Bhim", year: 2021, genres: ["Crime", "Drama"], rating: 8.7, summary: "When a tribal man is arrested and goes missing from police custody, a bold lawyer fights for justice against a corrupt system.", posterURL: "https://m.media-amazon.com/images/M/MV5BY2Y5ZWMwYmQtMTRmZi00ZjAxLWI1NTgtZWVmMmU1NGIxZjIwXkEyXkFqcGc@._V1_.jpg", cast: "Suriya, Lijo Mol Jose", director: "T.J. Gnanavel", runtime: "2h 44m", language: "Tamil", availableOn: ["Prime Video"]),

        Movie(imdbId: "tt11458058", title: "Vikram", year: 2022, genres: ["Action", "Crime", "Thriller"], rating: 7.6, summary: "A special agent investigates a case of serial murders while his past connects to the deadly underworld of drug lords.", posterURL: "https://m.media-amazon.com/images/M/MV5BOGRhNGNlMjAtNDQyMi00ZWYxLWJhYjEtNWM5MTFlNTNmNjgyXkEyXkFqcGc@._V1_.jpg", cast: "Kamal Haasan, Vijay Sethupathi, Fahadh Faasil", director: "Lokesh Kanagaraj", runtime: "2h 54m", language: "Tamil", availableOn: ["Hotstar"]),

        Movie(imdbId: "tt7019842", title: "Soorarai Pottru", year: 2020, genres: ["Drama"], rating: 8.3, summary: "Inspired by events in Air Deccan founder Captain Gopinath's life, a young man from a rural area dreams of launching an affordable airline for common people.", posterURL: "https://m.media-amazon.com/images/M/MV5BZmFhNjEzNjktZWI3Yy00NjI2LTk5NzEtMmRjNjA4NjczNTY2XkEyXkFqcGc@._V1_.jpg", cast: "Suriya, Aparna Balamurali", director: "Sudha Kongara", runtime: "2h 33m", language: "Tamil", availableOn: ["Prime Video"]),

        Movie(imdbId: "tt21044176", title: "GOAT", year: 2024, genres: ["Action", "Sci-Fi", "Thriller"], rating: 5.6, summary: "A retired special ops agent is pulled back into action when his past threatens his family, leading to a time-bending mission.", posterURL: "https://m.media-amazon.com/images/M/MV5BYjgwMTFjZGMtZjlkMS00MTU2LTk3YWMtNGM2OWZhNGExOTRiXkEyXkFqcGc@._V1_.jpg", cast: "Vijay, Prashanth, Prabhu Deva", director: "Venkat Prabhu", runtime: "2h 42m", language: "Tamil", availableOn: ["Netflix"]),

        Movie(imdbId: "tt27533560", title: "Amaran", year: 2024, genres: ["Action", "Drama", "War"], rating: 8.0, summary: "The true story of Major Mukund Varadarajan, a brave Indian Army officer who made the ultimate sacrifice in the line of duty in Kashmir.", posterURL: "https://m.media-amazon.com/images/M/MV5BZGJmZDgyM2ItMDE0Ni00NDhmLTkxOTAtZmI0MDk3MjdjMWZjXkEyXkFqcGc@._V1_.jpg", cast: "Sivakarthikeyan, Sai Pallavi", director: "Rajkumar Periasamy", runtime: "2h 49m", language: "Tamil", availableOn: ["Netflix"]),

        // Telugu Cinema
        Movie(imdbId: "tt6986890", title: "RRR", year: 2022, genres: ["Action", "Drama"], rating: 7.8, summary: "A tale of two legendary freedom fighters and their journey far away from home before they started fighting for their country in 1920s India.", posterURL: "https://m.media-amazon.com/images/M/MV5BOGEzYjgzMDQtNmIzNi00OTk0LTk4NzMtYjRjNGEzYmNkODMyXkEyXkFqcGc@._V1_.jpg", cast: "N.T. Rama Rao Jr., Ram Charan, Alia Bhatt", director: "S.S. Rajamouli", runtime: "3h 7m", language: "Telugu", availableOn: ["Netflix", "ZEE5"]),

        Movie(imdbId: "tt6139732", title: "Baahubali 2: The Conclusion", year: 2017, genres: ["Action", "Drama"], rating: 8.2, summary: "When Shiva, the son of Bahubali, learns about his heritage, he begins to look for answers. His story is intertwined with past events that unfolded in the Mahishmati Kingdom.", posterURL: "https://m.media-amazon.com/images/M/MV5BOGVhMTIxZDktNTdmOS00MTM1LWEwNTMtNGJhMjMxZjIwMTcxXkEyXkFqcGc@._V1_.jpg", cast: "Prabhas, Rana Daggubati, Anushka Shetty", director: "S.S. Rajamouli", runtime: "2h 47m", language: "Telugu", availableOn: ["Hotstar", "Netflix"]),

        Movie(imdbId: "tt14500448", title: "Pushpa: The Rise", year: 2021, genres: ["Action", "Crime", "Drama"], rating: 6.8, summary: "A laborer rises through the ranks of a red sandalwood smuggling syndicate, facing dangerous foes and building his criminal empire.", posterURL: "https://m.media-amazon.com/images/M/MV5BMjhjYWU2NjAtODIxYy00YTE4LTg2NjUtYmNhNjIyNGFlOTA5XkEyXkFqcGc@._V1_.jpg", cast: "Allu Arjun, Fahadh Faasil, Rashmika Mandanna", director: "Sukumar", runtime: "2h 59m", language: "Telugu", availableOn: ["Prime Video"]),

        Movie(imdbId: "tt26913798", title: "Pushpa 2: The Rule", year: 2024, genres: ["Action", "Crime", "Drama"], rating: 6.2, summary: "Pushpa Raj continues to dominate the sandalwood smuggling empire while facing new threats from a determined police officer and rival criminals.", posterURL: "https://m.media-amazon.com/images/M/MV5BOGM1ZjEzNzEtODE3Ni00MmVhLWI3ZTktOGI4MjA0ZjMxN2MzXkEyXkFqcGc@._V1_.jpg", cast: "Allu Arjun, Rashmika Mandanna, Fahadh Faasil", director: "Sukumar", runtime: "3h 20m", language: "Telugu", availableOn: ["Netflix"]),

        Movie(imdbId: "tt4154756", title: "Avengers: Infinity War", year: 2018, genres: ["Action", "Adventure", "Sci-Fi"], rating: 8.4, summary: "The Avengers and their allies must be willing to sacrifice all in an attempt to defeat the powerful Thanos before his blitz of devastation and ruin puts an end to the universe.", posterURL: "https://m.media-amazon.com/images/M/MV5BMjMxNjY2MDU1OV5BMl5BanBnXkFtZTgwNzY1MTUwNTM@._V1_.jpg", cast: "Robert Downey Jr., Chris Hemsworth, Mark Ruffalo", director: "Anthony Russo, Joe Russo", runtime: "2h 29m", language: "English", availableOn: ["Hotstar"]),

        Movie(imdbId: "tt4154796", title: "Avengers: Endgame", year: 2019, genres: ["Action", "Adventure", "Drama"], rating: 8.4, summary: "After the devastating events of Infinity War, the remaining Avengers assemble once more to reverse Thanos' actions and restore balance to the universe.", posterURL: "https://m.media-amazon.com/images/M/MV5BMTc5MDE2ODcwNV5BMl5BanBnXkFtZTgwMzI2NzQ2NzM@._V1_.jpg", cast: "Robert Downey Jr., Chris Evans, Mark Ruffalo", director: "Anthony Russo, Joe Russo", runtime: "3h 1m", language: "English", availableOn: ["Hotstar"]),

        Movie(imdbId: "tt1375666", title: "Inception", year: 2010, genres: ["Action", "Adventure", "Sci-Fi"], rating: 8.8, summary: "A thief who steals corporate secrets through dream-sharing technology is given the inverse task of planting an idea into the mind of a CEO.", posterURL: "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_.jpg", cast: "Leonardo DiCaprio, Joseph Gordon-Levitt, Elliot Page", director: "Christopher Nolan", runtime: "2h 28m", language: "English", availableOn: ["Netflix", "Prime Video"]),

        Movie(imdbId: "tt0468569", title: "The Dark Knight", year: 2008, genres: ["Action", "Crime", "Drama"], rating: 9.0, summary: "When the menace known as the Joker wreaks havoc on Gotham, Batman must accept one of the greatest psychological tests of his ability to fight injustice.", posterURL: "https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_.jpg", cast: "Christian Bale, Heath Ledger, Aaron Eckhart", director: "Christopher Nolan", runtime: "2h 32m", language: "English", availableOn: ["Netflix", "Prime Video"]),

        Movie(imdbId: "tt0111161", title: "The Shawshank Redemption", year: 1994, genres: ["Drama"], rating: 9.3, summary: "A banker convicted of uxoricide forms a friendship over a quarter century with a hardened convict, while maintaining his innocence and trying to remain hopeful through simple compassion.", posterURL: "https://m.media-amazon.com/images/M/MV5BMDAyY2FhYjctNDc5OS00MDNlLThiMGUtY2UxYWVkNGY2ZjljXkEyXkFqcGc@._V1_.jpg", cast: "Tim Robbins, Morgan Freeman", director: "Frank Darabont", runtime: "2h 22m", language: "English", availableOn: ["Prime Video"]),

        Movie(imdbId: "tt0816692", title: "Interstellar", year: 2014, genres: ["Adventure", "Drama", "Sci-Fi"], rating: 8.7, summary: "When Earth becomes uninhabitable in the future, a farmer and ex-NASA pilot is tasked to pilot a spacecraft, along with a team of researchers, to find a new planet for humans.", posterURL: "https://m.media-amazon.com/images/M/MV5BYzdjMDAxZGItMjI2My00ODA1LTlkNzItOWFjMDU5ZDJlYWY3XkEyXkFqcGc@._V1_.jpg", cast: "Matthew McConaughey, Anne Hathaway, Jessica Chastain", director: "Christopher Nolan", runtime: "2h 49m", language: "English", availableOn: ["Prime Video"]),

        Movie(imdbId: "tt1853728", title: "Django Unchained", year: 2012, genres: ["Drama", "Western"], rating: 8.5, summary: "With the help of a German bounty-hunter, a freed slave sets out to rescue his wife from a brutal plantation owner in Mississippi.", posterURL: "https://m.media-amazon.com/images/M/MV5BMjIyNTQ5NjQ1OV5BMl5BanBnXkFtZTcwODg1MDU4OA@@._V1_.jpg", cast: "Jamie Foxx, Christoph Waltz, Leonardo DiCaprio", director: "Quentin Tarantino", runtime: "2h 45m", language: "English", availableOn: ["Netflix", "SonyLIV"]),

        Movie(imdbId: "tt0120737", title: "The Lord of the Rings: The Fellowship of the Ring", year: 2001, genres: ["Action", "Adventure", "Drama"], rating: 8.9, summary: "A meek Hobbit from the Shire and eight companions set out on a journey to destroy the powerful One Ring and save Middle-earth from the Dark Lord Sauron.", posterURL: "https://m.media-amazon.com/images/M/MV5BNzIxMDQ2YTctNDY4MC00ZTRhLTk4ODQtMTVlOGY3NTVmNmQ4XkEyXkFqcGc@._V1_.jpg", cast: "Elijah Wood, Ian McKellen, Orlando Bloom", director: "Peter Jackson", runtime: "2h 58m", language: "English", availableOn: ["Prime Video"]),

        Movie(imdbId: "tt0137523", title: "Fight Club", year: 1999, genres: ["Drama"], rating: 8.8, summary: "An insomniac office worker and a devil-may-care soap maker form an underground fight club that evolves into much more.", posterURL: "https://m.media-amazon.com/images/M/MV5BOTgyOGQ1NDItNGU3Ny00MjU3LTg2YWEtNmEyYjBiMjI1Y2M5XkEyXkFqcGc@._V1_.jpg", cast: "Brad Pitt, Edward Norton, Helena Bonham Carter", director: "David Fincher", runtime: "2h 19m", language: "English", availableOn: ["Prime Video"]),

        Movie(imdbId: "tt0068646", title: "The Godfather", year: 1972, genres: ["Crime", "Drama"], rating: 9.2, summary: "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant youngest son.", posterURL: "https://m.media-amazon.com/images/M/MV5BYTJkNGQyZDgtZDQ0NC00MDM0LWEzZWQtYzUzZDEwMDljZWNjXkEyXkFqcGc@._V1_.jpg", cast: "Marlon Brando, Al Pacino, James Caan", director: "Francis Ford Coppola", runtime: "2h 55m", language: "English", availableOn: ["Netflix", "Lionsgate Play"]),

        Movie(imdbId: "tt0109830", title: "Forrest Gump", year: 1994, genres: ["Drama", "Romance"], rating: 8.8, summary: "The history of the United States from the 1950s to the '70s unfolds from the perspective of an Alabama man with a low IQ who yearns to be reunited with his childhood sweetheart.", posterURL: "https://m.media-amazon.com/images/M/MV5BNWIwODRlZTUtY2U3ZS00Yzg1LWJhNzYtMmZiYmEyNjU1NjMzXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_.jpg", cast: "Tom Hanks, Robin Wright, Gary Sinise", director: "Robert Zemeckis", runtime: "2h 22m", language: "English", availableOn: ["Netflix", "Prime Video"]),

        Movie(imdbId: "tt6263850", title: "The Family Man", year: 2019, genres: ["Action", "Drama", "Thriller"], rating: 8.6, summary: "A middle-class man who secretly works as an intelligence officer for a wing of the National Intelligence Agency balances his duty and family life.", posterURL: "https://m.media-amazon.com/images/M/MV5BNmQ0NmZkNGItMWFkZC00MTZkLThmZWItYmFkMjk2YWVjNGE1XkEyXkFqcGc@._V1_.jpg", cast: "Manoj Bajpayee, Priyamani, Sharib Hashmi", director: "Raj & DK", runtime: "TV Series", language: "Hindi", availableOn: ["Prime Video"]),

        Movie(imdbId: "tt11315808", title: "Mirzapur", year: 2018, genres: ["Action", "Crime", "Thriller"], rating: 8.3, summary: "A shocking incident at a wedding ignites a series of events entangling the lives of two families in the lawless city of Mirzapur.", posterURL: "https://m.media-amazon.com/images/M/MV5BNjI4OTQxYTUtMGIxMS00YjRkLTlkMjAtMGRiMjM3ZWI2NjJjXkEyXkFqcGc@._V1_.jpg", cast: "Pankaj Tripathi, Ali Fazal, Divyenndu", director: "Karan Anshuman", runtime: "TV Series", language: "Hindi", availableOn: ["Prime Video"]),

        Movie(imdbId: "tt12392504", title: "Scam 1992", year: 2020, genres: ["Crime", "Drama"], rating: 9.3, summary: "The story of Harshad Mehta, a stockbroker who single-handedly took the stock market to dizzying heights and his catastrophic downfall.", posterURL: "https://m.media-amazon.com/images/M/MV5BNjgxZmE0YzctNGQ4OC00ZWNhLWJiYzQtMTU0MTFkYTBjZmJjXkEyXkFqcGc@._V1_.jpg", cast: "Pratik Gandhi, Shreya Dhanwanthary", director: "Hansal Mehta", runtime: "TV Series", language: "Hindi", availableOn: ["SonyLIV"]),

        Movie(imdbId: "tt13406036", title: "Panchayat", year: 2020, genres: ["Comedy", "Drama"], rating: 8.8, summary: "An engineering graduate reluctantly takes up a job as secretary of a village panchayat office and discovers the quirky dynamics of rural India.", posterURL: "https://m.media-amazon.com/images/M/MV5BMDk2MDJhMjctOWNjMi00NWQ5LWI3YTgtNmJlYzc5OGVkNWFiXkEyXkFqcGc@._V1_.jpg", cast: "Jitendra Kumar, Raghubir Yadav, Neena Gupta", director: "Deepak Kumar Mishra", runtime: "TV Series", language: "Hindi", availableOn: ["Prime Video"]),

        // Telugu OTT
        Movie(imdbId: "tt11458058", title: "HIT: The First Case", year: 2020, genres: ["Crime", "Mystery", "Thriller"], rating: 7.3, summary: "A cop who is suffering from PTSD takes on a missing person case and must battle his inner demons to solve a gripping mystery.", posterURL: "https://m.media-amazon.com/images/M/MV5BOWJjMWNhMzAtNjFiMS00M2NjLWE3NzctMTc3MWIzNjZiMjk0XkEyXkFqcGc@._V1_.jpg", cast: "Vishwak Sen, Ruhani Sharma", director: "Sailesh Kolanu", runtime: "2h 11m", language: "Telugu", availableOn: ["aha", "Prime Video"]),

        Movie(imdbId: "tt14826022", title: "Bimbisara", year: 2022, genres: ["Action", "Fantasy"], rating: 6.7, summary: "A ruthless ancient king is transported to the modern world through a magical portal and must adapt to contemporary society while seeking to regain his kingdom.", posterURL: "https://m.media-amazon.com/images/M/MV5BZmNiNjg2NTYtODk3My00NjlmLWIwMzctYWJlNjhkMGUzMzBmXkEyXkFqcGc@._V1_.jpg", cast: "Nandamuri Kalyan Ram, Catherine Tresa", director: "Vassishta", runtime: "2h 28m", language: "Telugu", availableOn: ["aha", "ZEE5"]),

        // Malayalam Cinema
        Movie(imdbId: "tt9900644", title: "Drishyam 2", year: 2021, genres: ["Crime", "Drama", "Thriller"], rating: 8.3, summary: "Georgekutty and his family face a new crisis when the investigation into the missing police officer intensifies six years later.", posterURL: "https://m.media-amazon.com/images/M/MV5BYjU0NDg0MjUtYmQyZi00ZmJhLTg1YWQtMWE0MjA5NzVmMjRjXkEyXkFqcGc@._V1_.jpg", cast: "Mohanlal, Meena, Ansiba Hassan", director: "Jeethu Joseph", runtime: "2h 32m", language: "Malayalam", availableOn: ["Prime Video"]),

        Movie(imdbId: "tt17526714", title: "Manjummel Boys", year: 2024, genres: ["Adventure", "Drama", "Thriller"], rating: 8.4, summary: "Based on a true incident where a group of friends from Manjummel travel to Kodaikanal on a trip that turns into a nightmare when one of them gets trapped in Guna Caves.", posterURL: "https://m.media-amazon.com/images/M/MV5BNDNlYzRlN2UtNjk2YS00OGFiLWFhZTktZjg3YzFiNzFlMzM2XkEyXkFqcGc@._V1_.jpg", cast: "Soubin Shahir, Sreenath Bhasi, Balu Varghese", director: "Chidambaram", runtime: "2h 16m", language: "Malayalam", availableOn: ["Hotstar"]),

        // Kannada
        Movie(imdbId: "tt9179438", title: "KGF: Chapter 2", year: 2022, genres: ["Action", "Crime", "Drama"], rating: 7.4, summary: "In the blood-soaked Kolar Gold Fields, Rocky's name strikes fear as he becomes the most dangerous man, while enemies from his past and powerful forces converge against him.", posterURL: "https://m.media-amazon.com/images/M/MV5BNzNhNjEyMmQtYmI2Ny00NjliLWJhMzItMjQyY2NhYzM2NTYzXkEyXkFqcGc@._V1_.jpg", cast: "Yash, Sanjay Dutt, Raveena Tandon", director: "Prashanth Neel", runtime: "2h 48m", language: "Kannada", availableOn: ["Prime Video"]),

        // More Hollywood on Indian OTTs
        Movie(imdbId: "tt1160419", title: "Dune", year: 2021, genres: ["Action", "Adventure", "Drama"], rating: 8.0, summary: "Paul Atreides, a brilliant and gifted young man born into a great destiny beyond his understanding, must travel to the most dangerous planet in the universe to ensure the future of his family and his people.", posterURL: "https://m.media-amazon.com/images/M/MV5BN2FjNmEyNWMtYzM0ZS00NjIyLTg5YzYtYThlMGVjNzE1OGViXkEyXkFqcGc@._V1_.jpg", cast: "Timothee Chalamet, Rebecca Ferguson, Zendaya", director: "Denis Villeneuve", runtime: "2h 35m", language: "English", availableOn: ["Netflix"]),

        Movie(imdbId: "tt15398776", title: "Oppenheimer", year: 2023, genres: ["Drama", "History"], rating: 8.3, summary: "The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb during World War II.", posterURL: "https://m.media-amazon.com/images/M/MV5BN2JkMDc5MGQtZjg3YS00NmFiLWIyZjAtNDQ0NDNlNzY0MWRhXkEyXkFqcGc@._V1_.jpg", cast: "Cillian Murphy, Emily Blunt, Robert Downey Jr.", director: "Christopher Nolan", runtime: "3h", language: "English", availableOn: ["Prime Video"]),

        Movie(imdbId: "tt1745960", title: "Top Gun: Maverick", year: 2022, genres: ["Action", "Drama"], rating: 8.2, summary: "After thirty years of service, Pete 'Maverick' Mitchell is called back to train a group of Top Gun graduates for a specialized mission, confronting ghosts of the past.", posterURL: "https://m.media-amazon.com/images/M/MV5BZWYzOGEwNTgtNWU3NS00ZTQ0LWJkODUtMmVhMjIwMjA1ZmQwXkEyXkFqcGc@._V1_.jpg", cast: "Tom Cruise, Jennifer Connelly, Miles Teller", director: "Joseph Kosinski", runtime: "2h 11m", language: "English", availableOn: ["Prime Video"]),

        Movie(imdbId: "tt14539740", title: "The Batman", year: 2022, genres: ["Action", "Crime", "Drama"], rating: 7.8, summary: "When a sadistic serial killer begins murdering key political figures in Gotham, Batman is forced to investigate the city's hidden corruption.", posterURL: "https://m.media-amazon.com/images/M/MV5BMmU5NGJlMzAtMGNmOC00YjJjLTgyMzEtNjAyYmE3OWIxMGM2XkEyXkFqcGc@._V1_.jpg", cast: "Robert Pattinson, Zoe Kravitz, Paul Dano", director: "Matt Reeves", runtime: "2h 56m", language: "English", availableOn: ["Prime Video"]),

        Movie(imdbId: "tt1517268", title: "Barbie", year: 2023, genres: ["Adventure", "Comedy", "Fantasy"], rating: 6.8, summary: "Barbie and Ken leave the utopia of Barbieland for the real world, where they discover the joys and perils of living among humans.", posterURL: "https://m.media-amazon.com/images/M/MV5BNjU3N2QxNzYtMjk1NC00MTc4LTk1NTQtMmUxNTljM2I0NDA5XkEyXkFqcGc@._V1_.jpg", cast: "Margot Robbie, Ryan Gosling, America Ferrera", director: "Greta Gerwig", runtime: "1h 54m", language: "English", availableOn: ["Prime Video"]),

        Movie(imdbId: "tt6751668", title: "Parasite", year: 2019, genres: ["Comedy", "Drama", "Thriller"], rating: 8.5, summary: "Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park family and the destitute Kim clan.", posterURL: "https://m.media-amazon.com/images/M/MV5BYjk1Y2U4MjQtY2ZiNS00OWQyLWI3MmYtZWUwNmRjYWRiNWNhXkEyXkFqcGc@._V1_.jpg", cast: "Song Kang-ho, Lee Sun-kyun, Cho Yeo-jeong", director: "Bong Joon Ho", runtime: "2h 12m", language: "Korean", availableOn: ["Prime Video"]),

        // ZEE5 / SonyLIV specific
        Movie(imdbId: "tt13370252", title: "Rocket Boys", year: 2022, genres: ["Drama", "History"], rating: 8.7, summary: "The extraordinary story of two great Indian scientists Homi Bhabha and Vikram Sarabhai who laid the foundation for modern scientific India.", posterURL: "https://m.media-amazon.com/images/M/MV5BNzA3YzYzODAtYzgyMS00OGNjLTgzZDUtMTI4NTkzMTMxMjFjXkEyXkFqcGc@._V1_.jpg", cast: "Jim Sarbh, Ishwak Singh", director: "Abhay Pannu", runtime: "TV Series", language: "Hindi", availableOn: ["SonyLIV"]),

        Movie(imdbId: "tt15260732", title: "Maharani", year: 2021, genres: ["Drama", "Thriller"], rating: 7.8, summary: "A housewife is catapulted into the position of Chief Minister of Bihar when her politician husband hands her the reins of power as a political ploy.", posterURL: "https://m.media-amazon.com/images/M/MV5BYTYxOGQ1NjctYTdkOC00NDc0LThkMGEtZDAxOWUzMGVlNjNiXkEyXkFqcGc@._V1_.jpg", cast: "Huma Qureshi, Sohum Shah", director: "Subhash Kapoor", runtime: "TV Series", language: "Hindi", availableOn: ["SonyLIV"]),

        Movie(imdbId: "tt11247158", title: "Abhay", year: 2019, genres: ["Crime", "Thriller"], rating: 7.5, summary: "An investigating officer with an unconventional approach solves dark and gritty crimes inspired by true events across India.", posterURL: "https://m.media-amazon.com/images/M/MV5BYTQwYzVmMzctOTM5ZC00YmY2LWE1OTAtMmI5OWQ2ZjI5ZmZmXkEyXkFqcGc@._V1_.jpg", cast: "Kunal Kemmu, Ram Kapoor", director: "Ken Ghosh", runtime: "TV Series", language: "Hindi", availableOn: ["ZEE5"]),

        Movie(imdbId: "tt21441568", title: "Duranga", year: 2022, genres: ["Crime", "Mystery", "Thriller"], rating: 7.1, summary: "When a wife discovers her husband's dark past filled with serial murders, she must decide between love and justice.", posterURL: "https://m.media-amazon.com/images/M/MV5BZjlhMGZmYjMtODcyMi00M2NjLTkxMDYtMWQ3MDllYmM0MzEwXkEyXkFqcGc@._V1_.jpg", cast: "Drashti Dhami, Amit Sadh, Gulshan Devaiah", director: "Pradeep Sarkar", runtime: "TV Series", language: "Hindi", availableOn: ["ZEE5"]),

        // Lionsgate Play
        Movie(imdbId: "tt1431045", title: "Deadpool", year: 2016, genres: ["Action", "Adventure", "Comedy"], rating: 8.0, summary: "A former Special Forces operative turned mercenary is subjected to a rogue experiment that leaves him with accelerated healing powers.", posterURL: "https://m.media-amazon.com/images/M/MV5BYzE5MjY1ZDgtMTkyNC00MTMyLThhMjAtZGI5OTE1NzFlZGJjXkEyXkFqcGdeQXVyNjU0OTQ0OTY@._V1_.jpg", cast: "Ryan Reynolds, Morena Baccarin, T.J. Miller", director: "Tim Miller", runtime: "1h 48m", language: "English", availableOn: ["Lionsgate Play"]),

        Movie(imdbId: "tt1170358", title: "The Hunger Games", year: 2012, genres: ["Action", "Adventure", "Sci-Fi"], rating: 7.2, summary: "Katniss Everdeen voluntarily takes her younger sister's place in the Hunger Games: a nationally televised fight to the death.", posterURL: "https://m.media-amazon.com/images/M/MV5BMjA4NDg3NzYxMF5BMl5BanBnXkFtZTcwNTgyNzkyNw@@._V1_.jpg", cast: "Jennifer Lawrence, Josh Hutcherson, Liam Hemsworth", director: "Gary Ross", runtime: "2h 22m", language: "English", availableOn: ["Lionsgate Play"]),

        Movie(imdbId: "tt0110912", title: "Pulp Fiction", year: 1994, genres: ["Crime", "Drama"], rating: 8.9, summary: "The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.", posterURL: "https://m.media-amazon.com/images/M/MV5BYTViYTE3ZGQtNDBlMC00ZTAyLTkyODMtZGRiZDg0MjA2YThkXkEyXkFqcGc@._V1_.jpg", cast: "John Travolta, Uma Thurman, Samuel L. Jackson", director: "Quentin Tarantino", runtime: "2h 34m", language: "English", availableOn: ["Lionsgate Play", "Prime Video"]),

        Movie(imdbId: "tt0167260", title: "The Lord of the Rings: The Return of the King", year: 2003, genres: ["Action", "Adventure", "Drama"], rating: 9.0, summary: "Gandalf and Aragorn lead the World of Men against Sauron's army to draw his gaze from Frodo and Sam as they approach Mount Doom with the One Ring.", posterURL: "https://m.media-amazon.com/images/M/MV5BNzA5ZDNlZWMtM2NhNS00NDJjLTk4NDItYTRmY2EwMWZlZjY3XkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_.jpg", cast: "Elijah Wood, Viggo Mortensen, Ian McKellen", director: "Peter Jackson", runtime: "3h 21m", language: "English", availableOn: ["Prime Video"]),

        // aha specific
        Movie(imdbId: "tt15005956", title: "Colour Photo", year: 2020, genres: ["Drama", "Romance"], rating: 7.5, summary: "A dark-skinned young man falls in love with a fair-skinned woman, leading to societal challenges and discrimination in a small Telugu town.", posterURL: "https://m.media-amazon.com/images/M/MV5BNGFmNjQ3MWUtMTFiMS00OTk3LWI3NzUtZDcwZmQzNTBjZWRhXkEyXkFqcGc@._V1_.jpg", cast: "Suhas, Chandini Chowdary", director: "Sandeep Raj", runtime: "2h 10m", language: "Telugu", availableOn: ["aha"]),

        Movie(imdbId: "tt13160168", title: "SR Kalyanamandapam", year: 2021, genres: ["Comedy", "Drama"], rating: 6.3, summary: "A man who runs a wedding hall navigates romantic complications and family drama while trying to keep his business afloat.", posterURL: "https://m.media-amazon.com/images/M/MV5BOGYwMDE1NjgtODNlOS00NWJjLTk4OTQtOTdlY2NiYWZkMWE0XkEyXkFqcGc@._V1_.jpg", cast: "Kiran Abbavaram, Priyanka Jawalkar", director: "Sridhar Gade", runtime: "2h 11m", language: "Telugu", availableOn: ["aha"]),
    ]
}
