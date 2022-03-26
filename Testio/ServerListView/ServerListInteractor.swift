import RxSwift
protocol ServerListInteractor {
    func getServersFromCache() -> Observable<Async<Any>>
    func getServersFromApi(input: TokenModel) -> Observable<Async<Any>>
}
