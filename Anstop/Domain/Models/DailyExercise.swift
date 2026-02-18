//
//  DailyExercise.swift
//  Anstop
//
//  Created on 2025-11-24.
//

import Foundation
import SwiftUI

struct DailyExercise: Identifiable {
    let id = UUID()
    let day: Int
    let titleKey: String
    let descriptionKey: String
    let exerciseType: ExerciseType
    let contentKey: String

    var title: String {
        NSLocalizedString(titleKey, comment: "")
    }

    var description: String {
        NSLocalizedString(descriptionKey, comment: "")
    }

    var content: String {
        NSLocalizedString(contentKey, comment: "")
    }

    enum ExerciseType {
        case breathing
        case grounding
        case reflection
        case journaling
        case mindfulness
    }

    static let all: [DailyExercise] = [
        DailyExercise(day: 1, titleKey: "daily_exercise_1_title", descriptionKey: "daily_exercise_1_description", exerciseType: .breathing, contentKey: "daily_exercise_1_content"),
        DailyExercise(day: 2, titleKey: "daily_exercise_2_title", descriptionKey: "daily_exercise_2_description", exerciseType: .reflection, contentKey: "daily_exercise_2_content"),
        DailyExercise(day: 3, titleKey: "daily_exercise_3_title", descriptionKey: "daily_exercise_3_description", exerciseType: .grounding, contentKey: "daily_exercise_3_content"),
        DailyExercise(day: 4, titleKey: "daily_exercise_4_title", descriptionKey: "daily_exercise_4_description", exerciseType: .journaling, contentKey: "daily_exercise_4_content"),
        DailyExercise(day: 5, titleKey: "daily_exercise_5_title", descriptionKey: "daily_exercise_5_description", exerciseType: .mindfulness, contentKey: "daily_exercise_5_content"),
        DailyExercise(day: 6, titleKey: "daily_exercise_6_title", descriptionKey: "daily_exercise_6_description", exerciseType: .reflection, contentKey: "daily_exercise_6_content"),
        DailyExercise(day: 7, titleKey: "daily_exercise_7_title", descriptionKey: "daily_exercise_7_description", exerciseType: .journaling, contentKey: "daily_exercise_7_content"),
        DailyExercise(day: 8, titleKey: "daily_exercise_8_title", descriptionKey: "daily_exercise_8_description", exerciseType: .reflection, contentKey: "daily_exercise_8_content"),
        DailyExercise(day: 9, titleKey: "daily_exercise_9_title", descriptionKey: "daily_exercise_9_description", exerciseType: .breathing, contentKey: "daily_exercise_9_content"),
        DailyExercise(day: 10, titleKey: "daily_exercise_10_title", descriptionKey: "daily_exercise_10_description", exerciseType: .journaling, contentKey: "daily_exercise_10_content"),
        DailyExercise(day: 11, titleKey: "daily_exercise_11_title", descriptionKey: "daily_exercise_11_description", exerciseType: .mindfulness, contentKey: "daily_exercise_11_content"),
        DailyExercise(day: 12, titleKey: "daily_exercise_12_title", descriptionKey: "daily_exercise_12_description", exerciseType: .reflection, contentKey: "daily_exercise_12_content"),
        DailyExercise(day: 13, titleKey: "daily_exercise_13_title", descriptionKey: "daily_exercise_13_description", exerciseType: .journaling, contentKey: "daily_exercise_13_content"),
        DailyExercise(day: 14, titleKey: "daily_exercise_14_title", descriptionKey: "daily_exercise_14_description", exerciseType: .reflection, contentKey: "daily_exercise_14_content"),
        DailyExercise(day: 15, titleKey: "daily_exercise_15_title", descriptionKey: "daily_exercise_15_description", exerciseType: .mindfulness, contentKey: "daily_exercise_15_content"),
        DailyExercise(day: 16, titleKey: "daily_exercise_16_title", descriptionKey: "daily_exercise_16_description", exerciseType: .reflection, contentKey: "daily_exercise_16_content"),
        DailyExercise(day: 17, titleKey: "daily_exercise_17_title", descriptionKey: "daily_exercise_17_description", exerciseType: .grounding, contentKey: "daily_exercise_17_content"),
        DailyExercise(day: 18, titleKey: "daily_exercise_18_title", descriptionKey: "daily_exercise_18_description", exerciseType: .journaling, contentKey: "daily_exercise_18_content"),
        DailyExercise(day: 19, titleKey: "daily_exercise_19_title", descriptionKey: "daily_exercise_19_description", exerciseType: .breathing, contentKey: "daily_exercise_19_content"),
        DailyExercise(day: 20, titleKey: "daily_exercise_20_title", descriptionKey: "daily_exercise_20_description", exerciseType: .reflection, contentKey: "daily_exercise_20_content"),
        DailyExercise(day: 21, titleKey: "daily_exercise_21_title", descriptionKey: "daily_exercise_21_description", exerciseType: .journaling, contentKey: "daily_exercise_21_content"),
        DailyExercise(day: 22, titleKey: "daily_exercise_22_title", descriptionKey: "daily_exercise_22_description", exerciseType: .mindfulness, contentKey: "daily_exercise_22_content"),
        DailyExercise(day: 23, titleKey: "daily_exercise_23_title", descriptionKey: "daily_exercise_23_description", exerciseType: .reflection, contentKey: "daily_exercise_23_content"),
        DailyExercise(day: 24, titleKey: "daily_exercise_24_title", descriptionKey: "daily_exercise_24_description", exerciseType: .journaling, contentKey: "daily_exercise_24_content"),
        DailyExercise(day: 25, titleKey: "daily_exercise_25_title", descriptionKey: "daily_exercise_25_description", exerciseType: .breathing, contentKey: "daily_exercise_25_content"),
        DailyExercise(day: 26, titleKey: "daily_exercise_26_title", descriptionKey: "daily_exercise_26_description", exerciseType: .reflection, contentKey: "daily_exercise_26_content"),
        DailyExercise(day: 27, titleKey: "daily_exercise_27_title", descriptionKey: "daily_exercise_27_description", exerciseType: .journaling, contentKey: "daily_exercise_27_content"),
        DailyExercise(day: 28, titleKey: "daily_exercise_28_title", descriptionKey: "daily_exercise_28_description", exerciseType: .reflection, contentKey: "daily_exercise_28_content"),
        DailyExercise(day: 29, titleKey: "daily_exercise_29_title", descriptionKey: "daily_exercise_29_description", exerciseType: .journaling, contentKey: "daily_exercise_29_content"),
        DailyExercise(day: 30, titleKey: "daily_exercise_30_title", descriptionKey: "daily_exercise_30_description", exerciseType: .reflection, contentKey: "daily_exercise_30_content"),
    ]
}
