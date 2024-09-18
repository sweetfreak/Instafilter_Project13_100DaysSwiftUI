//
//  ContentView.swift
//  Instafilter
//
//  Created by Jesse Sheehan on 9/17/24.
//

import SwiftUI

//Day 62 - confirmationDialog

struct ContentView: View {
    
    @State private var showingConfirmation = false
    @State private var backgroundColor = Color.white
    
    var body: some View {
        Button("Hello, World!") {
            showingConfirmation.toggle()
        }
        .frame(width: 300, height: 300)
        .background(backgroundColor)
        .confirmationDialog("Change background", isPresented: $showingConfirmation) {
            Button("Red") {backgroundColor = .red}
            Button("Green") {backgroundColor = .green}
            Button("Yellow") {backgroundColor = .yellow}
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Select a new color")
        }
     
    }
}


//Day 62 - Bindings and property wrappers - didSet, .OnChange, etc
/*
struct ContentView: View {
    @State private var blurAmount = 0.0
        
        
        
        //didSet doesn't work with Bindings, so instead we use .onChange with old/new values
    //{
//        didSet {
//            print("The new value is \(blurAmount)")
//        }
//    }
    
    //property wrappers wrap out type in another property/struct. @Enviornment or String(intVar) are property wrappers. @State itself is a struct!
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .blur(radius: blurAmount)
            
            //this changes the internal value, but not the @State or actual blurAmount - because it uses a BINDING (the $)
            Slider(value: $blurAmount, in: 0...20)
                .onChange(of: blurAmount) { oldValue, newValue in
                    print("New value is \(newValue)")
                    //you can run algorithms or methods here or do whatever you want!
                    
                    //could not use new or old value, or even only newValue (but DON'T - only newValue is defunct.
                }
            //this changes the State value
            Button("Random Blur") {
                blurAmount = Double.random(in: 0...20)
            }
            //you could even add onChange here! But probably easier to follow the item that's changing
        }
        .padding()
    }
}

 */

#Preview {
    ContentView()
}
