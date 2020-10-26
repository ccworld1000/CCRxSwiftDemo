//
//  ViewController.swift
//  CCRxSwiftDemo
//
//  Created by CC on 2020/10/26.
//

import UIKit
import RxSwift
import RxCocoa

//extension ObservableType {
////    func myMap<R>(transform: @escaping (E) -> R) -> Observable<R> {
//    func myMap<R>(transform: @escaping (E) -> R) -> Observable<R> {
//        return Observable.create { observer in
//            let subscription = self.subscribe { e in
//                    switch e {
//                    case .next(let value):
//                        let result = transform(value)
//                        observer.on(.next(result))
//                    case .error(let error):
//                        observer.on(.error(error))
//                    case .completed:
//                        observer.on(.completed)
//                    }
//                }
//
//            return subscription
//        }
//    }
//}

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    func test() {
        NotificationCenter.default.rx
            .notification(UIScene.willEnterForegroundNotification)
            .subscribe { (notification) in
                print("Application Will Enter Foreground")
            }
//            onError: { (<#Error#>) in
//                <#code#>
//            } onCompleted: {
//                <#code#>
//            } onDisposed: {
//                <#code#>
//            }

        
    }
    
    func test12() {
        button.rx.tap.subscribe(onNext: {
            print("button Tapped")
        })
//        .disposed(by: DisposeBag())
    }
    
    func test11() {
        button.rx.tap.subscribe(onNext: {
            print("button Tapped")
        })
//        .dispose()
    }
    
    func test10() {
        button.rx.tap.subscribe { (e) in
            print(e)
        }
    }
    
    func test9() {
        let subscription = myInterval(.milliseconds(100))
            .debug("my probe")
            .map { e in
                return "This is simply \(e)"
            }
            .subscribe(onNext: { n in
                print(n)
            })

//        Thread.sleep(forTimeInterval: 0.5)
        Thread.sleep(forTimeInterval: 1.5)

        subscription.dispose()
    }
    
    func test8() {
//        extension ObservableType {
//            func myMap<R>(transform: @escaping (E) -> R) -> Observable<R> {
//                return Observable.create { observer in
//                    let subscription = self.subscribe { e in
//                            switch e {
//                            case .next(let value):
//                                let result = transform(value)
//                                observer.on(.next(result))
//                            case .error(let error):
//                                observer.on(.error(error))
//                            case .completed:
//                                observer.on(.completed)
//                            }
//                        }
//
//                    return subscription
//                }
//            }
//        }
        
//        let subscription = myInterval(.milliseconds(100))
//            .myMap { e in
//                return "This is simply \(e)"
//            }
//            .subscribe(onNext: { n in
//                print(n)
//            })
        
//        let subscription = myInterval(.milliseconds(100))
//            .myMap { e in
//                return "This is simply \(e)"
//            }
//            .subscribe(onNext: { n in
//                print(n)
//            })
        
    }
    
    func test7() {
        let counter = myInterval(.milliseconds(100))
            .share(replay: 1)
        
        print("Started ----")
        let subscription1 = counter.subscribe { (n) in
            print("First \(n)")
        }
        
        let subscription2 = counter.subscribe { (n) in
            print("Second \(n)")
        }
        
        Thread.sleep(forTimeInterval: 0.5)

        subscription1.dispose()

        Thread.sleep(forTimeInterval: 0.5)

        subscription2.dispose()

        print("Ended ----")
    }
    
    func myInterval(_ interval: DispatchTimeInterval) -> Observable<Int> {
        return Observable.create { (observer) in
            print("Subscribed")
            let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
            timer.schedule(deadline: DispatchTime.now() + interval, repeating: interval)
            
            let cancel = Disposables.create {
                print("Disposed")
                timer.cancel()
            }
            
            var next = 0
            timer.setEventHandler {
                if cancel.isDisposed {
                    return
                }
                
                observer.on(.next(next))
                next += 1
            }
            
            timer.resume()
            
            return cancel
        }
    }
    
    func test6() {
        let counter = myInterval(.milliseconds(100))

        print("Started ----")

        let subscription1 = counter
            .subscribe(onNext: { n in
                print("First \(n)")
            })
            
        print("Subscribed")

        let subscription2 = counter
            .subscribe(onNext: { n in
                print("Second \(n)")
            })
            
        print("Subscribed")

        Thread.sleep(forTimeInterval: 0.5)

        subscription1.dispose()

        print("Disposed")

        Thread.sleep(forTimeInterval: 0.5)

        subscription2.dispose()

        print("Disposed")

        print("Ended ----")
    }
    
    
    func test5() {
        let counter = myInterval(.milliseconds(100))

        print("Started ----")
        let subscription = counter.subscribe { (n) in
            print(n)
        }
        
        Thread.sleep(forTimeInterval: 0.5)
        subscription.dispose()
        
        print("Ended ----")
    }
    
    func myFrom<E>(_ sequence: [E]) -> Observable<E> {
        return Observable.create { (observer) -> Disposable in
            for element in sequence {
                observer.on(.next(element))
            }
            
            observer.on(.completed)
            
            return Disposables.create()
        }
    }
    
    func test4() {
        let stringCounter = myFrom(["first", "second"])
        
        print("Started ------------")
        
        stringCounter.subscribe { (n) in
            print(n)
        }
        
        print("----")
        
        stringCounter.subscribe { (n) in
            print(n)
        }
        
        print("Ended ------------")
    }
    
    func myJust<E>(_ element: E) -> Observable<E> {
        return Observable.create { (observer) -> Disposable in
            observer.on(.next(element))
            observer.on(.completed)
            
            return Disposables.create()
        }
    }
    
    func test3() {
        myJust(0).subscribe { (e) in
            print(e)
        }
    }
    
    func test2() {
        print("------------1")
        let scheduler = SerialDispatchQueueScheduler(qos: .default)
        let subscription = Observable<Int>.interval(.milliseconds(300), scheduler: scheduler)
            .observe(on: MainScheduler.instance)
            .subscribe { event in
            print(event)
        }
        
        Thread.sleep(forTimeInterval: 2.0)
        subscription.dispose()
        print("------------2")
    }
    
    func test1() {
        let scheduler = SerialDispatchQueueScheduler(qos: .default)
        let subscription = Observable<Int>.interval(.milliseconds(300), scheduler: scheduler).subscribe { event in
            print(event)
        }
        
        Thread.sleep(forTimeInterval: 2.0)
        subscription.dispose()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        test()
    }
}

