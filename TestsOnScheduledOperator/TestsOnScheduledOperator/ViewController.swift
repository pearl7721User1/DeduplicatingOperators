//
//  ViewController.swift
//  TestsOnScheduledOperator
//
//  Created by Giwon Seo on 2023/04/08.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var send2Label: UILabel!
    @IBOutlet weak var delayTimeLabel: UILabel!
    
    private var subscriptions = [AnyCancellable]()
    private var valueProcessor = ValueProcessor()
    
    private var balance2: Int = 0 {
        didSet {
            send2Label.text = "\(balance2)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        valueProcessor.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                
                self?.balance2 -= 1
            }
            .store(in: &subscriptions)

        NotificationCenter.default.addObserver(self, selector: #selector(delayChanged), name: NSNotification.Name.init("delayChanged"), object: nil)
    }
    
    @objc func delayChanged() {
        delayTimeLabel.text = "\(Publishers.delay)s"
    }

    @IBAction func send2Tapped(_ sender: UIButton) {
        valueProcessor.start(with: 2)
        balance2 += 1
    }
    
}

