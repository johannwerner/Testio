import RxSwift
protocol ServerListInteractor {
    func fetchServersFromCache() -> Observable<Async<Any>>
    func fetchServersFromApi(input: TokenModel) -> Observable<Async<Any>>
}
