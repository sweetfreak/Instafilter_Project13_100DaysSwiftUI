//
//  ContentView.swift
//  Instafilter
//
//  Created by Jesse Sheehan on 9/17/24.
//

//import StoreKit
import SwiftUI
import PhotosUI //day 64
import CoreImage //day 62, 63
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var selectedItem: PhotosPickerItem?
    
    @State private var currentFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedItem) {
                    
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description:Text("Tap to import a photo"))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedItem, loadImage)
                
                Spacer()
                
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity, applyProcesssing)
                }
                
                HStack {
                    Button("Change Filter", action: changeFilter)
                    
                    Spacer()
                    
                    //Share the picture button
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
        }
    }
    
    func changeFilter() {
        
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            
            guard let inputImage = UIImage(data: imageData) else { return }
            
            //the following is not the easiest way, but it is the safest:
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcesssing()
            
        }
    }
    
    func applyProcesssing() {
        currentFilter.intensity = Float(filterIntensity)
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
        
    }
    
}


//Day 64 - Request a Review from your User
//NOTE: recommended to only request a review when you think the user has spent enough time in the app to review it.
/*
struct ContentView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        Button("Leave a review") {
            requestReview()
        }
    }
}
*/

//Day 64 - Share link (with a friend)
/*
struct ContentView: View {
        
    var body: some View {
//        ShareLink(item: URL(string: "https://hackingwithswift.com")!, subject: Text("Learn Swift Here"), message: Text("Check out the 100 Days of SwiftUI")) {//optional label
//            Label("Spread the word about swift", systemImage: "swift")
//        }
        let example = Image(.example)
        ShareLink(item: example, preview: SharePreview("Zoe", image: example)) {
            Label("Click to share", systemImage: "swift")
        }
    }
}
*/

/*
//DAY 64 - PhotosUI - let user choose photos and display them

struct ContentView: View {
    //single image is optional because it may not be there
//    @State private var pickerItem: PhotosPickerItem?
    @State private var pickerItems = [PhotosPickerItem]()
//    @State private var selectedImage: Image?
    @State private var selectedImages = [Image]()
    
    var body: some View {
        
        VStack {
            PhotosPicker(/*"Select a picture",*/ selection: $pickerItems, maxSelectionCount: 5, matching: .any(of: [.images, .not(.screenshots)])) { // can be vague or specific regarding types of images.
                Label("Select a picture", systemImage: "photo")
            }
            
//            selectedImage?
//                .resizable()
//                .scaledToFit()
            
            ScrollView {
                ForEach(0..<selectedImages.count, id: \.self) { i in
                    selectedImages[i]
                        .resizable()
                        .scaledToFit()
                }
            }
            
            
        }
        .onChange(of: pickerItems) {
            Task {
                selectedImages.removeAll()
                for item in pickerItems {
                    if let loadedImage = try await item.loadTransferable(type: Image.self) {
                        selectedImages.append(loadedImage)
                    }
                }
                
                //"try" because if user tried to load a video, it would fail!
//                selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
            }
        }
    }
    
}
 */


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
