# SweetIRC
IRC Client for macOS written with Swift and SwiftUI 



## Introductuion

The sofware is written via the new SwiftUI, declarative framework, and it's designed for macOS 13, Ventura.
It makes use of latest featuers in the Swift 5.7 programming language, including Regex, async programming 

### Usage
SweetIRC is meant to be a fast, macOS native, Metal accelarated GUI, offering a native macOS UX.
<figure>
<img width="425" alt="image" src="https://user-images.githubusercontent.com/10388612/197356078-fde45a70-7c1d-4862-98f1-3c43f4fea15d.png">
<figurecaption>The login screen where the user fills data and proceedes to connect to a particular IRC server </figurecaption>
</figure>

### Design

The software design and arhitecture is based on Microsoft's MVVM Design Pattern, orginally developed for Microsoft SilverLight applications and WPF.
SwiftUI can be a great candidate for this pattern, especailly via it's valu type structs that provide immutability by default, it's *Combine framewor*k's
_ObservableObject protocol_ and so on.
