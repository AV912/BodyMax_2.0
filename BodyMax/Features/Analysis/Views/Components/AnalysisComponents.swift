import SwiftUI

struct DreamPhysiqueCard: View {
    let dreamPhysique: UIImage?
    let onAdd: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Dream Physique")
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                if dreamPhysique != nil {
                    Menu {
                        Button(action: onEdit) {
                            Label("Change Photo", systemImage: "photo")
                        }
                        Button(role: .destructive, action: onDelete) {
                            Label("Remove Photo", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(Theme.textSecondary)
                            .padding(8)
                    }
                }
            }
            
            if let image = dreamPhysique {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(12)
                    .clipped()
            } else {
                Button(action: onAdd) {
                    VStack(spacing: 12) {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 40))
                        Text("Upload Dream Physique")
                            .font(.subheadline)
                    }
                    .foregroundColor(Theme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.textSecondary.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [5]))
                    )
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Theme.secondaryBackground)
        .cornerRadius(12)
    }
}

struct AnalysisHistoryRow: View {
    let analysis: Analysis
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Progress Score: \(Int(analysis.progressScore))%")
                    .font(.subheadline)
                    .foregroundColor(Theme.textPrimary)
                
                Text(analysis.dateGenerated.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Theme.textSecondary)
        }
        .padding()
        .background(Theme.secondaryBackground)
        .cornerRadius(12)
    }
}