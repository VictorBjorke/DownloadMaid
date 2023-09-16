import SwiftUI
import Foundation
import AppKit

@main
struct DownloadMaid: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var doneMessage = ""

    var body: some View {
        VStack {
            Button(action: {
                sortDownloads()
            }) {
                Text("Select Folder")
            }
            Text(doneMessage)
        }
        .padding()
    }

    func sortDownloads() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.title = "Select a Folder"

        openPanel.begin { response in
            if response == .OK, let folderURL = openPanel.urls.first {
                if self.sortFolderContents(folderURL) != nil {
                    self.doneMessage = "Done"
                } else {
                    self.doneMessage = "Error"
                }
            }
        }
    }

    func sortFolderContents(_ folderURL: URL) -> URL? {
        let subdirectories = ["Documents", "Images", "Archives", "Music", "Videos", "Applications", "DMG", "Other"]

        do {
            // Create destination directories within the selected folder if they don't exist
            for subdirectory in subdirectories {
                let subdirectoryURL = folderURL.appendingPathComponent(subdirectory)
                try FileManager.default.createDirectory(at: subdirectoryURL, withIntermediateDirectories: true, attributes: nil)
            }

            let files = try FileManager.default.contentsOfDirectory(atPath: folderURL.path)

            for file in files {
                if file == ".DS_Store" {
                    // Skip .DS_Store files
                    continue
                }

                let fileURL = folderURL.appendingPathComponent(file)
                var isDirectory: ObjCBool = false

                if FileManager.default.fileExists(atPath: fileURL.path, isDirectory: &isDirectory) {
                    if !isDirectory.boolValue {
                        let fileExtension = fileURL.pathExtension

                        switch fileExtension {
                        case "":
                            // Handle files without extensions here or move them to a specific directory
                            try FileManager.default.moveItem(at: fileURL, to: folderURL.appendingPathComponent("Other").appendingPathComponent(file))
                        case "txt", "pdf", "doc", "docx":
                            try FileManager.default.moveItem(at: fileURL, to: folderURL.appendingPathComponent("Documents").appendingPathComponent(file))
                        case "jpg", "jpeg", "png", "gif":
                            try FileManager.default.moveItem(at: fileURL, to: folderURL.appendingPathComponent("Images").appendingPathComponent(file))
                        case "zip", "tar", "gz":
                            try FileManager.default.moveItem(at: fileURL, to: folderURL.appendingPathComponent("Archives").appendingPathComponent(file))
                        case "mp3", "wav", "flac":
                            try FileManager.default.moveItem(at: fileURL, to: folderURL.appendingPathComponent("Music").appendingPathComponent(file))
                        case "mp4", "mov", "avi":
                            try FileManager.default.moveItem(at: fileURL, to: folderURL.appendingPathComponent("Videos").appendingPathComponent(file))
                        case "app":
                            try FileManager.default.moveItem(at: fileURL, to: folderURL.appendingPathComponent("Applications").appendingPathComponent(file))
                        case "dmg":
                            try FileManager.default.moveItem(at: fileURL, to: folderURL.appendingPathComponent("DMG").appendingPathComponent(file))
                        default:
                            try FileManager.default.moveItem(at: fileURL, to: folderURL.appendingPathComponent("Other").appendingPathComponent(file))
                        }
                    }
                }
            }
            return folderURL // Return the sorted folder URL.
        } catch {
            print("Error sorting folder contents: \(error)")
            return nil
        }
    }
}
