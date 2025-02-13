import SwiftUI

struct LoginScreen: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible = false
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var showToast = false
    @State private var toastMessage = ""
    @AppStorage("isLogin") private var isLogin = false
    let screenWidth = UIScreen.main.bounds.width
    
    func doLogin()async{
        do{
            let body = ["email":email,"password":password]
            let res = try await loginApi(body: body)
            let defaults = UserDefaults.standard
            if res.status == "success"{
                defaults.set(res.data.token, forKey: "token")
                defaults.set(res.data.userId, forKey: "userId")
                defaults.set(res.data.name, forKey: "name")
                toastMessage = "Login successful!"
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isLogin = true
                }            }
        }catch{
            toastMessage = error.localizedDescription
            showToast = true
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack(spacing: 32) {
            VStack {
                Image("LOGO")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenWidth * 0.8, height: 100)
            }
            .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Let's Sign In!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Login to Your Account to Continue your Courses")
                    .font(.subheadline)
                    .foregroundColor(.gray.opacity(0.8))
            }
            TextInput(
                text: $email,
                label: "Email",
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
            
            Buttons(label: "Sign In", onPress: {
                withAnimation {
                    if validateFields() {
                        Task{
                            await doLogin()
                        }
                    }
                }
            })
            
            VStack(spacing: 20) {
                Text("Or Continue With")
                    .foregroundColor(.gray)
                
                HStack(spacing: 24) {
                    Button(action: {}) {
                        HStack {
                            Image("google")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .frame(width: 60, height: 60)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                }
            }
            
            HStack {
                Text("Don't have an Account?")
                    .foregroundColor(.gray)
                NavigationLink(destination: SignUpScreen()) {
                    Text("SIGN UP")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                }
            }
            .padding(.top, 16)
        }
        .padding(.vertical)
        .padding(.horizontal,20)
        .toast(isShowing: $showToast, message: toastMessage)
    }
    
    private func validateFields() ->Bool {
        emailError = ""
        passwordError = ""
        if !isValidEmail(email){
            emailError =  "*Please enter a valid email"
            return false
        }
        else if password.count < 6{
            passwordError =  "*Password must be at least 6 characters"
            return false
        }
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

#Preview {
    LoginScreen()
}
