import XCTest

final class WeatherUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testMainScreenElements() {
        // Проверяем наличие основных элементов на главном экране
        XCTAssertTrue(app.navigationBars["WearWeatherPred"].exists, "Navigation bar should exist")
        XCTAssertTrue(app.buttons["locationButton"].exists, "Location button should exist")
        XCTAssertTrue(app.buttons["cameraButton"].exists, "Camera button should exist")
    }
    
    func testLocationPermission() {
        let locationButton = app.buttons["locationButton"]
        locationButton.tap()
        
        let locationAlert = app.alerts["Allow WearWeatherPred to access your location?"]
        XCTAssertTrue(locationAlert.exists, "Location permission alert should appear")
    }
    
    func testCameraAccess() {
        // Тестируем доступ к камере
        let cameraButton = app.buttons["cameraButton"]
        cameraButton.tap()
        
        // Проверяем появление системного алерта с запросом разрешения
        let cameraAlert = app.alerts["Allow WearWeatherPred to access your camera?"]
        XCTAssertTrue(cameraAlert.exists, "Camera permission alert should appear")
    }
    
    func testWeatherDisplay() {
        // Проверяем отображение погодной информации
        XCTAssertTrue(app.staticTexts["temperatureLabel"].exists, "Temperature label should exist")
        XCTAssertTrue(app.staticTexts["weatherDescriptionLabel"].exists, "Weather description should exist")
        XCTAssertTrue(app.images["weatherIcon"].exists, "Weather icon should exist")
    }
    
    func testNavigation() {
        // Тестируем навигацию между экранами
        let settingsButton = app.buttons["settingsButton"]
        settingsButton.tap()
        
        // Проверяем, что мы перешли на экран настроек
        XCTAssertTrue(app.navigationBars["Settings"].exists, "Should navigate to settings screen")
        
        // Возвращаемся назад
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        // Проверяем, что вернулись на главный экран
        XCTAssertTrue(app.navigationBars["WearWeatherPred"].exists, "Should return to main screen")
    }
} 
