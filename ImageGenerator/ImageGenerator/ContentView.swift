//
//  ContentView.swift
//  ImageGenerator
//
//  Created by Machint on 14/12/22.
//

import OpenAIKit
import SwiftUI
//import IQKeyboardManager

    
final class ViewModel: ObservableObject {
    private var openai: OpenAI?
    
    func setup(){
        openai = OpenAI(Configuration(organizationId: "personal",apiKey:   "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"))
    }
    
    func  generateImage(prompt: String) async -> UIImage? {
        guard let openai = openai else{
            return nil
        }
        do{
            let params = ImageParameters(prompt: prompt,resolution: .large,responseFormat: .base64Json)
            let result = try await openai.createImage(parameters: params)
            let data = result.data[0].image
            let image = try openai.decodeBase64Image(data)
                return image
                
            }
            catch{
                print(String(describing: error))
                return nil
            }
        }
    }
    
    struct ContentView: View {
        @ObservedObject var viewModel = ViewModel()
        @State var text = ""
        @State var image: UIImage?
        var body: some View {
            NavigationView{
                VStack {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio( contentMode: .fill)
                            .scaledToFit()
                            .frame(width: 250,height: 500)
                    }
                    else {
                        Text("Type a Line about how your Image look like ")
                           
                    }
                    Spacer()
                    TextField("Your Thought about your image..",text: $text)
                        .padding()
                       
                    Button("Generate Image"){
                        if !text.trimmingCharacters(in: .whitespaces).isEmpty{
                            Task{
                               print("Give some time to AI to geet back You with an Image")
                                let result = await viewModel.generateImage(prompt: text)
                                if result  == nil {
                                   print("Failed to get Image!")
                                }
                                self.image = result
                            }
                        }
                        
                    }
                        
                }
               
                .navigationTitle("Image Generator")
                .onAppear{
                  viewModel.setup()
//                    IQKeyboardManager.shared().isEnabled = true
                }
                .padding()
                
                
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

