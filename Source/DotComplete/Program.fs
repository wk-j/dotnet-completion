// Learn more about F# at http://fsharp.org

open System


type Sln = Sln of Project * Action 
and Project = Project
and Action = 
    | Add of Reference
and Reference =
    | Reference of Project
    | Package of NuGet
and NuGet = string


type Person = { FirstName: string; LastName: string }
type Customer = { FirstName: string; LastName: string ; Id : int }

let inline fullName { Person.FirstName = f; LastName = l} = 
    printfn "%s %s" f l


let person = { FirstName = "F"; LastName = "L"}
let customer = { FirstName = "F"; LastName = "L"; Id = 10 }

let f1 = fullName person


[<EntryPoint>]
let main argv =
    printfn "Hello World from F#!"
    0 // return an integer exit code
