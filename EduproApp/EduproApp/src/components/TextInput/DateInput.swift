//
//  DateInput.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 12/02/2025.
//

import SwiftUI

struct DateInput: View {
    @Binding var date: Date?
    let label: String
    @State private var showPicker = false
    let screenHeight = UIScreen.main.bounds.height
    @Binding var errorMessage:String?
    
    var displayText: String {
        if let selectedDate = date {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: selectedDate)
        }
        return "Select Date of Birth"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                showPicker = true
            }) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    Text(displayText)
                        .foregroundColor(date == nil ? .gray : .black)
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            if let emailError = errorMessage {
                Text(emailError)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.leading,10)
                    .padding(.top,-8)
            }
        }
        .sheet(isPresented: $showPicker) {
            NavigationView {
                VStack {
                    DatePicker(
                        selection: Binding(
                            get: { date ?? Date() },
                            set: { date = $0 }
                        ),
                        displayedComponents: .date
                    ) {
                        Text("Select date")
                    }
                    .datePickerStyle(.graphical)
                    .padding()
                }
                .frame(height: screenHeight / 2)
                .navigationBarItems(
                    trailing: Button("Done") {
                        showPicker = false
                    }
                )
            }
            .presentationDetents([.height(screenHeight / 2)])
        }
    }
}

#Preview {
    SignUpScreen()
}
