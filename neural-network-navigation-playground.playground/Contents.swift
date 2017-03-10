import Foundation

private let xLim: Int = 2
private let yLim: Int = 2
struct Vector2: CustomStringConvertible {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x; self.y = y
    }
    
    var description: String {
        return "(\(x),\(y))"
    }
    
    static let zero = Vector2(x: 0, y: 0)
    static let up = Vector2(x: 0, y: 1)
    static let down = Vector2(x: 0, y: -1)
    static let left = Vector2(x: -1, y: 0)
    static let right = Vector2(x: 1, y: 0)
    
    static func +(lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func -(lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func +=(lhs: inout Vector2, rhs: Vector2) {
        lhs = lhs + rhs
    }
    static func -=(lhs: inout Vector2, rhs: Vector2) {
        lhs = lhs - rhs
    }
    
    static func ==(lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    static func !=(lhs: Vector2, rhs: Vector2) -> Bool {
        return !(lhs == rhs)
    }
    
    func isOutOf(bounds: Vector2) -> Bool {
        return (self.x >= bounds.x || self.x < 0) || (self.y >= bounds.y || self.y < 0)
    }
    
    func distance(to dest: Vector2) -> Int {
        return abs(dest.x - self.x) + abs(dest.y - self.y)
    }
    
    func angle(to dest: Vector2) -> Float {
        let rad = atan2f(Float(dest.y - self.y), Float(dest.x - self.x))
        return rad * Float(180 / M_PI)
    }
}

let v1 = Vector2(x: 5, y: 5)
let v2 = Vector2(x: 2, y: 4)

v1.angle(to: v2)












private func oneDimFormula(coor: Vector2) -> Int { return coor.y * (xLim) + coor.x }
private func twoDimFormula(idx: Int) -> Vector2 { return Vector2(x:idx % (xLim), y: idx / (xLim)) }

let nodes = NSMutableArray(capacity: oneDimFormula(coor: Vector2(x: xLim, y: yLim)))

let m = oneDimFormula(coor: Vector2(x: 0, y: 0))
let one = twoDimFormula(idx: m)

let n = twoDimFormula(idx: 2)
oneDimFormula(coor: one)



let k = 0
twoDimFormula(idx: k)















