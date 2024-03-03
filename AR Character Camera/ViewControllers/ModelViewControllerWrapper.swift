//
//  ModelViewControllerWrapper.swift
//  AR Character Camera
//
//  Created by cmStudent on 2024/02/12.
//

import SwiftUI

struct ModelViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ModelViewController {
        let storyboard = UIStoryboard(name: "Model", bundle: nil)
        guard let modelVC = storyboard.instantiateViewController(withIdentifier: "Model") as? ModelViewController else {
            fatalError("Unable to instantiate ModelViewController from the Model storyboard.")
        }
        return modelVC
    }

    func updateUIViewController(_ uiViewController: ModelViewController, context: Context) {}
}
