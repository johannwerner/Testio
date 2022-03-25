public enum Async<T> {
    case loading
    case success(T)
    case error(Error)
}
