//
//  ContentView.swift
//  Instafilter
//
//  Created by Jesse Sheehan on 9/17/24.
//

import SwiftUI
//import CoreImage
//import CoreImage.CIFilterBuiltins

struct ContentView: View {
    var body: some View {
            Text("Hello, World!")
    }
}


//Day 63 - ContentUnvailableView

/*
struct ContentView: View {
    var body: some View {
        //ContentUnavailableView("No Snippets yet", systemImage: "swift", description: Text("You don't have any saved snippets."))
        
        //or get more specific
        ContentUnavailableView {
            Label("No snippets yet", systemImage: "swift")
        } description: {
            Text("You don't have nay saved snippets yet.")
        } actions: {
            Button("Create a snippet") {
                //Code to create a snippet here
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
*/

//Day 63 - Core Image with SwiftUI
/*
struct ContentView: View {
    
    @State private var image: Image?
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }
    func loadImage() {
        
        //image = Image(.example) // too simple, let's load, alter the image, THEN display it
        //CoreImage needs to work with UIImages first.
        let inputImage = UIImage(resource: .example)
        //creates the coreImage file
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        
        //FILTERS
        //let currentFilter = CIFilter.sepiaTone()
        //let currentFilter = CIFilter.pixellate()
        let currentFilter = CIFilter.crystallize()
        //let currentFilter = CIFilter.twirlDistortion()
        let amount = 1.0
        let inputKeys = currentFilter.inputKeys
        
        //THESE ARE FILTERS like query filters - says, if the filter i'm using has an intensity key/property, set it to "amount". Or radius, or scale, etc.
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(amount * 100, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(amount * 40, forKey: kCIInputScaleKey)
        }
        
        //Setting specific filter values
        //currentFilter.intensity = 1
        //currentFilter.scale = 25
        //currentFilter.radius = 500
        //currentFilter.center = CGPoint(x:inputImage.size.width / 3, y: inputImage.size.height / 2)
        
        //sets the image you want to use
        currentFilter.inputImage = beginImage

        
        //sets the output image, then creates the CG image from the outputImage
        guard let outputImage = currentFilter.outputImage else {return}
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {return}
        
        //let uIImage = UIImage(cgImage: cgImage)
        //NOTE: found this online, CoreImage likes to rotate images sometimes I guess.
        //makes a uiImage
        let uIImage = UIImage(cgImage: cgImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)

        //sets our image value so we can use it in swiftUI
        image = Image(uiImage: uIImage)
        
        //Notes
        //Image isn't able to do anything complex.
        //UIImage (UIKit Image) works with more types and small animations of images. It's closer to Image, but does a bit more
        //CGImage - Core Graphics Image. a simpler image type - a 2D array of pixels.
        //CIImage - CoreImage - stores the info required to produce an image. "An Image recipe".
        
        //can make a UIImage from a CGImage and vice versa! Interchangeable
        //it's confusing there's actually a lot of interchangability.
        
    }
}
 */
 

//Day 62 - confirmationDialog
/*
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
*/


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
