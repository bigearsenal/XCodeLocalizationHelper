//
//  FilePickerService.swift
//  LocalizationHelper
//
//  Created by Chung Tran on 25/07/2021.
//

import SwiftUI

#if DEBUG
import XcodeProj
#endif

protocol FilePickerServiceType {
    func showFilePicker(title: String, showsResizeIndicator: Bool, showsHiddenFiles: Bool, allowsMultipleSelection: Bool, canChooseDirectories: Bool, canChooseFiles: Bool, allowedFileTypes: [String], completion: @escaping (String) -> Void)
}

struct FilePickerService: FilePickerServiceType {
    func showFilePicker(
        title: String,
        showsResizeIndicator: Bool = true,
        showsHiddenFiles: Bool = false,
        allowsMultipleSelection: Bool = false,
        canChooseDirectories: Bool,
        canChooseFiles: Bool,
        allowedFileTypes: [String] = [],
        completion: @escaping (String) -> Void
    ) {
        (NSApplication.shared.delegate as! AppDelegate).statusBar?.hidePopover()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let dialog = NSOpenPanel()
            

            dialog.title                   = title
            dialog.showsResizeIndicator    = showsResizeIndicator
            dialog.showsHiddenFiles        = showsHiddenFiles
            dialog.allowsMultipleSelection = allowsMultipleSelection
            dialog.canChooseDirectories    = canChooseDirectories
            dialog.canChooseFiles          = canChooseFiles
            dialog.allowedFileTypes        = allowedFileTypes

            if (dialog.runModal() ==  .OK) {
                let result = dialog.url // Pathname of the file

                if let pathString = result?.path {
                    completion(pathString)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    (NSApplication.shared.delegate as! AppDelegate).statusBar?.showPopover()
                }
            } else {
                // User clicked on "Cancel"
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    (NSApplication.shared.delegate as! AppDelegate).statusBar?.showPopover()
                }
            }
        }
    }
}

#if DEBUG
struct MockFilePickerService: FilePickerServiceType {
    func showFilePicker(title: String, showsResizeIndicator: Bool, showsHiddenFiles: Bool, allowsMultipleSelection: Bool, canChooseDirectories: Bool, canChooseFiles: Bool, allowedFileTypes: [String], completion: @escaping (String) -> Void) {
        if canChooseFiles {
            completion(XcodeProj.demoProject.1.string)
        }
        if canChooseDirectories {
            completion(XcodeProj.demoProject.1.parent().string)
        }
    }
}
#endif
