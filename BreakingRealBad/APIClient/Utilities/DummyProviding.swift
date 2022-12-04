import Foundation

protocol DummyProviding {
    associatedtype ResponseObject: Decodable
    static func dummy() -> Data
    static func fixture() -> ResponseObject
}

extension DummyProviding {
    static func dummy() -> Data {
        let url = Bundle.main.url(forResource: String(describing: self), withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static func fixture() -> ResponseObject {
        let data = dummy()
        return try! JSONDecoder().decode(ResponseObject.self, from: data)
    }
}

extension FetchCharactersRequest: DummyProviding {}
extension FetchCharacterQuotesRequest: DummyProviding {}
