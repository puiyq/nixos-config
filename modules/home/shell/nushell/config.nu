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

def resolve-nix-run-arg [arg: string] {
    if ($arg | str starts-with "-") or ($arg | str contains ".") {
        $arg
    } else {
        let fields = $arg | split row "#"
        let flake = $fields | first
        let fragment = $fields | skip 1 | str join "#"
        let result = (^nix flake metadata --json $flake | complete)

        if $result.exit_code != 0 {
            $arg
        } else {
            let locked_url = $result.stdout | from json | get url
            if ($fields | length) > 1 {
                $"($locked_url)#($fragment)"
            } else {
                $locked_url
            }
        }
    }
}

def --wrapped nix [...args: string@"nu-complete nix"] {
    match ($args | first | default "") {
        "shell" | "develop" | "build" => { nom ...$args }
        "run" => {
            let run_args = $args | skip 1 | each {|arg| resolve-nix-run-arg $arg }
            if ($run_args | any {|arg|
        not ($arg | str starts-with "-") and ((^nix path-info --substituters "" $arg | complete).exit_code != 0)
      }) {
                nom build --no-link ...$run_args
            }

            ^nix run ...$run_args
        }
        _ => { ^nix ...$args }
    }
}
