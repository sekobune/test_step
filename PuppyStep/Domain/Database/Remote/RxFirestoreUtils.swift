//
//  CollectionReference.swift
//  PuppyStep
//
//  Created by Sergey on 11/2/20.
//

import RxCocoa
import RxSwift
import FirebaseFirestore

extension Reactive where Base: Query {
    
    public func getDocuments() -> Observable<QuerySnapshot> {
        return Observable<QuerySnapshot>.create { observer in
            self.base.getDocuments { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let snapshot = snapshot {
                    observer.onNext(snapshot)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

extension Reactive where Base: DocumentReference {
    
    public func setData(_ documentData: [String: Any]) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.base.setData(documentData) { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    public func delete() -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.base.delete { error in
                guard let error = error else {
                    observer.onNext(())
                    observer.onCompleted()
                    return
                }
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
