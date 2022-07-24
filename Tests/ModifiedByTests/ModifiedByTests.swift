import XCTest
@testable import ModifiedBy

final class ModifiedByTests: XCTestCase {

    /// Test that the inout, var modifying, variant works.
    func testInOut_Int() throws {
        let number: Int = 21 <- { $0 *= 2 }
        XCTAssertEqual(number, 42)
    }

    func testInOut_Object() throws {
        let objectModel = ObjectModel(2) <- { $0.value = 6 }
        XCTAssertEqual(objectModel.value, 6)
    }

    func testReturn_Bool() throws {
        let x = false <- { !$0 }
        XCTAssert(x)
    }

    func testReturn_Int() throws {
        let y = 123 <- { val in
            return 0
        }
        XCTAssertEqual(y, 0)
    }

    func testReturn_Object_ReturnPrecedence() throws {
        let obj = ObjectModel(42) <- { obj -> ObjectModel in
            let objCopy = obj
            objCopy.value = 100
            return ObjectModel(42)
        }
        XCTAssertEqual(obj.value, 42)
    }

    func testInOut_throws() throws {

        XCTAssertThrowsError(
            _ = try Throwing() <- { _ throws in }
        )

    }

    func testReturn_rethrows() throws {

        XCTAssertThrowsError(
            _ = try 1 <- { _ throws -> Int in throw Throwing.Thrown.otherError }
        )

    }

    func testAbmiguousReturn_compiles_rethrows() throws {
        XCTAssertThrowsError(
            _ = try 1 <- { _ in throw Throwing.Thrown.otherError }
        )
    }

    func testNonInitExecution() throws {
        let x = 1
        let y = x <- { $0 + 1 }
        XCTAssertEqual(y, 2)
    }

}

private struct Throwing {

    enum Thrown: Error {
        case throwingInitError
        case otherError
    }

    init() throws {
        throw Thrown.throwingInitError
    }
}

private class ObjectModel<T> {
    var value: T
    init(_ initialValue: T) {
        self.value = initialValue
    }
}
