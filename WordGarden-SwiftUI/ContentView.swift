//
//  ContentView.swift
//  WordGarden-SwiftUI
//
//  Created by Students on 01.02.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    
    private let wordsToGuess = ["SWIFT", "CAT", "DOG"]
    @State private var currentWordIndex = 0
    @State private var wordToGuess = ""
    @State private var revealedWord = ""
    @State private var lettersGuessed = ""
    @State private var guessedLetter = ""
    
    @State private var gameStatusMessage = "How Many Guesses to Uncover the Hidden Word?"
    @State private var imageName = "sun.max"
    
    @State private var playAgainHidden = true
    @FocusState private var textFieldIsFocus: Bool
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Words Guessed: \(wordsGuessed)")
                    Text("Words Missed: \(wordsMissed)")
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Words to Guess: \(wordsToGuess.count - (wordsGuessed + wordsMissed))")
                    Text("Words in Game: \(wordsToGuess.count)")
                }
            }
            .padding(.horizontal)
            
            Text(gameStatusMessage)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            // TODO: Switch to wordsToGuess[currentWord]
            
            Text(revealedWord)
                .font(.title)
            
            if playAgainHidden {
                HStack {
                    TextField("", text: $guessedLetter)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 30)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                        }
                    //2.3
                        .keyboardType(.alphabet)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                        .onChange(of: guessedLetter) { _ in
                            guessedLetter = guessedLetter.trimmingCharacters(in: .letters.inverted)
                            
                            guard let lastChar = guessedLetter.last else {
                                return
                            }
                            guessedLetter = String(lastChar).uppercased()
                        }
                        .focused($textFieldIsFocus)
                        .onSubmit {
                            guard !guessedLetter.isEmpty else {
                                return
                            }
                            guessALetter()
                        }
                    
                    Button {
                        guessALetter()
                    } label: {
                        Text("Guess a letter")
                    }
                    .buttonStyle(.bordered)
                    .disabled(guessedLetter.isEmpty)
                    
                }
            } else {
                
                Button {
                    //
                } label: {
                    Text("Another word?")
                }
                .buttonStyle(.borderedProminent)
                
            }
            
            Spacer()
            
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 300)
            
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear() {
            wordToGuess = wordsToGuess[currentWordIndex]
            revealedWord = String(repeating: "_ ", count: wordToGuess.count)
            
        }
    }
    func guessALetter() {
        textFieldIsFocus = false
        lettersGuessed += guessedLetter
        revealedWord = ""
        
        for letter in wordToGuess {
            if lettersGuessed.contains(letter) {
                revealedWord += "\(letter) "
            } else {
                revealedWord += "_ "
            }
        }
        
        revealedWord.removeLast()
        guessedLetter = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

