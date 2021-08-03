//
//  ViewController.swift
//  ReachabilitySwift-Demo
//
//  Created by k-aoki on 2021/08/03.
//

import UIKit
import Reachability

class ViewController: UIViewController {
    
    // 接続を試して見る前に繋がっているかどうかをチェックしてはいけない
    // SCNetworkReachabilityは接続に失敗した原因を特定するために使用すると書いてあります。

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // インスタンス化
        let reachability = try! Reachability()
        
        // クロージャパターン
        // コネクション可能になったタイミングで入る
        reachability.whenReachable = { reachability in
            
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        
        // コネクションがない場合に入る
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        
        // 通知開始
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        // 通知停止
//        reachability.stopNotifier()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // Notifyパターン
        let reachability = try! Reachability()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Could not start reachability notifier")
        }
    }
    
    // 通知の停止
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let reachability = try! Reachability()
        reachability.stopNotifier()
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .none:
            print("not connected")
        case .unavailable:
            print("Network not reachable")
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        }
    }
}

