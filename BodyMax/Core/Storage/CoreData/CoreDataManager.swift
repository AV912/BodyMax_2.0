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
            let existingProfiles = try context.fetch(request)
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
            let profiles = try context.fetch(request)
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
        let cdAnalysis = CDAnalysis(context: context)
        
        do {
            cdAnalysis.bodyPartBreakdownData = try JSONEncoder().encode(analysis.bodyPartBreakdown)
            cdAnalysis.workoutRoutineData = try JSONEncoder().encode(analysis.workoutRoutine)
            cdAnalysis.nutritionPlanData = try JSONEncoder().encode(analysis.nutritionPlan)
            cdAnalysis.transformationProjectionData = try JSONEncoder().encode(analysis.transformationProjection)
            cdAnalysis.dreamPhysiqueData = analysis.dreamPhysiqueData
            cdAnalysis.progressScore = analysis.progressScore
            cdAnalysis.dateGenerated = analysis.dateGenerated
            
            try context.save()
        } catch {
            print("Error saving analysis: \(error)")
        }
    }

    func fetchAnalyses() -> [Analysis] {
        let request = NSFetchRequest<CDAnalysis>(entityName: "CDAnalysis")
        request.sortDescriptors = [NSSortDescriptor(key: "dateGenerated", ascending: false)]
        
        do {
            let cdAnalyses = try context.fetch(request)
            return try cdAnalyses.compactMap { cdAnalysis in
                guard let bodyPartBreakdown = try? JSONDecoder().decode(BodyPartBreakdown.self, from: cdAnalysis.bodyPartBreakdownData ?? Data()),
                      let workoutRoutine = try? JSONDecoder().decode(WorkoutRoutine.self, from: cdAnalysis.workoutRoutineData ?? Data()),
                      let nutritionPlan = try? JSONDecoder().decode(NutritionPlan.self, from: cdAnalysis.nutritionPlanData ?? Data()),
                      let transformationProjection = try? JSONDecoder().decode(TransformationProjection.self, from: cdAnalysis.transformationProjectionData ?? Data()),
                      let dreamPhysiqueData = cdAnalysis.dreamPhysiqueData else {
                    return nil
                }
                
                return Analysis(
                    bodyPartBreakdown: bodyPartBreakdown,
                    progressScore: cdAnalysis.progressScore,
                    workoutRoutine: workoutRoutine,
                    nutritionPlan: nutritionPlan,
                    transformationProjection: transformationProjection,
                    dreamPhysiqueData: dreamPhysiqueData,
                    dateGenerated: cdAnalysis.dateGenerated ?? Date()
                )
            }
        } catch {
            print("Error fetching analyses: \(error)")
            return []
        }
    }
    
    func saveDreamPhysique(_ image: UIImage) {
        let request = NSFetchRequest<CDDreamPhysique>(entityName: "CDDreamPhysique")
        do {
            let existingImages = try context.fetch(request)
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
            let images = try context.fetch(request)
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
            let images = try context.fetch(request)
            for image in images {
                context.delete(image)
            }
            try context.save()
        } catch {
            print("Error clearing dream physique: \(error)")
        }
    }
}