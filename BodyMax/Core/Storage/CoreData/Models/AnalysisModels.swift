import Foundation

struct Analysis: Codable {
    let bodyPartBreakdown: BodyPartBreakdown
    let progressScore: Double
    let workoutRoutine: WorkoutRoutine
    let nutritionPlan: NutritionPlan
    let transformationProjection: TransformationProjection
    let dreamPhysiqueData: Data?
    let dateGenerated: Date
}

struct BodyPartBreakdown: Codable {
    let muscleGroups: [MuscleGroupAssessment]
    let overallAssessment: String
}

struct MuscleGroupAssessment: Codable {
    let name: String
    let currentCondition: String
    let improvementNotes: String
}

struct WorkoutRoutine: Codable {
    let cycle: WorkoutCycle
    let weekDuration: Int
    let exercises: [WorkoutDay]
    let progressionTips: String
}

struct WorkoutDay: Codable {
    let type: WorkoutType
    let exercises: [Exercise]
}

struct Exercise: Codable {
    let name: String
    let sets: Int
    let reps: String
    let progressionMethod: String
}

struct NutritionPlan: Codable {
    let dailyMacros: Macros
    let dietaryPreferences: [String]
    let sampleMealPlans: [MealPlan]
}

struct Macros: Codable {
    let protein: Int
    let carbs: Int
    let fat: Int
    let calories: Int
}

struct MealPlan: Codable {
    let name: String
    let meals: [Meal]
}

struct Meal: Codable {
    let name: String
    let description: String
    let macroBreakdown: Macros
}

struct TransformationProjection: Codable {
    let generatedImageURL: String
    let projectionDetails: String
}

enum WorkoutCycle: String, Codable {
    case pushPullLegs
    case upperLower
    case fullBody
    case custom
}

enum WorkoutType: String, Codable {
    case push
    case pull
    case legs
    case upper
    case lower
    case fullBody
    case custom
}