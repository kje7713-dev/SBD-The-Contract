import SwiftUI

@main
struct ContractBootstrap: App {
    @StateObject private var appLifecycleMonitor = LifecycleTracker()
    
    var body: some Scene {
        WindowGroup {
            RootContractInterface()
                .environmentObject(appLifecycleMonitor)
                .onAppear {
                    appLifecycleMonitor.recordLaunchEvent()
                }
        }
    }
}

class LifecycleTracker: ObservableObject {
    @Published var launchTimestamp: Date?
    @Published var sessionIdentifier: UUID = UUID()
    
    func recordLaunchEvent() {
        launchTimestamp = Date()
        print("🚀 Session \(sessionIdentifier) started at \(launchTimestamp!)")
    }
}

struct RootContractInterface: View {
    @EnvironmentObject var lifecycleMonitor: LifecycleTracker
    @State private var titleOpacity: Double = 0
    @State private var subtitleOffset: CGFloat = 50
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RadialGradient(
                    colors: [Color(hue: 0.58, saturation: 0.15, brightness: 0.98),
                            Color(hue: 0.62, saturation: 0.08, brightness: 0.95)],
                    center: .topLeading,
                    startRadius: 10,
                    endRadius: geometry.size.height
                )
                .ignoresSafeArea()
                
                VStack(spacing: geometry.size.height * 0.04) {
                    Spacer()
                    
                    contractSymbolView
                        .frame(width: geometry.size.width * 0.35)
                    
                    mainTitleStack
                        .opacity(titleOpacity)
                    
                    buildInformationBadge
                        .offset(y: subtitleOffset)
                    
                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 28)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.2)) {
                titleOpacity = 1.0
            }
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3)) {
                subtitleOffset = 0
            }
        }
    }
    
    private var contractSymbolView: some View {
        ZStack {
            Circle()
                .fill(
                    AngularGradient(
                        colors: [.blue.opacity(0.7), .purple.opacity(0.5), .blue.opacity(0.7)],
                        center: .center,
                        angle: .degrees(45)
                    )
                )
                .shadow(color: .blue.opacity(0.3), radius: 12, x: 0, y: 6)
            
            Image(systemName: "doc.plaintext")
                .resizable()
                .scaledToFit()
                .padding(35)
                .foregroundStyle(.white)
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private var mainTitleStack: some View {
        VStack(spacing: 14) {
            Text("The Contract")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(Color(red: 0.15, green: 0.2, blue: 0.35))
            
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.caption)
                Text("Savage By Design")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.secondary)
        }
    }
    
    private var buildInformationBadge: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.green)
                .frame(width: 8, height: 8)
            
            Text("TestFlight Distribution Build")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.6))
        )
    }
}
