def "nu-complete nix" [buffer, place] {
    let context = $buffer | str substring 0..<$place.cursor
    let spans = $context | split words
    let spans = if ($context | str ends-with " ") {
        $spans | append ""
    } else {
        $spans
    }
    carapace nix nushell ...$spans | from json
}

def --wrapped nix [...args: string@"nu-complete nix"] {
    match ($args | first | default "") {
        "shell" | "develop" | "build" | "run" => { rom ...$args }
        _ => { ^nix ...$args }
    }
}
