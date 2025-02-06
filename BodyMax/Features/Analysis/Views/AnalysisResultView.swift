import SwiftUI

// Add mock extension
extension Analysis {
    static var mock: Analysis {
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
            dreamPhysiqueData: nil,
            dateGenerated: Date()
        )
    }
}

struct AnalysisResultView: View {
    let analysis: Analysis
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Progress Score
                        VStack {
                            Text("Progress Score")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                            
                            Text("\(Int(analysis.progressScore))%")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(Theme.accent)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Theme.secondaryBackground)
                        .cornerRadius(12)
                        
                        // Body Part Breakdown
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Body Analysis")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                            
                            Text(analysis.bodyPartBreakdown.overallAssessment)
                                .foregroundColor(Theme.textSecondary)
                            
                            ForEach(analysis.bodyPartBreakdown.muscleGroups, id: \.name) { group in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(group.name)
                                        .font(.subheadline)
                                        .foregroundColor(Theme.textPrimary)
                                    
                                    Text(group.currentCondition)
                                        .font(.caption)
                                        .foregroundColor(Theme.textSecondary)
                                    
                                    Text(group.improvementNotes)
                                        .font(.caption)
                                        .foregroundColor(Theme.accent)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Theme.secondaryBackground.opacity(0.5))
                                .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(Theme.secondaryBackground)
                        .cornerRadius(12)
                        
                        // Workout Preview
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Workout Plan")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                            
                            Text("Cycle: \(analysis.workoutRoutine.cycle.rawValue)")
                                .foregroundColor(Theme.textSecondary)
                            
                            ForEach(analysis.workoutRoutine.exercises, id: \.type.rawValue) { day in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(day.type.rawValue)
                                        .font(.subheadline)
                                        .foregroundColor(Theme.textPrimary)
                                    
                                    ForEach(day.exercises, id: \.name) { exercise in
                                        Text("\(exercise.name): \(exercise.sets) sets × \(exercise.reps)")
                                            .font(.caption)
                                            .foregroundColor(Theme.textSecondary)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Theme.secondaryBackground.opacity(0.5))
                                .cornerRadius(8)
                            }
                            
                            Text(analysis.workoutRoutine.progressionTips)
                                .font(.caption)
                                .foregroundColor(Theme.accent)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Theme.secondaryBackground)
                        .cornerRadius(12)
                        
                        // Nutrition Plan
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Nutrition Plan")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                            
                            MacrosView(macros: analysis.nutritionPlan.dailyMacros)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Dietary Preferences")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textPrimary)
                                
                                ForEach(analysis.nutritionPlan.dietaryPreferences, id: \.self) { pref in
                                    Text("• \(pref)")
                                        .font(.caption)
                                        .foregroundColor(Theme.textSecondary)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Theme.secondaryBackground.opacity(0.5))
                            .cornerRadius(8)
                            
                            ForEach(analysis.nutritionPlan.sampleMealPlans, id: \.name) { plan in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(plan.name)
                                        .font(.subheadline)
                                        .foregroundColor(Theme.textPrimary)
                                    
                                    ForEach(plan.meals, id: \.name) { meal in
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(meal.name)
                                                .font(.caption)
                                                .foregroundColor(Theme.textPrimary)
                                            
                                            Text(meal.description)
                                                .font(.caption)
                                                .foregroundColor(Theme.textSecondary)
                                            
                                            MacrosView(macros: meal.macroBreakdown)
                                                .padding(.top, 4)
                                        }
                                        .padding(.vertical, 4)
                                    }
                                }
                                .padding()
                                .background(Theme.secondaryBackground.opacity(0.5))
                                .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(Theme.secondaryBackground)
                        .cornerRadius(12)

                        // Dream Physique
                        if let imageData = analysis.dreamPhysiqueData,
                        let image = UIImage(data: imageData) {
                            VStack(alignment: .leading) {
                                Text("Goal Physique")
                                    .font(.headline)
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            }
                            .padding()
                            .background(Theme.secondaryBackground)
                            .cornerRadius(12)
                        }

                        // Transformation Projection
                        VStack(alignment: .leading) {
                            Text("Projected Transformation")
                                .font(.headline)
                            if let url = URL(string: analysis.transformationProjection.generatedImageURL),
                            let imageData = try? Data(contentsOf: url),
                            let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            }
                            Text(analysis.transformationProjection.projectionDetails)
                                .font(.subheadline)
                        }
                        .padding()
                        .background(Theme.secondaryBackground)
                        .cornerRadius(12)
                    }
                    .padding()
                }
            }
            .navigationTitle("Analysis Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct MacrosView: View {
    let macros: Macros
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Macros")
                .font(.caption)
                .foregroundColor(Theme.textPrimary)
            
            HStack(spacing: 16) {
                MacroItem(name: "Protein", value: macros.protein, unit: "g")
                MacroItem(name: "Carbs", value: macros.carbs, unit: "g")
                MacroItem(name: "Fat", value: macros.fat, unit: "g")
                MacroItem(name: "Calories", value: macros.calories, unit: "kcal")
            }
        }
    }
}

struct MacroItem: View {
    let name: String
    let value: Int
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(name)
                .font(.caption2)
                .foregroundColor(Theme.textSecondary)
            Text("\(value)\(unit)")
                .font(.caption)
                .foregroundColor(Theme.textPrimary)
        }
    }
}

#Preview {
    AnalysisResultView(analysis: .mock)
}