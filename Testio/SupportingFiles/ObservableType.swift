import RxSwift

extension ObservableType {
    public func async() -> Observable<Async<Element>> {
        map {
            Async.success($0)
        }
        .catch { error in
            Observable.just(Async.error(error))
        }
        .do(onCompleted: {
        })
        .startWith(Async.loading)
    }
}
