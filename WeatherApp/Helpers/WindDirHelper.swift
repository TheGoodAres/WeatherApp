import Foundation

//converts degrees into directions, N, NNE, etc.
func convertDegToCardinal(deg: Int) -> String {
    let cardinalDir = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW", "N"]

    return cardinalDir[Int(round(((Double)(deg % 360)) / 22.5).nextDown) + 1]

}

func returnLongCardinal(cardinal: String) -> String {
    switch cardinal {
    case "N":
        return "North"
    case "NNE":
        return "North North East"
    case "NE":
        return "North East"
    case "ENE":
        return "East North East"
    case "E":
        return "East"
    case "ESE":
        return "East South East"
    case "SE":
        return "South East"
    case "SSE":
        return "South South East"
    case "S":
        return "South"
    case "SSW":
        return "South South West"
    case "SW":
        return "South West"
    case "WSW":
        return "West South West"
    case "W":
        return "West"
    case "WNW":
        return "West North West"
    case "NW":
        return "North West"
    case "NNW":
        return "North North West"
    default:
        return "Unknown"
    }
}
