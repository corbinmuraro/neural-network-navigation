import Foundation

private let xLim: Int = 2
private let yLim: Int = 2
struct Vector2 {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x; self.y = y
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
}

private func oneDimFormula(coor: Vector2) -> Int { return coor.y * (xLim - 1) + coor.x }
private func twoDimFormula(idx: Int) -> Vector2 { return Vector2(x:idx % (xLim), y: idx / (xLim)) }

let nodes = NSMutableArray(capacity: oneDimFormula(coor: Vector2(x: xLim, y: yLim)))

let m = oneDimFormula(coor: Vector2(x: , y: 0))
let one = twoDimFormula(idx: m)

let n = twoDimFormula(idx: 2)
oneDimFormula(coor: one)



let k = 0
twoDimFormula(idx: k)














