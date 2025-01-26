import SwiftUI

class AnalysisViewModel: ObservableObject {
    @Published var dreamPhysique: UIImage?
    @Published var showingPhotoPicker = false
    @Published var showingBodyPhotoCapture = false
    @Published var isLoading = false
    @Published var showingAnalysisResult = false
    @Published var showingLoadingView = false
    @Published var analyses: [Analysis] = []
    @Published var selectedAnalysis: Analysis?
    
    init() {
        self.dreamPhysique = CoreDataManager.shared.fetchDreamPhysique()
        loadAnalyses()
    }
    
    func saveDreamPhysique(_ image: UIImage) {
        CoreDataManager.shared.saveDreamPhysique(image)
        dreamPhysique = image
    }
    
    func clearDreamPhysique() {
        CoreDataManager.shared.clearDreamPhysique()
        dreamPhysique = nil
    }
    
    func loadAnalyses() {
        analyses = CoreDataManager.shared.fetchAnalyses()
        selectedAnalysis = analyses.first
    }
    
    func startNewAnalysis() {
        showingBodyPhotoCapture = true
    }
    
    func performAnalysis(with photos: [PhotoType: UIImage]) {
        print("Starting analysis with photos: \(photos)")
        showingLoadingView = true
        
        let mockAnalysis = generateMockAnalysis()
        CoreDataManager.shared.saveAnalysis(mockAnalysis)
        selectedAnalysis = mockAnalysis
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showingLoadingView = false
            self.loadAnalyses()
            self.showingAnalysisResult = true
        }
    }
    
    func generateMockAnalysis() -> Analysis {
        let muscleGroup = MuscleGroupAssessment(
            name: "Chest",
            currentCondition: "Well developed upper chest",
            improvementNotes: "Focus on lower chest development"
        )
        
        let bodyPartBreakdown = BodyPartBreakdown(
            muscleGroups: [muscleGroup],
            overallAssessment: "Good overall development"
        )
        
        let exercise = Exercise(
            name: "Bench Press",
            sets: 4,
            reps: "8-12",
            progressionMethod: "Add 5lbs when all sets completed"
        )
        
        let workoutDay = WorkoutDay(
            type: .push,
            exercises: [exercise]
        )
        
        let workoutRoutine = WorkoutRoutine(
            cycle: .pushPullLegs,
            weekDuration: 1,
            exercises: [workoutDay],
            progressionTips: "Focus on progressive overload"
        )
        
        let macros = Macros(
            protein: 180,
            carbs: 220,
            fat: 60,
            calories: 2500
        )
        
        let meal = Meal(
            name: "Breakfast",
            description: "Oatmeal with protein",
            macroBreakdown: macros
        )
        
        let mealPlan = MealPlan(
            name: "Standard Plan",
            meals: [meal]
        )
        
        let nutritionPlan = NutritionPlan(
            dailyMacros: macros,
            dietaryPreferences: ["High Protein"],
            sampleMealPlans: [mealPlan]
        )
        
        let transformationProjection = TransformationProjection(
            generatedImageURL: "",
            projectionDetails: "Expected transformation in 12 weeks"
        )
        
        return Analysis(
            bodyPartBreakdown: bodyPartBreakdown,
            progressScore: 75.0,
            workoutRoutine: workoutRoutine,
            nutritionPlan: nutritionPlan,
            transformationProjection: transformationProjection,
            dreamPhysiqueData: dreamPhysique?.jpegData(compressionQuality: 0.8),
            dateGenerated: Date()
        )
    }
}