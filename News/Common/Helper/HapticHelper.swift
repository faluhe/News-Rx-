//
//  HapticHelper.swift
//  News
//
//  Created by Ismailov Farrukh on 21/12/23.
//

import UIKit

class HapticFeedbackHelper {
    static func provideHapticFeedback(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(feedbackType)
    }
}
