//
//  PhotoCheckRX.swift
//  PhotoBrowser
//
//  Created by zf on 2019/2/11.
//  Copyright © 2019 zf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


struct student {
    var score: Variable<Double>
}

class PhotoCheckRX: UIViewController {

    @IBOutlet weak var searchNameBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    fileprivate lazy var bag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //test1()
        //test2()
        //test3()
        
        initTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    
    func initTableView() {
        
        let bookVModel = AddressesViewModel()
        bookVModel.address.asObservable().bind(to: tableView.rx.items(cellIdentifier: "NameCellID", cellType:  UITableViewCell.self)){
            (row: Int, address: AddressBook, cell: UITableViewCell) in
            
            cell.textLabel?.text = address.name
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(AddressBook.self).subscribe { (event: Event<AddressBook>) in
            
            if event.element?.name == "a3" {
                bookVModel.addAddress(name: "a8")
            }
        }.disposed(by: bag)
        
        let arrays = bookVModel.address.value
        
        
        self.searchNameBar.rx.text.orEmpty.flatMapLatest({ (str: String) -> Observable<[AddressBook]> in
            
            if str.isEmpty {
                
                return Observable.just(arrays)
            }else{
                
                let array = bookVModel.address.value.filter({ (book: AddressBook) -> Bool in
                    
                    return book.name.contains(str)
                })
                
                dPrint(item: "search : \(array)")
                return Observable.just(array)
            }
            
        }).subscribe(onNext: { (books:[AddressBook]) in
            bookVModel.address.value = books
        }).disposed(by: bag)
        
        
    }

}


extension PhotoCheckRX {
    
