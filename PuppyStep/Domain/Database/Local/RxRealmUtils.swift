//
//  RxRealmUtils.swift
//  PuppyStep
//
//  Created by Sergey on 11/2/20.
//

import Foundation
import RealmSwift
import RxCocoa
import RxSwift

extension Realm: ReactiveCompatible {}

extension Reactive where Base == Realm {
    
    public func addData(_ data: Object) -> Single<Void> {
        return Single.create { single in
            do {
                try
                    self.base.write {
                        self.base.add(data)
                        single(.success(()))
                    }
            } catch let e {
                single(.error(e))
            }
            return Disposables.create()
        }
    }
    
    public func removeData(_ data: Object) -> Single<Void> {
        return Single<Void>.create { single in
            let dog = data as! DogDBO
            do {
                let predicate = NSPredicate(format: "name == %@", dog.name)
                if let removable = self.base.objects(DogDBO.self).filter(predicate).first {
                    try self.base.write {
                        self.base.delete(removable)
                        single(.success(()))
                    }
                }

//                try self.base.write {
//                    self.base.delete(data)
//                    single(.success(()))
//                }
            } catch let e {
                single(.error(e))
            }
            return Disposables.create()
        }
    }
    
    public func getData() -> Single<Object?> {
        return Single<Object?>.create { single in
            do {
                try self.base.write {
                    let data = self.base.objects(DogDBO.self).first
                    single(.success(data))
                }
            } catch let e {
                single(.error(e))
            }
            return Disposables.create()
        }
    }
}
