//
//  ViewController.swift
//  CCRxSwiftDemo
//
//  Created by CC on 2020/10/26.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    func test() {
        
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

