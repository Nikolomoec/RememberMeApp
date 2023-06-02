//
//  FileManagerExtension.swift
//  RememberMe
//
//  Created by Nikita Kolomoec on 21.05.2023.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
