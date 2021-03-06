//
//  DataManager.swift
//  WaniKani
//
//  Created by Andriy K. on 2/21/16.
//  Copyright © 2016 Andriy K. All rights reserved.
//

import WatchKit
import DataKitWatch
import ClockKit


class DataManager {
  
  struct Notification {
    static let currentLevelUpdate = "CurrentLevelUpdate"
  }
  
  let currentLevelPath: String? = {
    let fileManager = NSFileManager.defaultManager()
    let appGroupIdentifier = "group.com.haawa.WaniKani"
    if let appGroupURL: NSURL = fileManager.containerURLForSecurityApplicationGroupIdentifier(appGroupIdentifier) {
    let path = appGroupURL.path! + "/currentLevel.bin"
      return path
    }
    return nil
  }()
  
  private var internalCurrentLevelObject: KanjiUpdateObject?
  
}

// MARK: - Notifications
extension DataManager {
  
  func registerObjectForNotification(obj: AnyObject, selector: Selector, notificationName: String) {
    NSNotificationCenter.defaultCenter().addObserver(obj, selector: selector, name: notificationName, object: nil)
  }
  
  func removeObserver(obj: AnyObject) {
    NSNotificationCenter.defaultCenter().removeObserver(obj)
  }
  
}

extension DataManager {
  
  func updateCurrentLevelKanji(kanjiUpdate: KanjiUpdateObject) {
    guard let currentLevelPath = currentLevelPath else { return }
    
    let oldLevel = currentLevel?.kanji.first?.level ?? 0
    
    NSKeyedArchiver.archiveRootObject(kanjiUpdate, toFile: currentLevelPath)
    internalCurrentLevelObject = nil
    NSNotificationCenter.defaultCenter().postNotificationName(Notification.currentLevelUpdate, object: nil)
    
    if oldLevel == 0 || (oldLevel < kanjiUpdate.kanji.first?.level) {
      reloadComplications()
    }
  }
  
  var currentLevel: KanjiUpdateObject? {
    if let internalCurrentLevelObject = internalCurrentLevelObject {
      return internalCurrentLevelObject
    } else {
      guard let currentLevelPath = currentLevelPath else { return nil }
      if let q = NSKeyedUnarchiver.unarchiveObjectWithFile(currentLevelPath) as? KanjiUpdateObject {
        internalCurrentLevelObject = q
        return q
      }
    }
    return nil
  }
  
  private func reloadComplications() {
    if let complications: [CLKComplication] = CLKComplicationServer.sharedInstance().activeComplications {
      if complications.count > 0 {
        for complication in complications {
          CLKComplicationServer.sharedInstance().reloadTimelineForComplication(complication)
        }
      }
    }
  }
  
}
