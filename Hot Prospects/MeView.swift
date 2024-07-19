//
//  MeView.swift
//  Hot Prospects
//
//  Created by Parth Antala on 2024-07-18.
//
import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
    
    @AppStorage("name") private var name = "Anonymous"
    @AppStorage("email") private var email = "you@yoursite.com"
    @State private var qrCode = UIImage()
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Your Details") {
                        TextField("Name", text: $name)
                            .textContentType(.name)
                            
                        
                        
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                           
                        
                    }
                    .listRowBackground(Color.white.opacity(0.5))
                    
                }
                .navigationTitle("Your code")
                .onAppear(perform: updateCode)
                .onChange(of: name, updateCode)
                .onChange(of: email, updateCode)
                .scrollContentBackground(.hidden)
                .frame(height: 200)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.white)
                        .frame(width: 250, height: 250)
                        .shadow(radius: 15)
                        
                    
                    Image(uiImage: qrCode)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(18)
                        
                        
                }
                .contextMenu {
                    ShareLink(item: Image(uiImage: qrCode), preview: SharePreview("My QR Code", image: Image(uiImage: qrCode)))
                }
                    
                
                Spacer()
            }
            .background(LinearGradient(colors: [.orange, .white], startPoint: .top, endPoint: .bottom))
        }
    }
    
    func updateCode() {
        withAnimation(.smooth(duration: 1)) {
            qrCode = generateQRcode(from: "\(name)\n\(email)")
        }
    }
    
    func generateQRcode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
               
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

#Preview {
    MeView()
}
