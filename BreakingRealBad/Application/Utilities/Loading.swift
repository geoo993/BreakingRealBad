import Foundation
enum Loading<T: Equatable>: Equatable {
    case idle
    case error(AnyError)
    case loading(previous: T? = nil)
    case loaded(T)
    
    var error: AnyError? {
        guard case let .error(error) = self else { return nil }
        return error
    }
    
    var loaded: T? {
        guard case let .loaded(value) = self else { return nil }
        return value
    }
    
    var isLoading: Bool {
        guard case .loading = self else { return false }
        return true
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case let (.error(left), .error(right)):
            return left == right
        case let (.loaded(left), .loaded(right)):
            return left == right
        case let (.loading(left), .loading(right)):
            return left == right
        case (.idle, _),
            (.error, _),
            (.loaded, _),
            (.loading, _):
            return false
        }
    }
    
    static func from<E: Error>(result: Result<T, E>) -> Self {
        switch result {
        case let .success(value):
            return .loaded(value)
        case let .failure(error):
            return .error(AnyError(error))
        }
    }
}
