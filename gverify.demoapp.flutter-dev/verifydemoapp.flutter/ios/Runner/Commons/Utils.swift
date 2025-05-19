import UIKit

class Utils {
    static var sampleDeviceUUID = UUID().uuidString
    
    static func objectToJsonString(object: Encodable) -> String? {
        do {
            let jsonData = try JSONEncoder().encode(object)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Failed to encode object \(object): \(error)")
        }
        return nil
    }
    
    static func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    static func saveFileToLocal(_ image: UIImage, fileName: String) -> URL {
        let directoryPath =  try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let urlString: NSURL = directoryPath.appendingPathComponent(fileName) as NSURL
        print("Image path : \(urlString)")
        if !FileManager.default.fileExists(atPath: urlString.path!) {
            do {
                try image.jpegData(compressionQuality: 1.0)!.write(to: urlString as URL)
                    print ("Image Added Successfully")
            } catch {
                    print ("Image Not added")
            }
        }
        return urlString as URL
    }
    
    static func removeFileFromLocal(fileUrl: URL) {
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            do {
                try FileManager.default.removeItem(atPath: fileUrl.path)
            } catch {
                print("Could not delete file, probably read-only filesystem")
            }
        }
    }
}

// MARK: - Constants
enum Constant {
  static let videoDataOutputQueueLabel = "vn.jth.xverifydemoapp.VideoDataOutputQueue"
  static let sessionQueueLabel = "vn.jth.xverifydemoapp.SessionQueue"
}

