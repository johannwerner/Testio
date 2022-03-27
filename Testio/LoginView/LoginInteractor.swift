import RxSwift
protocol LoginInteractor {
    func loginUser(input: LoginInputModel) -> Observable<Async<Any>>
    func fetchServers(input: TokenModel) -> Observable<Async<Any>>
}
