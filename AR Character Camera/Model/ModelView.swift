//
//  ModelView.swift
//  AR Character Camera
//
//  Created by cmStudent on 2023/11/06.
//

import ARKit
import QuickLook
import SwiftUI
import UIKit
import os
import FirebaseAuth
import FirebaseStorage

private struct ARQuickLookController: UIViewControllerRepresentable {
    static let logger = Logger(subsystem: AppDelegate.subsystem,
                                category: "ARQuickLookController")

    let modelFile: URL
    let endCaptureCallback: () -> Void

    func makeUIViewController(context: Context) -> QLPreviewControllerWrapper {
        let controller = QLPreviewControllerWrapper()
        controller.qlvc.dataSource = context.coordinator
        controller.qlvc.delegate = context.coordinator
        return controller
    }

    func makeCoordinator() -> ARQuickLookController.Coordinator {
        return Coordinator(parent: self)
    }

    func updateUIViewController(_ uiViewController: QLPreviewControllerWrapper, context: Context) {}

    class Coordinator: NSObject, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
        let parent: ARQuickLookController

        init(parent: ARQuickLookController) {
            self.parent = parent
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.modelFile as QLPreviewItem
        }

        func previewControllerWillDismiss(_ controller: QLPreviewController) {
            ARQuickLookController.logger.log("Exiting ARQL ...")
            parent.endCaptureCallback()
        }
    }

}

private class QLPreviewControllerWrapper: UIViewController {
    let qlvc = QLPreviewController()
    var qlPresented = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !qlPresented {
            present(qlvc, animated: false, completion: nil)
            qlPresented = true
        }
    }
}

struct ModelView: View {
    let modelFile: URL
    let endCaptureCallback: () -> Void

    @State private var isSaveModelPopupPresented = true
    @State private var showARViewController = false

    var body: some View {
        ZStack {
            // Save Model Popup
            if isSaveModelPopupPresented {
                SaveModelPopupView(saveAction: {
                    // Implement the logic to save the model
                    print("Save Model")
                    // Dismiss the popup
                    isSaveModelPopupPresented = false
                    
                    uploadModelToFirebase()
                    
                    // Show the AR view controller
                    showARViewController = true
                    
                }, discardAction: {
                    // Dismiss the popup
                    isSaveModelPopupPresented = false
                    // Callback to discard the AR view
                    endCaptureCallback()
                })
            }

            // AR View Controller
            if showARViewController {
                //ARQuickLookController(modelFile: modelFile, endCaptureCallback: endCaptureCallback)
                SaveSuccessView()
            }
        }
    }
    // Function to upload the model to Firebase Storage
    private func uploadModelToFirebase() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        // Create a folder with the user's ID
        let folderRef = Storage.storage().reference().child("models/\(userId)")
        
        // Generate a unique filename using UUID for each uploaded file
        let filename = "\(UUID().uuidString).usdz"
        
        // Create a reference to the file within the folder
        let fileRef = folderRef.child(filename)
        
        // Upload the model file
        fileRef.putFile(from: modelFile, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading file: \(error.localizedDescription)")
            } else {
                print("File uploaded successfully")
                // Here you can save additional information to Firebase Database if needed
            }
        }
    }
}

struct SaveModelPopupView: View {
    var saveAction: () -> Void
    var discardAction: () -> Void

    var body: some View {
        ZStack {
            Color.gray.opacity(0.5)
                .ignoresSafeArea()

            VStack {
                Text("Do you want to save the model? If you want to save this 3D model, please tap the 'Save Object' button. If you tap the 'Cancel' button, your object will not be saved")
                    .font(.headline)
                    .padding()

                HStack {
                    Button("Save", action: saveAction)
                        .foregroundColor(.blue)
                        .padding()

                    Spacer()

                    Button("Discard", action: discardAction)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .background(Color.white)
            .cornerRadius(10)
            .padding()
        }
    }
}
