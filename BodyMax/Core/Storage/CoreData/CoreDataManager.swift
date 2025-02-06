import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BodyMaxDataModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveUserProfile(_ profile: UserProfile) {
        let request = NSFetchRequest<CDUserProfile>(entityName: "CDUserProfile")
        do {
            // Be explicit about the type here
            let existingProfiles: [CDUserProfile] = try context.fetch(request)
            for existingProfile in existingProfiles {
                context.delete(existingProfile)
            }
            
            let cdProfile = CDUserProfile(context: context)
            cdProfile.name = profile.name
            cdProfile.age = Int16(profile.age)
            cdProfile.height = profile.height
            cdProfile.weight = profile.weight
            cdProfile.goal = profile.goal.rawValue
            cdProfile.measurementPreference = profile.measurementPreference.rawValue
            cdProfile.notificationsEnabled = profile.notificationsEnabled
            cdProfile.referralCode = profile.referralCode
            cdProfile.hasCompletedOnboarding = profile.hasCompletedRating
            
            try context.save()
        } catch {
            print("Error saving user profile: \(error)")
        }
    }
    
    func fetchUserProfile() -> UserProfile? {
        let request = NSFetchRequest<CDUserProfile>(entityName: "CDUserProfile")
        do {
            let profiles: [CDUserProfile] = try context.fetch(request)
            guard let cdProfile = profiles.first else { return nil }
            
            return UserProfile(
                name: cdProfile.name ?? "",
                measurementPreference: MeasurementPreference(rawValue: cdProfile.measurementPreference ?? "metric") ?? .metric,
                age: Int(cdProfile.age),
                weight: cdProfile.weight,
                height: cdProfile.height,
                goal: FitnessGoal(rawValue: cdProfile.goal ?? "Maintain Physique") ?? .maintainWeight,
                notificationsEnabled: cdProfile.notificationsEnabled,
                referralCode: cdProfile.referralCode ?? "",
                hasCompletedRating: cdProfile.hasCompletedOnboarding
            )
        } catch {
            print("Error fetching user profile: \(error)")
            return nil
        }
    }

    func saveAnalysis(_ analysis: Analysis) {
        print("CoreDataManager - Attempting to save new analysis...")
        let cdAnalysis = CDAnalysis(context: context)
        
        do {
            cdAnalysis.bodyPartBreakdownData = try JSONEncoder().encode(analysis.bodyPartBreakdown)
            cdAnalysis.workoutRoutineData = try JSONEncoder().encode(analysis.workoutRoutine)
            cdAnalysis.nutritionPlanData = try JSONEncoder().encode(analysis.nutritionPlan)
            cdAnalysis.transformationProjectionData = try JSONEncoder().encode(analysis.transformationProjection)
            cdAnalysis.dreamPhysiqueData = analysis.dreamPhysiqueData
            cdAnalysis.progressScore = analysis.progressScore
            cdAnalysis.dateGenerated = analysis.dateGenerated
            
            print("CoreDataManager - Saving analysis with date: \(analysis.dateGenerated)")
            try context.save()
            print("CoreDataManager - Successfully saved to CoreData")
        } catch {
            print("CoreDataManager - Error saving analysis: \(error)")
        }
    }

    func fetchAnalyses() -> [Analysis] {
        print("CoreDataManager - Starting to fetch analyses...")
        let request = NSFetchRequest<CDAnalysis>(entityName: "CDAnalysis")
        request.sortDescriptors = [NSSortDescriptor(key: "dateGenerated", ascending: false)]
        
        do {
            let cdAnalyses = try context.fetch(request)
            print("CoreDataManager - Found \(cdAnalyses.count) analyses in CoreData")
            
            let analyses: [Analysis] = cdAnalyses.compactMap { cdAnalysis in
                // Explicitly handle potential decoding errors
                guard 
                    let bodyPartBreakdownData = cdAnalysis.bodyPartBreakdownData,
                    let workoutRoutineData = cdAnalysis.workoutRoutineData,
                    let nutritionPlanData = cdAnalysis.nutritionPlanData,
                    let transformationProjectionData = cdAnalysis.transformationProjectionData,
                    let bodyPartBreakdown = try? JSONDecoder().decode(BodyPartBreakdown.self, from: bodyPartBreakdownData),
                    let workoutRoutine = try? JSONDecoder().decode(WorkoutRoutine.self, from: workoutRoutineData),
                    let nutritionPlan = try? JSONDecoder().decode(NutritionPlan.self, from: nutritionPlanData),
                    let transformationProjection = try? JSONDecoder().decode(TransformationProjection.self, from: transformationProjectionData)
                else {
                    print("CoreDataManager - Failed to decode analysis data")
                    return nil
                }
                
                return Analysis(
                    bodyPartBreakdown: bodyPartBreakdown,
                    progressScore: cdAnalysis.progressScore,
                    workoutRoutine: workoutRoutine,
                    nutritionPlan: nutritionPlan,
                    transformationProjection: transformationProjection,
                    dreamPhysiqueData: cdAnalysis.dreamPhysiqueData,
                    dateGenerated: cdAnalysis.dateGenerated ?? Date()
                )
            }
            
            print("CoreDataManager - Successfully mapped \(analyses.count) analyses")
            return analyses
        } catch {
            print("CoreDataManager - Error fetching analyses: \(error)")
            return []
        }
    }
    
    func saveDreamPhysique(_ image: UIImage) {
        let request = NSFetchRequest<CDDreamPhysique>(entityName: "CDDreamPhysique")
        do {
            let existingImages: [CDDreamPhysique] = try context.fetch(request)
            for image in existingImages {
                context.delete(image)
            }
            
            let cdDreamPhysique = CDDreamPhysique(context: context)
            cdDreamPhysique.imageData = image.jpegData(compressionQuality: 0.8)
            cdDreamPhysique.uploadDate = Date()
            
            try context.save()
        } catch {
            print("Error saving dream physique: \(error)")
        }
    }
    
    func fetchDreamPhysique() -> UIImage? {
        let request = NSFetchRequest<CDDreamPhysique>(entityName: "CDDreamPhysique")
        do {
            let images: [CDDreamPhysique] = try context.fetch(request)
            guard let cdDreamPhysique = images.first,
                  let imageData = cdDreamPhysique.imageData else {
                return nil
            }
            return UIImage(data: imageData)
        } catch {
            print("Error fetching dream physique: \(error)")
            return nil
        }
    }
    
    func clearDreamPhysique() {
        let request = NSFetchRequest<CDDreamPhysique>(entityName: "CDDreamPhysique")
        do {
            let images: [CDDreamPhysique] = try context.fetch(request)
            for image in images {
                context.delete(image)
            }
            try context.save()
        } catch {
            print("Error clearing dream physique: \(error)")
        }
    }
}