import RxSwift
protocol ServerListInteractor {
    func getServers() -> Observable<Async<Any>>
}
