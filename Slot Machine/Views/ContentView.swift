//
//  ContentView.swift
//  Slot Machine
//
//  Created by Drashti on 22/12/23.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    
    let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    @State private var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    @State private var reels : Array = [0, 1, 2]
    
    @State private var showingInfoView: Bool = false
    @State private var isActiveBet10: Bool = true
    @State private var isActiveBet20: Bool = false
    @State private var showingModel: Bool = false
    @State private var animationSymbol: Bool = false
    @State private var animatingModal: Bool = false
    
    // MARK: - Functions
    // Spin the reels
    func spinReels(){
        //reels[0] = Int.random(in: 0...symbols.count - 1)
        //reels[1] = Int.random(in: 0...symbols.count - 1)
        //reels[2] = Int.random(in: 0...symbols.count - 1)
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
        playSound(sound: "spin", type: "mp3")
        haptic.impactOccurred()
    }
    //Check the wining
    func checkWining(){
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[2] == reels[0] {
            //Player wins
            playerWins()
            // High score
            if coins > highScore{
                newHighScore()
            }
            else{
                playSound(sound: "win", type: "mp3")
            }
        }
        else{
            // Player loses
            playerLoses()
        }
    }
    
    func playerWins(){
        coins += betAmount * 10
    }
    func newHighScore(){
        highScore = coins
        UserDefaults.standard.set(highScore, forKey: "HighScore")
        playSound(sound: "high-score", type: "mp3")
    }
    func playerLoses(){
        coins -= betAmount
    }
    
    func activateBet20(){
        betAmount = 20
        isActiveBet20 = true
        isActiveBet10 = false
        playSound(sound: "casino-chips", type: "mp3")
        haptic.impactOccurred()
    }
    
    func activateBet10(){
        betAmount = 10
        isActiveBet20 = false
        isActiveBet10 = true
        playSound(sound: "casino-chips", type: "mp3")
        haptic.impactOccurred()
    }
    
    func isGameOver(){
        if coins < 0 {
            // Show Model Window
            showingModel = true
            playSound(sound: "game-over", type: "mp3")
        }
    }
    
    func resetGame(){
        UserDefaults.standard.set(0, forKey: "HighScore")
        highScore = 0
        coins = 100
        activateBet10()
        playSound(sound: "chimeu", type: "mp3")
    }
    
    // Game is over
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // MARK: - Background
            LinearGradient(gradient: Gradient(colors: [.colorPink, .colorPurple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            // MARK: - Interface
            VStack(alignment: .center, spacing: 5){
                // MARK: - Header
                LogoView()
                
                Spacer()
                // MARK: - Score
                HStack {
                    HStack{
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack{
                        Text("\(highScore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                    }
                    .modifier(ScoreContainerModifier())
                }
                // MARK: - Slot Machine
                VStack(alignment: .center, spacing: 0){
                    // MARK: - REEL 1
                    ZStack {
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animationSymbol ? 1 : 0)
                            .offset(y: animationSymbol ? 0 : -50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)), value: animationSymbol)
                            .onAppear(perform: {
                                animationSymbol.toggle()
                                playSound(sound: "riseup", type: "mp3")
                            })
                    }
                    
                    HStack(alignment: .center, spacing: 0){
                        // MARK: - REEL 2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animationSymbol ? 1 : 0)
                                .offset(y: animationSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.7...0.9)), value: animationSymbol)
                                .onAppear(perform: {
                                    animationSymbol.toggle()
                                })
                        }
                        
                        Spacer()
                        
                        // MARK: - REEL 3
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animationSymbol ? 1 : 0)
                                .offset(y: animationSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)), value: animationSymbol)
                                .onAppear(perform: {
                                    animationSymbol.toggle()
                                })
                        }
                    }
                    .frame(maxWidth: 500)
                    
                    // MARK: - SPIN BUTTON
                    
                    Button(action: {
                        withAnimation {
                            animationSymbol = false
                        }
                        spinReels()
                        withAnimation {
                            animationSymbol = true
                        }
                        checkWining()
                        isGameOver()
                    }, label: {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    })
                    
                } // Slot Machine
                .layoutPriority(2)
                
                // MARK: - Footer
                Spacer()
                
                HStack{
                    // MARK: - Bet 20
                    HStack(alignment:.center, spacing: 10) {
                        Button(action: {
                            activateBet20()
                        }, label: {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundStyle(isActiveBet20 ? .yellow : .white)
                                .modifier(BetNumberModifier())
                        })
                        .modifier(BetCapsuleModifier())
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isActiveBet20 ? 0 : 20)
                            .opacity(isActiveBet20 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                    }
                    Spacer()
                    // MARK: - Bet 10
                    HStack(alignment:.center, spacing: 10) {
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isActiveBet10 ? 0 : -20)
                            .opacity(isActiveBet10 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                        
                        Button(action: {
                            activateBet10()
                        }, label: {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundStyle(isActiveBet10 ? .yellow : .white)
                                .modifier(BetNumberModifier())
                        })
                        .modifier(BetCapsuleModifier())
                    }
                }
            }
            // MARK: - Buttons
            .overlay(alignment: .topLeading, content: {
                // Reset
                Button(action: {
                    resetGame()
                }, label: {
                    Image(systemName: "arrow.2.circlepath.circle")
                })
                .modifier(ButtonModifier())
            })
            .overlay(alignment: .topTrailing, content: {
                // Info
                Button(action: {
                    showingInfoView = true
                }, label: {
                    Image(systemName: "info.circle")
                })
                .modifier(ButtonModifier())
            })
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $showingModel.wrappedValue ? 5 : 0, opaque: false)
            
            // MARK: - Popup
            if $showingModel.wrappedValue{
                ZStack{
                    Color(.colorTrasparentBlack).edgesIgnoringSafeArea(.all)
                    
                    // Model
                    VStack(spacing: 0){
                        Text("Game Over")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(.colorPink)
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 16){
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            
                            Text("Bad luck! you lost all of the coin.\nLet's play again.")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.gray)
                                .layoutPriority(1)
                            
                            Button(action: {
                                showingModel = false
                                animatingModal = false
                                activateBet10()
                                coins = 100
                            }, label: {
                                Text("New Game".uppercased())
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .tint(.pink)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                        Capsule()
                                            .strokeBorder(lineWidth: 1.75)
                                            .foregroundStyle(.pink)
                                    )
                            })
                        }
                        Spacer()
                    }
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .colorTrasparentBlack, radius: 6, x: 0, y: 8)
                    .opacity($animatingModal.wrappedValue ? 1 : 0)
                    .offset(y: $animatingModal.wrappedValue ? 0 : -100)
                    .animation(.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0), value: animatingModal)
                    .onAppear(perform: {
                        animatingModal = true
                    })
                }
            }
            
            
        }// ZStack
        .sheet(isPresented: $showingInfoView, content: {
            InfoView()
        })
    }
}

#Preview {
    ContentView()
}
