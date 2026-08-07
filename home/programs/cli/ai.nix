{...}: {
  home.file = {
    ".local/bin/ai" = {
      executable = true;
      text = ''
        #!/bin/sh
        prompt="''${*:-say hello nothing else}"
        curl -sS https://opencode.ai/zen/v1/chat/completions \
          -H "Content-Type: application/json" \
          -d "$(jq -n --arg p "$prompt" '{
            model: "deepseek-v4-flash-free",
            messages: [{role: "user", content: $p}]
          }')" \
          | jq -r .choices[0].message.content
      '';
    };

    ".local/bin/aic" = {
      executable = true;
      text = ''
        #!/bin/sh
        set -euo pipefail

        auto=0
        if [ "''${1:-}" = "-y" ]; then
          auto=1
        fi

        diff="$(git diff HEAD)"
        if [ -z "$diff" ]; then
          echo "No changes to commit." >&2
          exit 1
        fi

        msg="$(gum spin --show-output --spinner line --title "Generating commit message..." -- \
          ai "Here's a git diff: $diff, write a commit message. Use conventional commits. Do not include anything else")"

        if [ -z "$msg" ]; then
          echo "Failed to generate a commit message." >&2
          exit 1
        fi

        echo "$msg"

        if [ "$auto" -eq 1 ]; then
          git commit -am "$msg"
        elif gum confirm "Commit with this message?"; then
          git commit -am "$msg"
        else
          echo "Aborted." >&2
          exit 1
        fi
      '';
    };
  };
}
