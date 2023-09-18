//
//  RxExtensions.swift
//  giphy-ios
//
//  Created by DavisZ on 14/09/2023.
//

import RxSwift

extension Single where Element: Any {
    func monitorExecution(on subject: BehaviorSubject<Bool>) -> Single<Element> {
        return (self as! Single<Element>).do(
            onSuccess:{ _ in subject.onNext(false) },
            onError: { _ in subject.onNext(false) },
            onSubscribe:{ subject.onNext(true) },
            onDispose:{ subject.onNext(false) }
        )
    }
}

extension Completable {
    func monitorExecution(on subject: BehaviorSubject<Bool>) -> Completable {
        return self.do(
            onError: { _ in subject.onNext(false) },
            onCompleted:{ subject.onNext(false) },
            onSubscribe:{ subject.onNext(true) },
            onDispose:{ subject.onNext(false) }
        )
    }
}

extension Observable where Element: Any {
    func monitorExecution(on subject: BehaviorSubject<Bool>) -> Observable<Element> {
        return (self as Observable<Element>).do(
            onError: { _ in subject.onNext(false) },
            onCompleted:{ subject.onNext(false) },
            onSubscribe:{ subject.onNext(true) },
            onDispose:{ subject.onNext(false) }
        )
    }
}
