//
//  AppDelegate.swift
//  MacEng
//
//  Created by Даниил Харенков on 28.05.2020.
//  Copyright © 2020 Даниил Харенков. All rights reserved.
//

import Cocoa
import SwiftUI
import AVFoundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {

    var window: NSWindow!

    var currentWord: Word!
    var rusToEng: Bool = false
    var repeatWord: Bool = false

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("MacEng")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)

        NSUserNotificationCenter.default.delegate = self

        Timer.scheduledTimer(withTimeInterval: 300.0, repeats: true) { (timer) in
            if (!self.repeatWord) {
                self.randCurrentWord() //Берем рандомное слово из списка
            }
            self.sendNotification() //Отправляем уведомление
        }

    }

    //Берем рандомное слово из списка
    private func randCurrentWord() {
        currentWord = Words.getRandomWord() //Получаем случайный элемент
        rusToEng = Bool.random() //Если true - то перевод будет с русского на англ
    }

    //Отправить уведомление пользователю
    private func sendNotification() {
        repeatWord = true
        let notification = NSUserNotification()
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.hasReplyButton = true
        notification.deliveryDate = Date(timeIntervalSinceNow: 60)
        notification.actionButtonTitle = "Перевести"

        if (rusToEng) {
            //С русского на английский
            notification.title = currentWord.rus
            notification.informativeText = "Переведи на английский"
            notification.responsePlaceholder = currentWord.rus
        } else {
            //С английского на русский
            notification.title = currentWord.eng
            notification.informativeText = "Переведи на русский"
            notification.responsePlaceholder = currentWord.eng
        }

        NSUserNotificationCenter.default.scheduleNotification(notification)
    }

    //При ответе на сообщение
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        switch (notification.activationType) {
        case .replied:
            guard let res = notification.response else { return }
            print("User replied: \(res.string)")
            if (rusToEng) {
                //С русского на английский
                if (res.string.lowercased() == currentWord.eng.lowercased()) {
                    let notification = NSUserNotification()
                    notification.title = "Правильно!"
                    notification.subtitle = "Ты большой молодец"
                    notification.soundName = NSUserNotificationDefaultSoundName
                    let notificationCenter = NSUserNotificationCenter.default
                    notificationCenter.deliver(notification)
                    repeatWord = false
                } else {
                    let notification = NSUserNotification()
                    notification.title = "Ошибка!"
                    notification.subtitle = "Правильный ответ: " + currentWord.eng
                    notification.soundName = NSUserNotificationDefaultSoundName
                    let notificationCenter = NSUserNotificationCenter.default
                    notificationCenter.deliver(notification)
                }
            } else {
                if (res.string.lowercased() == currentWord.rus.lowercased()) {
                    let notification = NSUserNotification()
                    notification.title = "Правильно!"
                    notification.subtitle = "Ты большой молодец"
                    notification.soundName = NSUserNotificationDefaultSoundName
                    let notificationCenter = NSUserNotificationCenter.default
                    notificationCenter.deliver(notification)
                    repeatWord = false
                } else {
                    let notification = NSUserNotification()
                    notification.title = "Ошибка!"
                    notification.subtitle = "Правильный ответ: " + currentWord.rus
                    notification.soundName = NSUserNotificationDefaultSoundName
                    let notificationCenter = NSUserNotificationCenter.default
                    notificationCenter.deliver(notification)
                }
            }
        default:
            break;
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

