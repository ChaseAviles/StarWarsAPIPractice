import UIKit

struct Person: Decodable {
    var name: String
    var films: [URL]
}

struct Film: Decodable {
    var title: String
    var opening_crawl: String
    var release_date: String
}

class SwapiService: Decodable {
    
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        
        guard let baseURL = baseURL else { return completion(nil) }
        
        let finalURL = baseURL.appendingPathComponent("people/\(id)")
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil) }
        
            do{
                let person = try JSONDecoder().decode(Person.self, from: data)
                return completion(person)
            }catch{
                print(error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil) }
            
            do{
                let film = try JSONDecoder().decode(Film.self, from: data)
                return completion(film)
            }catch {
                print(error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
}


func fetchFilm(url: URL) {
  SwapiService.fetchFilm(url: url) { film in
      if let film = film {
        print(film.title)
      }
  }
}

SwapiService.fetchPerson(id: 2) { (person) in
    if let person = person {
        print(person.name)
        for film in person.films {
            fetchFilm(url: film)
        }
    }
}
