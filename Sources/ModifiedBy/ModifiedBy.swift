import Foundation

infix operator <- : MultiplicationPrecedence

public func <-<T> (create: @autoclosure () throws -> T, update: (T) throws -> T) rethrows -> T {
    var newT = try create()
    #if DEBUG
    let tCopy = newT
    #endif
    newT = try update(newT)
    #if DEBUG
    warnIfNonEqual(tCopy, newT)
    #endif
    return newT
}

@_disfavoredOverload
public func <-<T> (create: @autoclosure () throws -> T, update: (inout T) throws -> Void) rethrows -> T {
    var newT = try create()
    _ = try update(&newT)
    return newT
}


private func warnIfNonEqual<T: Equatable>(_ lhs: T, _ rhs: T) {
    if lhs != rhs {
        runtimeWarning("values returned and modified inline in `=>` were unequal.", [String(describing: lhs), String(describing: rhs)])
    }
}

private func warnIfNonEqual<T: AnyObject>(_ lhs: T, _ rhs: T) {
    if lhs !== rhs {
        runtimeWarning("values returned and modified inline in `=>` were unequal.", [String(describing: lhs), String(describing: rhs)])
    }
}
private func warnIfNonEqual<T>(_ lhs: T, _ rhs: T) {
    // can't warn if non identity and non equaltable
}
