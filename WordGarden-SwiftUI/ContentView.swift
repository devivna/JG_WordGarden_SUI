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
    
    @State private var guessesRemaining = 3
    private let maximumGuesses = 3
    
    @State private var gameStatusMessage = "How Many Guesses to Uncover the Hidden Word?"

    @State private var imageName = "sun.max"
    
    @State private var playAgainHidden = true
    @State private var playAgainButtonLabel = "Another word?"
    
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
                .frame(height: 80)
                .minimumScaleFactor(0.5)
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
                            updateGamePlay()
                        }
                    
                    Button {
                        guessALetter()
                        updateGamePlay()
                    } label: {
                        Text("Guess a letter")
                    }
                    .buttonStyle(.bordered)
                    .disabled(guessedLetter.isEmpty)
                    
                }
            } else {
                
                Button {
                    
                    if currentWordIndex == wordsToGuess.count {
                        currentWordIndex = 0
                        wordsGuessed = 0
                        wordsMissed = 0
                        playAgainButtonLabel = "Another word?"
                    }
                    wordToGuess = wordsToGuess[currentWordIndex]
                    revealedWord = "_" + String(repeating: " _", count: wordToGuess.count-1)
                    lettersGuessed = ""
                    // imageName = "flower\(guessesRemaining)"
                    gameStatusMessage = "How many guesses to uncover the hidden word?"
                    playAgainHidden = true
                    
                } label: {
                    Text(playAgainButtonLabel)
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
            guessesRemaining = maximumGuesses
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
        
    }
    
    func updateGamePlay() {
        
        if !wordsToGuess.contains(guessedLetter) {
            guessesRemaining -= 1
            //imageName = "flower\(guessesRemaining)
        }
        
        if !revealedWord.contains("_") {
            gameStatusMessage = "You've guessed it! It took you \(lettersGuessed.count) guesses to guess the word."
            wordsGuessed += 1
            currentWordIndex += 1
            playAgainHidden = false
        } else if guessesRemaining == 0 {
            gameStatusMessage = "So sorry. You're all out of guesses."
            wordsMissed += 1
            currentWordIndex += 1
            playAgainHidden = false
        } else {
            gameStatusMessage = "You've made \(lettersGuessed.count) Guess\(lettersGuessed.count == 1 ? "" : "es")"
        }
        
        if currentWordIndex == wordToGuess.count {
            playAgainButtonLabel = "Restart Game?"
            gameStatusMessage += "\nYou've tried all of the words. Restart from the beggining?"
        }
        
        guessedLetter = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

