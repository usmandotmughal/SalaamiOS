//
//  MenuViewController.swift
//  Salaam
//
//  Created by Andriy Shkinder on 08.12.2019.
//  Copyright © 2019 shkinder.andriy. All rights reserved.
//

import UIKit
import MessageUI

class MenuViewController: LocalizableViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var menuView: MenuStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.collapse(animated: false)
        menuView.feedbackButton.button.addTarget(self, action: #selector(didPressEmailButton(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuView.expand(animated: true)
    }
    
    @IBAction func exitPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickLanguagePressed(_ sender: Any) {}
    
    override func updaetLocalizables() {
        menuView.updateLocalizable()
    }
    
    @IBAction func didPressReviewButton(_ sender: Any) {
        let productUrl = URL(string:"https://apps.apple.com/app/id1489489268")!
        // 1.
        var components = URLComponents(url: productUrl, resolvingAgainstBaseURL: false)

        // 2.
        components?.queryItems = [
          URLQueryItem(name: "action", value: "write-review")
        ]

        // 3.
        guard let writeReviewURL = components?.url else {
          return
        }

        // 4.
        UIApplication.shared.open(writeReviewURL)

    }
    
    @IBAction func didPressEmailButton(_ sender: Any) {
        sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["info@salaamapp.co"])
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
