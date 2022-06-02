//
//  SwiftUIView.swift
//  
//
//  Created by Tomás Mamede on 19/04/2022.
//

import Foundation
import MessageUI
import SwiftUI

struct EmailComposeView: UIViewControllerRepresentable {
    
    func makeCoordinator() -> EmailComposeView.Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<EmailComposeView>) -> MFMailComposeViewController {
        
        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = context.coordinator
        controller.setToRecipients(["chive.spar_0v@icloud.com"])
        controller.setSubject("Hello, Developer!")
        controller.setMessageBody("", isHTML: false)
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<EmailComposeView>) {
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        var parent: EmailComposeView
        
        init(parent: EmailComposeView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
}
