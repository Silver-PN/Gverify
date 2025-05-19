import xverifysdk

extension StepFace {
    init(from string: String) {
        switch string.uppercased() {
        case "FACE_CENTER":
            self = .face
        case "LEFT":
            self = .left
        case "RIGHT":
            self = .right
        case "NOD_UP":
            self = .up
        case "NOD_DOWN":
            self = .down
        case "SMILE":
            self = .smile
        case "DONE":
            self = .done
        case "FACE_FAR":
            self = .far
        case "FACE_NEAR":
            self = .near
        default:
            self = .face  // Default to 'face'
        }
    }
    
    var name: String {
        switch self {
        case .left:
            return "LEFT"
        case .face:
            return "FACE_CENTER"
        case .right:
            return "RIGHT"
        case .up:
            return "NOD_UP"
        case .down:
            return "NOD_DOWN"
        case .smile:
            return "SMILE"
        case .done:
            return "DONE"
        case .far:
            return "FACE_FAR"
        case .near:
            return "FACE_NEAR"
        default:
            return "FACE_CENTER"
        }
    }
}
