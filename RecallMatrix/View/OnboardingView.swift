//
//  OnboardingView.swift
//  MindGrid
//
//  Created by Gerard Gomez on 12/1/24.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.2), .red.opacity(0.1), .blue.opacity(0.5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text("Welcome to Recall Matrix")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(alignment: .top) {
                            Image(systemName: "1.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(.blue)
                            Text("**Memorize the Pattern**\nWatch the highlighted tiles carefully when the pattern is displayed.")
                                .font(.system(size: 18))
                                .foregroundStyle(.primary)
                            #if os(visionOS)
                                .fixedSize(horizontal: false, vertical: true)
                            #endif
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "2.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(.blue)
                            Text("**Recall and Select**\nAfter the pattern disappears, select the tiles that were highlighted.")
                                .font(.system(size: 18))
                                .foregroundStyle(.primary)
                            #if os(visionOS)
                                .fixedSize(horizontal: false, vertical: true)
                            #endif
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "3.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(.blue)
                            Text("**Beat the Timer**\nPress **Check Result** before the timer runs out to see if you're correct.")
                                .font(.system(size: 18))
                                .foregroundStyle(.primary)
                            #if os(visionOS)
                                .fixedSize(horizontal: false, vertical: true)
                            #endif
                        }
                        
                        HStack(alignment: .top) {
                            Image(systemName: "4.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(.blue)
                            Text("**Progress and Challenge**\nAdvance through rounds to increase the grid size and test your memory!")
                                .font(.system(size: 18))
                                .foregroundStyle(.primary)
                            #if os(visionOS)
                                .fixedSize(horizontal: false, vertical: true)
                            #endif
                        }
                    }
                    
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button {
                        hasSeenOnboarding = true
                        dismiss()
                    } label: {
                        Text("Get Started")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 6)
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom)
                }
                
                .padding()
            }
            .navigationTitle("How to Play")
#if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
        }
    }
}

#Preview {
    OnboardingView()
}