    fileprivate func createObservable() -> Observable<Any> {
        
        return Observable.create { (observer: AnyObserver<Any>) -> Disposable in
         
            observer.onNext("c1")
            observer.onNext("c2")
            observer.onNext("cc")
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}


extension PhotoCheckRX {
    fileprivate func test1() {
        //rxswift 常用操作
        //1.never sequence(/'sikwəns/)事件  后续的监听事件不会触发
        let neverO = Observable<String>.never()
        neverO.subscribe { (event: Event<String>) in
            
            dPrint(item: event) //不会打印
            }.disposed(by: bag)
        
        //2.empty
        let emptyO = Observable<String>.empty()
        emptyO.subscribe { (event: Event<String>) in
            dPrint(item: "empty:\(event)") //打印empty:completed
            dPrint(item: "empty2:\(String(describing: event.element))")
            }.disposed(by: bag)
        
        //3.just
        let justO = Observable<String>.just("coderwhy")
        justO.subscribe { (event: Event<String>) in
            dPrint(item: "just:\(event)")//打印两次  just:next(coderwhy)
            // just:completed
            }.disposed(by: bag)
        
        //subscribe /səb'skraɪb/ 订阅
        justO.subscribe(onNext: { (str: String) in
            dPrint(item: "just2:\(str)")
        }, onCompleted: {
            dPrint(item: "just2: completed")
        }).disposed(by: bag)
        
        //4. of
        let ofO = Observable<String>.of("a","b","c")
        ofO.subscribe { (event: Event<String>) in
            dPrint(item: "of:\(event)")
            }.disposed(by: bag)
        
        //5. from
        let fromO = Observable<String>.from(["a","b","c"])
        fromO.subscribe { (event: Event<String>) in
            dPrint(item: "from:\(event)")
            }.disposed(by: bag)
        
        //6. create Observable
        let createO = createObservable()
        createO.subscribe { (event: Event<Any>) in
            dPrint(item: "createO:\(event)")
            }.disposed(by: bag)
        
        
        //7.range
        //        range:next(2)
        //        range:next(3)
        //        range:next(4)
        //        range:next(5)
        //        range:next(6)
        //        range:completed
        let rangeO = Observable<Int>.range(start: 2, count: 5)
        rangeO.subscribe { (event: Event<Int>) in
            dPrint(item: "range:\(event)")
            }.disposed(by: bag)
        
        
        //8.repeat
        let repeatO = Observable<String>.repeatElement("zhaofeng")
        
        //不停打印repeat:next(zhaofeng)
        //        repeatO.subscribe { (event: Event<String>) in
        //            dPrint(item: "repeat:\(event)")
        //        }.disposed(by: bag)
        
        
        //打印一定次数
        repeatO.take(5).subscribe { (event: Event<String>) in
            dPrint(item: "repeat(5):\(event)")
            }.disposed(by: bag)
    }
    
    fileprivate func test2() {
        
        //publish subject  只能接受订阅后的事件
        
//        publish sub :next(b)
//        publish sub :completed
        let publishSub = PublishSubject<String>()
        
        publishSub.onNext("a")
        publishSub.subscribe { (event: Event<String>) in
            dPrint(item: "publish sub :\(event)")
        }.disposed(by: bag)
        publishSub.onNext("b")
        publishSub.onCompleted()
        publishSub.onNext("c")
        
        //ReplaySubject 订阅前后的事件都能接受 ，接受熟练取决于buffersize （从订阅后的事件到订阅前的事件）
        //打印b1,c1,d1    bufferSize 从0开始计算
        let replaySub = ReplaySubject<String>.create(bufferSize: 2)
        replaySub.onNext("a1")
        replaySub.onNext("b1")
        replaySub.onNext("c1")
        replaySub.subscribe { (event: Event<String>) in
            dPrint(item: "replay sub:\(event)")
        }.disposed(by: bag)
        replaySub.onNext("d1")
        
        //无限的buffersize
        let replaySub2 = ReplaySubject<String>.createUnbounded()
        replaySub2.onNext("a1")
        replaySub2.onNext("b1")
        replaySub2.onNext("c1")
        replaySub2.subscribe { (event: Event<String>) in
            dPrint(item: "replay sub22:\(event)")
            }.disposed(by: bag)
        replaySub2.onNext("d1")
        
        //BehaviorSubject 接受订阅前最后一个事件 和订阅后的所有事件 /bɪˈheɪvjə/
        let behaviorSub = BehaviorSubject<String>(value: "aa")
        behaviorSub.onNext("ab")
        behaviorSub.subscribe { (event: Event<String>) in
            dPrint(item: "behavior sub:")
        }.disposed(by: bag)
        behaviorSub.onNext("ac")
        behaviorSub.onNext("ad")
        
        //Variable  接受订阅前最后一个事件 和订阅后的所有事件 并自动complete
        let varSub = Variable<String>("av1")
        varSub.value = "bv1"
//        varSub.asObservable().debug().subscribe { (event: Event<String>) in
//            dPrint(item: "varSub :\(event)")
//            dPrint(item: "current thread subscribe:\(Thread.current)")
//        }.disposed(by: bag)
        
        varSub.asObservable().debug().observeOn(MainScheduler.instance).subscribe(onNext: { (str) in
            dPrint(item: "varSub :\(str)")
        }, onCompleted: {
            dPrint(item: "varSub complete")
        }) {
           dPrint(item: "varSub disposed")
        }.disposed(by: bag)
        
        varSub.value = "cv1"
        varSub.value = "dv1"
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
            //dPrint(item: "current thread asyncAfter:\(Thread.current)")
            varSub.value = "vv3" //会打印2次
        }
        dPrint(item: "---------------------------------")
        
    }
    
    fileprivate func test3() {
        //rxswift 变换操作
        
        let array = [1,2,3,4]
        let array2 =  array.map { (number: Int) -> Int in
            return number * number
        }
        dPrint(item: array2)
        let array3 = array.map({$0 * $0})
        dPrint(item: array3)
        
        Observable.of(1,2,3,4)
            .map { (number: Int) -> Int in
                return number * number
            }.subscribe { (event: Event<Int>) in
                dPrint(item: "map:\(event)")
        }.disposed(by: bag)
        
        
        //flatMap 监听所有添加监听的对象
//        fileName:PhotoCheckRX.swift , lineNum:236, flatMap:next(80.0)
//        fileName:PhotoCheckRX.swift , lineNum:236, flatMap:next(90.0)
//        fileName:PhotoCheckRX.swift , lineNum:236, flatMap:next(1000.0)
//        fileName:PhotoCheckRX.swift , lineNum:236, flatMap:next(10086.0)
//        fileName:PhotoCheckRX.swift , lineNum:236, flatMap:completed
        let stud1 = student(score: Variable(80))
        let stud2 = student(score: Variable(90))
        let studentVari = Variable(stud1)
        studentVari.asObservable()
            .flatMap { (stud: student) -> Observable<Double> in
                return stud.score.asObservable()
                
            }.subscribe { (event: Event<Double>) in
                dPrint(item: "flatMap:\(event)")
        }.disposed(by: bag)
        
        studentVari.value = stud2
        stud2.score.value = 1000
        stud1.score.value = 10086
        
        
        
        //flatLastMap 只监听最新监听的对象
//        fileName:PhotoCheckRX.swift , lineNum:254, flatLastMap:next(80.0)
//        fileName:PhotoCheckRX.swift , lineNum:254, flatLastMap:next(90.0)
//        fileName:PhotoCheckRX.swift , lineNum:254, flatLastMap:next(1000.0)
//        fileName:PhotoCheckRX.swift , lineNum:254, flatLastMap:completed
        let stud3 = student(score: Variable(80))
        let stud4 = student(score: Variable(90))
        let studentVari1 = Variable(stud3)
        studentVari1.asObservable()
            .flatMapLatest { (stud: student) -> Observable<Double> in
                return stud.score.asObservable()
                
            }.subscribe { (event: Event<Double>) in
                dPrint(item: "flatLastMap:\(event)")
            }.disposed(by: bag)
        
        studentVari1.value = stud4
        stud4.score.value = 1000
        stud3.score.value = 10086
    }
}
