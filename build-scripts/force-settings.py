import json
import os
import shutil
from pathlib import Path

def config_path(which):
    config_dir = os.environ.get("CLAUDE_CONFIG_DIR")

    path_root = Path(config_dir).expanduser() if config_dir else Path.home()

    print(f"config_path {which} -> {path_root / which}")

    return path_root / which


class Config:
    def __init__(self, which):
        self.path = config_path(which)

        self.config = (
            json.loads(self.path.read_text())
            if self.path.exists()
            else {}
        )

    def save(self):
        self.path.parent.mkdir(parents=True, exist_ok=True)

        if self.path.exists():
            shutil.copy2(self.path, self.path.with_name(self.path.name + ".bak"))

        self.path.write_text(json.dumps(self.config, indent=2) + "\n")


ClaudeConfig = Config(".claude.json")

project = "/work"
ClaudeConfig.config["hasCompletedOnboarding"] = True
ClaudeConfig.config["hasSeenAutoDefaultNudge"] = True
ClaudeConfig.config.setdefault("theme", "auto")
ClaudeConfig.config.setdefault("projects", {}).setdefault(project, {})[
    "hasTrustDialogAccepted"
] = True

ClaudeSettings = Config(".claude/settings.json")

ClaudeSettings.config["skipDangerousModePermissionPrompt"] = True

permissions = ClaudeSettings.config.setdefault("permissions", {})
permissions["defaultMode"] = "bypassPermissions"

ClaudeSettings.save()
ClaudeConfig.save()
