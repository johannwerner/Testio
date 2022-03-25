import RxSwift
protocol LoginInteractor {
    func loginUser(input: LoginInputModel) -> Observable<Async<Any>>
    func getServers(input: TokenModel) -> Observable<Async<Any>>
}
