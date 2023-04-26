//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Диана Симонян on 18.04.2023.
//

import XCTest

class MovieQuizUITests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        // это специальная настройка для тестов: если один тест не прошёл,
        // то следующие тесты запускаться не будут; и правда, зачем ждать?
        continueAfterFailure = false
    }
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        XCTAssertTrue(firstPoster.exists)
        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertTrue(secondPoster.exists)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(firstPoster == secondPoster)
        XCTAssertFalse(firstPosterData == secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
        
    }
    
    
    func testNoButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        XCTAssertTrue(firstPoster.exists)
        app.buttons["No"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertTrue(secondPoster.exists)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(firstPoster == secondPoster)
        XCTAssertFalse(firstPosterData == secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    
    func testAlert() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        // let indexLabel = app.staticTexts["Index"]
        //   XCTAssertEqual(indexLabel.label, "10/10")
        
        let myAlert = app.alerts["Этот раунд окончен!"]
        XCTAssertTrue(myAlert.exists)
        XCTAssertTrue(myAlert.label == "Этот раунд окончен!")
        XCTAssertTrue(myAlert.buttons.firstMatch.label == "Сыграть ещё раз")
        
    }
    
    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
