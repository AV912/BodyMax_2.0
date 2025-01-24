import SwiftUI
import UIKit

struct StyledPickerView: UIViewRepresentable {
    @Binding var selection: Int
    let range: ClosedRange<Int>
    
    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.backgroundColor = .clear
        picker.delegate = context.coordinator
        picker.dataSource = context.coordinator
        return picker
    }
    
    func updateUIView(_ uiView: UIPickerView, context: Context) {
        // Find the index of current selection
        if let index = Array(range).firstIndex(of: selection) {
            if uiView.selectedRow(inComponent: 0) != index {
                uiView.selectRow(index, inComponent: 0, animated: true)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        let parent: StyledPickerView
        let numbers: [Int]
        
        init(_ parent: StyledPickerView) {
            self.parent = parent
            self.numbers = Array(parent.range)
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            numbers.count
        }
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let label = (view as? UILabel) ?? UILabel()
            
            label.text = "\(numbers[row])"
            label.font = .systemFont(ofSize: 24)
            label.textColor = .white
            label.textAlignment = .center
            
            return label
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.selection = numbers[row]
        }
    }
}
