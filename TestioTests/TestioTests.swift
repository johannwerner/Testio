@testable import Testio
import XCTest


class TestioTests: XCTestCase {
    let attributesForBold = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
    let attributesForCustom = [NSAttributedString.Key.foregroundColor: UIColor.blue]
    let attributesForUnderline = [NSAttributedString.Key.underlineStyle: 1.0]
    
    func testIfAttributedStringMatches() {
        // Given
        let stringToTest = "Hello <b>dog</b> What is your <custom>name</custom>"
        
        // When
        
        let attributedString = AttributedStringProvider.convertStringToAttributedString(
            stringToTest,
            attributesForBold: attributesForBold,
            attributesForCustom: attributesForCustom
        )
        let checkAttributedString = NSMutableAttributedString(string: "Hello dog What is your name")
        checkAttributedString.addAttributes(attributesForBold, range: NSRange(location: 6, length: 3))
        checkAttributedString.addAttributes(attributesForCustom, range: NSRange(location: 23, length: 4))
        
        // Then
        let result = attributedString.isEqual(checkAttributedString)
        XCTAssert(result, "Attributed Strings dont match")
    }
    
    func testNestedBoldTagsMatches() {
        // Given
        let stringToTest = "Hello <b><b>dog</b> What is your name</b>"
        
        // When
        
        let attributedString = AttributedStringProvider.convertStringToAttributedString(
            stringToTest,
            attributesForBold: attributesForBold
        )
        let string = "Hello dog What is your name"
        let checkAttributedString = NSMutableAttributedString(string: string)
        checkAttributedString.addAttributes(attributesForBold, range: NSRange(location: 6, length: string.count - 6))
        
        // Then
        let result = attributedString.isEqual(checkAttributedString)
        XCTAssert(result, "Attributed Strings dont match")
    }
    
    func testNestedUnderlineTagsMatches() {
        // Given
        let stringToTest = "Hello <u><u>dog</u> What is your name</u>"
        
        // When
        
        let attributedString = AttributedStringProvider.convertStringToAttributedString(stringToTest)
        let string = "Hello dog What is your name"
        let checkAttributedString = NSMutableAttributedString(string: string)
        checkAttributedString.addAttributes(
            attributesForUnderline,
            range: NSRange(location: 6, length: string.count - 6)
        )
        
        // Then
        let result = attributedString.isEqual(checkAttributedString)
        XCTAssert(result, "Attributed Strings dont match")
    }
    
    func testIfBoldTagsGetRemoved() {
        // Given
        let stringToTest = "</b>Hello </b>Dog<b> what is your <b>name</b>"
        
        // When
        let attributedString = AttributedStringProvider.convertStringToAttributedString(
            stringToTest,
            attributesForBold: attributesForBold
        )
        let checkString = "Hello Dog what is your name"
        
        // Then
        XCTAssertEqual(attributedString.string, checkString)
    }
    
    func testIfCustomTagsGetRemoved() {
        // Given
        let stringToTest = "</custom>Hello </custom>Dog<custom> what is your <custom>name</custom>"
        
        // When
        let attributedString = AttributedStringProvider.convertStringToAttributedString(
            stringToTest, attributesForCustom: attributesForCustom
        )
        let checkString = "Hello Dog what is your name"
        
        // Then
        XCTAssertEqual(attributedString.string, checkString)
    }
    
    func testIfCustomAndUnderlineTagsGetRemoved() {
        // Given
        let stringToTest = "Hello <custom><u>Dog</u> what is your <b>name</b>"
        
        // When
        let attributedString = AttributedStringProvider.convertStringToAttributedString(
            stringToTest,
            attributesForBold: attributesForBold,
            attributesForCustom: attributesForCustom
        )
        let checkString = "Hello Dog what is your name"
        
        // Then
        XCTAssertEqual(attributedString.string, checkString)
    }
    
    func testWhenOnlyOpenTagsAllTagsGetRemoved() {
        // Given
        let stringToTest = "Hello <custom><u>Dog what is your <b>name"
        
        // When
        let attributedString = AttributedStringProvider.convertStringToAttributedString(
            stringToTest,
            attributesForBold: attributesForBold,
            attributesForCustom: attributesForCustom
        )
        let checkString = "Hello Dog what is your name"
        
        // Then
        XCTAssertEqual(attributedString.string, checkString)
    }
    
    func testWhenOnlyCloseTag() {
        // Given
        let stringToTest = "Hello </custom>Dog what is your name"
        
        // When
        let attributedString = AttributedStringProvider.convertStringToAttributedString(
            stringToTest, attributesForCustom: attributesForCustom
        )
        let checkString = "Hello Dog what is your name"
        
        // Then
        XCTAssertEqual(attributedString.string, checkString)
    }
    
    func testTwoOpenTagsOneOneCloseTag() {
        // Given
        let stringToTest = "<b><b>Hello </b>Dog what is your name"
        
        // When
        let attributedString = AttributedStringProvider.convertStringToAttributedString(
            stringToTest, attributesForBold: attributesForBold
        )
        let checkString = "Hello Dog what is your name"
        
        // Then
        XCTAssertEqual(attributedString.string, checkString)
    }
}
