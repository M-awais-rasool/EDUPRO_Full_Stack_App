import SwiftUI
import AVKit
import UIKit

struct VideoPlayerView: View {
    let videoURL: URL
    @State private var player: AVPlayer
    @Environment(\.presentationMode) var presentationMode
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        _player = State(initialValue: AVPlayer(url: videoURL))
    }
    
    var body: some View {
        ZStack {
            VideoPlayer(player: player)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .padding()
                    }
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            player.play()
            setOrientation(.landscapeRight)
        }
        .onDisappear {
            player.pause()
            setOrientation(.portrait)
        }
    }
}


func setOrientation(_ orientation: UIInterfaceOrientationMask) {
    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        scene.windows.first?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
    }
    
    DispatchQueue.main.async {
        UIDevice.current.setValue(orientation == .portrait ? UIInterfaceOrientation.portrait.rawValue : UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
    }
}
