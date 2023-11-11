import SwiftUI

struct TabBarController: View {
    @EnvironmentObject private var userManager: UserManager
    
    @State private var selectedTab = 0
    @State private var isLogin = false
    @State private var showLogin = false
    @State private var showReport = false
    @State private var showUserAccont = false
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            MapView()
                .tabItem {
                    Home()
                }
                .padding(.bottom, 5)
                .tag(0)
            RankView()
                .tabItem {
                    Rank()
                }
                .padding(.bottom, 5)
                .tag(1)
            if isLogin {
                AnimatedGradientLoadingView()
                    .tabItem {
                        Report()
                    }
                    .padding(.bottom, 5)
                    .tag(2)
            }
            if isLogin {
                AnimatedGradientLoadingView()
                    .tabItem {
                        UserAccount()
                    }
                    .padding(.bottom, 5)
                    .tag(3)
            } else {
                AnimatedGradientLoadingView()
                    .tabItem {
                        Account()
                    }
                    .padding(.bottom, 5)
                    .tag(4)
            }
        }
        .accentColor(.purple)
        .onChange(of: selectedTab) { newTab in
            if newTab == 2 {
                showReport = true
            }
            if newTab == 3 {
                showUserAccont = true
            }
            if newTab == 4 {
                showLogin = true
            }
        }
        .onAppear {
            userManager.loadCurrentUserIfNeeded()
            if userManager.currentUser != nil {
                isLogin = true
            }
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
        }
        .fullScreenCover(isPresented: $showReport) {
            OccurrenceView()
        }
        .fullScreenCover(isPresented: $showUserAccont) {
            AccontUserView()
        }
    }
}

struct InitView: View {
    var body: some View {
        NavigationStack {
            VStack {
                TabBarController()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .navigationBarBackButtonHidden(true)
    }
}
