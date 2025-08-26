import Foundation

class FormatsDataLoader {
    enum LoaderError: Error {
        case fileNotFound
        case decodingError
    }
    
    func loadFormats() throws -> [GolfFormat] {
        guard let url = Bundle.main.url(forResource: "formats", withExtension: "json") else {
            throw LoaderError.fileNotFound
        }
        
        let data = try Data(contentsOf: url)
        let formatsData = try JSONDecoder().decode(FormatsData.self, from: data)
        
        return formatsData.formats
    }
    
    func loadFormatsAsync() async throws -> [GolfFormat] {
        guard let url = Bundle.main.url(forResource: "formats", withExtension: "json") else {
            throw LoaderError.fileNotFound
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let formatsData = try JSONDecoder().decode(FormatsData.self, from: data)
        
        return formatsData.formats
    }
}