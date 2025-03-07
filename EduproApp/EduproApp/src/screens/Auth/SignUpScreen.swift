import SwiftUI
import PhotosUI
import AVFoundation

struct SignUpScreen: View {
    @State private var name: String = ""
    @State private var dateOfBirth: Date? = nil
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @State private var selectedGender: String = "Select Gender"
    @State private var isPasswordVisible = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var nameError: String?
    @State private var emailError: String?
    @State private var passwordError: String?
    @State private var phoneError: String?
    @State private var genderError: String?
    @State private var dobError: String?
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isShowingImagePicker = false
    @State private var isCameraSelected = false
    @State private var selectedImage: UIImage? = nil
    
    let genderOptions = ["Male", "Female"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                    Button(action: showImageSourceAlert) {
                        Circle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40)
                                    .foregroundColor(.gray.opacity(0.3))
                            )
                            .overlay(
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(.teal)
                                    .offset(x: 30, y: 35)
                                    .font(.system(size: 30))
                            )
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 16) {
                        TextInput(
                            text: $name,
                            label: "Enter name",
                            icon: "person",
                            errorMessage: $nameError
                        )
                        
                        TextInput(
                            text: $email,
                            label: "Enter Email",
                            icon: "envelope",
                            errorMessage: $emailError
                        )
                        
                        TextInput(
                            text: $password,
                            label: "Password",
                            icon: "lock",
                            isPasswordVisible: isPasswordVisible,
                            fieldType: "password",
                            errorMessage: $passwordError
                        )
                        
                        DateInput(
                            date: $dateOfBirth,
                            label: "Date of Birth",
                            errorMessage: $dobError
                        )
                        
                        TextInput(
                            text: $phoneNumber,
                            label: "Enter PhoneNo",
                            icon: "phone",
                            errorMessage: $phoneError,
                            keyboardType:.numberPad
                        )
                        
                        Menu {
                            ForEach(genderOptions, id: \.self) { gender in
                                Button(gender) {
                                    selectedGender = gender
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedGender)
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .frame(height: 56)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(16)
                        }
                        if let error = genderError {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.leading,10)
                                .padding(.top,-15)
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    Buttons(label: "Sign up", onPress: {
                        withAnimation {
                            validateForm()
                        }
                    })
                    .padding(.top, 20)
                }
                .padding(.horizontal, 10)
            }
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
            })
            .navigationTitle("Fill Your Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isShowingImagePicker) {
            if isCameraSelected {
                ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
            } else {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
            }
        }
    }
    
    func validateForm() {
        nameError = name.isEmpty ? "*Please enter Name" : nil
        emailError = isValidEmail(email) ? nil : "*Please enter a valid email"
        passwordError = password.count >= 6 ? nil : "Password must be at least 6 characters"
        phoneError = isValidPhoneNumber(phoneNumber) ? nil : "*Please enter a valid phone number"
        genderError = (selectedGender == "Select Gender") ? "*Please select a gender" : nil
        dobError = (dateOfBirth == nil) ? "*Please select Date of Birth" : nil
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func isValidPhoneNumber(_ phone: String) -> Bool {
        let phoneRegex = "^[0-9]{10,}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
    }
    
    private func showImageSourceAlert() {
        let alert = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
            requestCameraPermission()
        })
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default) { _ in
            requestPhotoLibraryPermission()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(alert, animated: true, completion: nil)
        }
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { response in
            if response {
                DispatchQueue.main.async {
                    isCameraSelected = true
                    isShowingImagePicker = true
                }
            } else {
                showPermissionDeniedAlert(for: "camera")
            }
        }
    }
    
    private func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    isCameraSelected = false
                    isShowingImagePicker = true
                case .denied, .restricted:
                    showPermissionDeniedAlert(for: "photo library")
                default:
                    break
                }
            }
        }
    }
    
    private func showPermissionDeniedAlert(for resource: String) {
        let alertController = UIAlertController(
            title: "Permission Denied",
            message: "You need to allow access to the \(resource) in order to use this feature.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(alertController, animated: true, completion: nil)
        }
    }
    
}

#Preview {
    SignUpScreen()
}
