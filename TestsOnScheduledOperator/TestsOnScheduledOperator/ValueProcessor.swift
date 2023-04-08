//
//  ValueProcessor.swift
//  TestsOnScheduledOperator
//
//  Created by Giwon Seo on 2023/04/08.
//

import Foundation
import Combine

class ValueProcessor {
    
    private var settings = Settings()
    
    private var theSubject = PassthroughSubject<Int, Never>()
    private(set) var output: AnyPublisher<Int, Never> = Empty(outputType: Int.self, failureType: Never.self).eraseToAnyPublisher()
    
    private var anyCancellable: AnyCancellable?
    
    
    init() {
        configureChains()
    }
    
    private func configureChains() {
        
        /* switch to latest */
        output = theSubject
            .map({value in
                self.randomDelayPublisher(value: value)
            })
            .switchToLatest()
            .eraseToAnyPublisher()
            
        
        /* debounce */
        /*
        output = theSubject
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .flatMap({ value in
                return self.randomDelayPublisher(value: value)
            })
            .eraseToAnyPublisher()
         */
        
        /* maxPublisher */
        /*
        output = theSubject
            .flatMap(maxPublishers: .max(3)) { value in
                print("flatmap called")
                return self.randomDelayPublisher(value: value)
            }
            .eraseToAnyPublisher()
         */
    }
    
    func start(with value:Int) {
        theSubject.send(value)
    }
    
    private func randomDelayPublisher(value: Int) -> AnyPublisher<Int, Never> {
        let publisher = Publishers.RandomDelayPublisher.init(value: value)
            .eraseToAnyPublisher()
        return publisher
    }
}
