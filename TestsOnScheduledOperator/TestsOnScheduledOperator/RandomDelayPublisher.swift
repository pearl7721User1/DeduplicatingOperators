//
//  File.swift
//
//  Created by Giwon Seo on 2023/03/19.
//

import UIKit
import Combine

extension Publishers {
    
    static var seed: Int = 0
    static var delay: Double = 0.0 {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name.init("delayChanged"), object: nil)
        }
    }
    
    class RandomDelaySubscription<S: Subscriber>: Subscription where S.Input == Int, S.Failure == Never {
        private var subscriber: S?
        
        let queue = DispatchQueue.init(label: "queue")
        let value: Int
        
        init(value:Int, subscriber: S) {
            self.value = value
            self.subscriber = subscriber
            
            // set random delay time
            
            if Publishers.seed == 0 {
                Publishers.seed = 1
                Publishers.delay = 2.0
            } else {
                Publishers.seed = 0
                Publishers.delay = 1.0
            }
            
            var delayTime = Publishers.delay
            
            queue.asyncAfter(deadline: .now() + delayTime, execute: {
                
                subscriber.receive(self.value)
                subscriber.receive(completion: .finished)
            })
        }
        
        func request(_ demand: Subscribers.Demand) {
            // Adjust the demand in case you need to
        }
        
        func cancel() {
            subscriber = nil
        }
        
    }
    
    struct RandomDelayPublisher: Publisher {
        typealias Output = Int
        typealias Failure = Never
        
        let value: Int
        
        init(value: Int) {
            self.value = value
        }
        
        func receive<S: Subscriber>(subscriber: S) where
        RandomDelayPublisher.Failure == S.Failure, RandomDelayPublisher.Output == S.Input {
            
            let subscription = RandomDelaySubscription.init(value: value, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
    }
}
