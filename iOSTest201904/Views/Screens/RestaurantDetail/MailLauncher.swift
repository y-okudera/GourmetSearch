//
//  MailLauncher.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import MessageUI

struct MailLauncher {
    
    /// Mailerを起動する
    ///
    /// - Parameters:
    ///   - mailScheme: メールスキーム情報
    ///   - isHTML: HTMLメールかどうか
    ///   - delegate: デリゲート
    /// - Returns: MFMailComposeViewController?
    static func sendMail(mailScheme: MailScheme,
                         isHTML: Bool = false,
                         delegate: MFMailComposeViewControllerDelegate?) -> MFMailComposeViewController? {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Failed send mail.")
            return nil
        }
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = delegate
        mailComposeVC.setToRecipients(mailScheme.toAddresses)
        mailComposeVC.setCcRecipients(mailScheme.cc)
        mailComposeVC.setBccRecipients(mailScheme.bcc)
        mailComposeVC.setSubject(mailScheme.subject)
        mailComposeVC.setMessageBody(mailScheme.body, isHTML: isHTML)
        return mailComposeVC
    }
}
