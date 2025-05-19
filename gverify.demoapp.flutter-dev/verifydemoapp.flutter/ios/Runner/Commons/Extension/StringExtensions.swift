import UIKit

extension String {
	var isPhoneNumber: Bool {
		do {
			let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
			let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: count))
			if let res = matches.first {
				return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == count
			} else {
				return false
			}
		} catch {
			return false
		}
	}

	func isPhone() -> Bool {
		if isAllDigits() == true {
			let phoneRegex = "[23456789][0-9]{6}([0-9]{3})?"
			let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
			return predicate.evaluate(with: self)
		} else {
			return false
		}
	}

	func isAllDigits() -> Bool {
		let charcterSet = NSCharacterSet(charactersIn: "+0123456789").inverted
		let inputString = components(separatedBy: charcterSet)
		let filtered = inputString.joined(separator: "")
		return self == filtered
	}

	func contains(find: String) -> Bool {
		return range(of: find) != nil
	}

	func containsIgnoringCase(find: String) -> Bool {
		return range(of: find, options: .caseInsensitive) != nil
	}

	var isInt: Bool {
		return Int(self) != nil
	}

	func convertBase64StringToImage() -> UIImage {
		if let url = URL(string: self) {
			if let data = try? Data(contentsOf: url) {
				return UIImage(data: data) ?? UIImage(named: "img_thumb_cctv")!
			}
		}
		return UIImage(named: "img_thumb_cctv")!
	}
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    func toPathFile() -> String {
        if !self.hasPrefix("file://") {
            return "file://\(self)"
        }
        return self
    }
}

