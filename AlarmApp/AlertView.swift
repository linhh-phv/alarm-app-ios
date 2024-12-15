//
//  AlertView.swift
//  AlarmApp
//
//  Created by Phạm Linh on 15/12/24.
//

import SwiftUI

struct AlertView: UIViewControllerRepresentable {
    var title: String
    var message: String
    var isPresented: Binding<Bool>
    
    class Coordinator: NSObject {
        var parent: AlertView
        
        init(parent: AlertView) {
            self.parent = parent
        }
        
        @objc func dismissAlert() {
            parent.isPresented.wrappedValue = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        if isPresented.wrappedValue {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                context.coordinator.dismissAlert()
            }))
            
            viewController.present(alertController, animated: true, completion: nil)
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented.wrappedValue {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                context.coordinator.dismissAlert()
            }))
            
            uiViewController.present(alertController, animated: true, completion: nil)
        }
    }
}
