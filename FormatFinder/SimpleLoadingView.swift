import SwiftUI

// MARK: - Simple Loading View
struct LoadingView: View {
    @State private var logoScale: CGFloat = 0.3
    @State private var logoOpacity: Double = 0
    @State private var logoRotation: Double = 0
    @State private var textOpacity: Double = 0
    @State private var progressValue: Double = 0
    @State private var loadingStage = 0
    @State private var pulseAnimation = false
    
    let loadingStages = [
        "Preparing golf course...",
        "Loading formats...",
        "Setting up scorecards...",
        "Almost ready..."
    ]
    
    let onLoadingComplete: () -> Void
    
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                colors: [Color.green.opacity(0.1), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 60) {
                Spacer()
                
                // Logo Section
                ZStack {
                    // Pulsing circles
                    ForEach(0..<3) { index in
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.green.opacity(0.3),
                                        Color.green.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                            .frame(
                                width: 120 + CGFloat(index * 40),
                                height: 120 + CGFloat(index * 40)
                            )
                            .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                            .opacity(pulseAnimation ? 0.3 : 0.6)
                            .animation(
                                .easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                                value: pulseAnimation
                            )
                    }
                    
                    // Main Logo
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.green, Color.green.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .shadow(color: Color.green.opacity(0.4), radius: 20, x: 0, y: 10)
                        
                        // Golf flag icon
                        Image(systemName: "flag.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(logoRotation))
                    }
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                }
                
                // App Name
                VStack(spacing: 8) {
                    Text("Format Finder")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .opacity(textOpacity)
                    
                    Text("Discover Your Perfect Game")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                        .opacity(textOpacity * 0.8)
                }
                
                Spacer()
                
                // Loading Section
                VStack(spacing: 24) {
                    // Progress Bar
                    ZStack(alignment: .leading) {
                        // Background
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        // Progress
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [Color.green, Color.green.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: progressValue * 280, height: 8)
                            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: progressValue)
                    }
                    .frame(width: 280)
                    
                    // Loading Stage Text
                    if loadingStage < loadingStages.count {
                        HStack(spacing: 8) {
                            // Loading dots
                            HStack(spacing: 4) {
                                ForEach(0..<3) { index in
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 6, height: 6)
                                        .opacity(pulseAnimation ? 0.3 : 1.0)
                                        .animation(
                                            .easeInOut(duration: 0.6)
                                            .repeatForever()
                                            .delay(Double(index) * 0.2),
                                            value: pulseAnimation
                                        )
                                }
                            }
                            
                            Text(loadingStages[loadingStage])
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                                .animation(.easeInOut, value: loadingStage)
                        }
                    }
                }
                .opacity(textOpacity)
                
                Spacer()
                    .frame(height: 100)
            }
        }
        .onAppear {
            startLoadingAnimation()
        }
    }
    
    private func startLoadingAnimation() {
        // Logo entrance
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
            textOpacity = 1.0
        }
        
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            logoRotation = 360
        }
        
        // Start pulsing
        pulseAnimation = true
        
        // Simulate loading stages
        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 0.3)) {
                progressValue = min(progressValue + 0.25, 1.0)
                
                if progressValue >= 0.25 && loadingStage == 0 {
                    loadingStage = 1
                } else if progressValue >= 0.5 && loadingStage == 1 {
                    loadingStage = 2
                } else if progressValue >= 0.75 && loadingStage == 2 {
                    loadingStage = 3
                } else if progressValue >= 1.0 {
                    timer.invalidate()
                    
                    // Complete loading
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            onLoadingComplete()
                        }
                    }
                }
            }
        }
    }
}